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

  //Crear variable timer para detener la mirada al dejar de teclear
    Timer? _typingDebounce;

  // 1) FocusNode
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //2) Listeners (Oyentes)
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
                  //Asignas el FocusNode al TextfField
                  focusNode: emailFocus,
                  onChanged: (value) {
                    if (isHandsUp != null){
                      //Reafirma no taparse los ojos al escribir el email
                      //isHandsUp!.change(false);
                    }
                    if (isChecking == null) return;
                    //Activa el modo
                    isChecking!.change(true);

                    // Ajuste de límites de 0 a 100
                    // 80.0 es una medida de calibración
                    final look = (value.length /  100.0 * 100.0).clamp(0.0, 100.0);
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
                    onPressed: (){},
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
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}