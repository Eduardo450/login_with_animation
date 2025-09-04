import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    //Obtener el tama;o de la pantalla del dispositivo
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Evita el notch o la cámara frontal
      body: SafeArea(
        child: Padding(
          //Espaciado
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset('assets/animated_login_character.riv')
              ),
              //Espacio entre el oso y el texto email
              const SizedBox(height: 10,),
              //Campo de texto del email
              TextField(
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
            ],
          ),
        )
      )
    );
  }
}