import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/auth_controller.dart';
class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.find();

   LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              width: 343,
              height: 56,
              decoration: BoxDecoration(
                  color: const Color(0xfffffffff),
                  borderRadius: BorderRadius.circular(16),
                  border:
                  Border.all(width: 1, color: const Color(0xffff1f1fa))),
              child: TextField(onChanged: (value) => controller.email.value = value,decoration: const InputDecoration(hintText: 'Email',
                hintStyle:TextStyle(color: Color(0xfff91919f),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter'),
                border: InputBorder.none,),),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              width: 343,
              height: 56,
              decoration: BoxDecoration(
                  color: const Color(0xfffffffff),
                  borderRadius: BorderRadius.circular(16),
                  border:
                  Border.all(width: 1, color: const Color(0xffff1f1fa))),
              child: TextField(onChanged: (value) => controller.password.value = value,decoration: const InputDecoration(hintText: 'Password',
                hintStyle:TextStyle(color: Color(0xfff91919f),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'inter'),
                border: InputBorder.none,),),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){ controller.login();},
              child: Container(alignment: Alignment.center,height:56,width:343,
                decoration: BoxDecoration(color: const Color(0xfff7f3dff),
                    borderRadius: BorderRadius.circular(16)),
                child: const Text('Login',style: TextStyle(color: Colors.white,fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'inter'
              ),),),
            ),
            const SizedBox(height: 15,),

            Text.rich(TextSpan(children: [
              const TextSpan(text: "Don't have an account?",
                  style: TextStyle(fontSize: 16,
                      fontFamily: 'inter',
                      color: Color(0xfff91919f),
                      fontWeight: FontWeight.w500
                  )),
              TextSpan(text: " Sign Up",style: const TextStyle(fontWeight: FontWeight.w500,
                  fontFamily: 'inter',
                  fontSize: 16,
                  color: Color(0xfff7f3dff)

              ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                   Get.toNamed('/register');
                  },)

            ])),

          ],
        ),
      ),
    );
  }
}