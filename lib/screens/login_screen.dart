import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  //Cerebro de la lógica de las animaciones
  StateMachineController? controller;
  //SMI: State Machine Input
  SMIBool? isChecking; //Activa el modo chismoso
  SMIBool? isHandsUp; //Se tapa los ojos
  SMITrigger? trigSuccess; //Se emociona
  SMITrigger? trigFail; //Se pone triste
  // 2.1 Variable para recorrido de la mirada
  SMINumber? numLook; // 0..80 en tu asset

  // 1) FocusNode
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //3.2 Crear variable timer para detener la mirada al dejar de teclear
    Timer? _typingDebounce;

  //4.1 Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  //4.2 Errores para mostrar en la UI
  String? emailError;
  String? passError;

  //4.3 Validadores
  bool isValidEmail(String email){
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }
    bool isValidPassword(String pass){
    final re = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    return re.hasMatch(pass);
  }

  //4.4 Acción al botón
  void _onLogin() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

  // Recalcular errores
  final eError = isValidEmail(email) ? null : "Email inválido";
  final pError = isValidPassword(pass)
    ? null
    : "Mínimo 8 carácteres, 1 mayúscula, 1 minúscula, 1 número y 1 caracter especial";

  //Para avisar que hubo un cambio
  setState(() {
    emailError = eError;
    passError = pError;
  });

  // 4.6 Cerrar el teclado y bajar las manos
  FocusScope.of(context).unfocus();
  _typingDebounce?.cancel();
  isChecking?.change(false);
  isHandsUp?.change(false);
  numLook?.value = 50.0; // Mirada neutral

  //4.7 Activar triggers
  if (eError == null && pError == null) {
    trigSuccess?.fire();
  } else {
    trigFail?.fire();
  }
  }

  //2.1 Listeners (Oyentes)
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
    if (emailFocus.hasFocus) {
      //Manos abajo en email
      isHandsUp?.change(false);
      //Mirada neutral al enfocar el email
      numLook?.value = 50;
      isHandsUp?.change(false);
      }
    });
    passFocus.addListener((){
      //Manos arriba en Password
      isHandsUp?.change(passFocus.hasFocus);
    });
  }


  @override
  Widget build(BuildContext context) {
    //Obtener el tamaño de la pantalla del dispositivo
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //Evita el notch o la cámara frontal
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            //Espaciado
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/animated_login_character.riv',
                    stateMachines: ["Login Machine"],
                    //Al iniciarse
                    onInit: (artboard){
                      controller =
                      StateMachineController.fromArtboard(
                        artboard,
                        "Login Machine",
                      );
                      //Verificar que inició bien
                      if(controller == null) return;
                      artboard.addController(controller!);
                      isChecking  = controller!.findSMI('isChecking');
                      isHandsUp   = controller!.findSMI('isHandsUp');
                      trigSuccess = controller!.findSMI('trigSuccess');
                      trigFail    = controller!.findSMI('trigFail');
                      //2.3 Enlazar la variable con la animación
                      numLook     = controller!.findSMI('numLook');
                    },
                    ),
                ),
                //Espacio entre el oso y el texto email
                const SizedBox(height: 10,),
                //Campo de texto del email
                TextField(
                  // 1.3 Asignar el FocusNode al TextfField
                  focusNode: emailFocus,
                  //4.8 Enlazar controlller al TextField
                  controller: emailCtrl,
                  onChanged: (value) {
                    //2.4 Implementando NumLook
                    //Activa el modo
                    isChecking!.change(true);

                    // Ajuste de límites de 0 a 100
                    // 80.0 es una medida de calibración
                    final look = (value.length / 70.0 * 100.0).clamp(0.0, 100.0);
                    numLook?.change(look);

                    //3.3 Debounce: si vuelve a teclear, reinicia el contador
                    _typingDebounce?.cancel(); //Cancela cualquier timer existente
                    _typingDebounce = Timer(const Duration(seconds: 3), () {
                      if(!mounted){
                        return; // Si la pantalla se cierra
                      }
                      //Mirada neutra
                      isChecking?.change(false);
                    });
                  },
                  //Para que aparezca el @ en Móviles UI/UX
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    //4.9 Mostrar errores
                    errorText: emailError,
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                      //esquinas redondeadas
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
                SizedBox(height: 12,),
                  TextField(
                    //Asignas el FocusNode al Textf¿Field
                    focusNode: passFocus,
                    controller: passCtrl,
                    onChanged: (value) {
                    if (isChecking != null){
                      //Reafirma no taparse los ojos al escribir el email
                      //isChecking!.change(false);
                    }
                    if (isHandsUp == null) return;
                    //Activa el modo
                    isHandsUp!.change(true);
                  },
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      //4.9 Mostrar errores
                      errorText: passError,
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox (height: 10),
                  //Texto Olvidé la contraseña como botón
                  SizedBox(
                    width: size.width,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Botón de Login
                  const SizedBox(height: 10),
                  //Botón estilo Android
                  MaterialButton(
                    minWidth: size.width,
                    height: 50,
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    onPressed: _onLogin,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New here?"),
                        TextButton(onPressed: (){}, child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            //Negritas
                            fontWeight: FontWeight.bold,
                            //Subrayado
                            decoration: TextDecoration.underline,
                          )))
                      ],)
                  )
              ],
            ),
          ),
        )
      )
    );
  }
  //Liberación de recursos/Limpieza de Focus
  @override
  void dispose() {
    passCtrl.dispose();
    emailCtrl.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}