import 'package:flutter/material.dart';
import 'package:fuma_free/pages/widgets/appbar.dart';
import 'package:fuma_free/pages/widgets/textField.dart';
import 'package:fuma_free/pages/widgets/customButton.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Welcome user! Login please",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(
                  height: 30,
                  color: Colors.blue,
                  indent: 30,
                  endIndent: 30,
                  thickness: 3,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  CustomTextField(hintText: "email"),
                  SizedBox(height: 30,),
                  CustomPasswordField(hintText: "pass"),
                  SizedBox(height: 9,),
                  Text("I do not have an account"),
                  SizedBox(height: 30,),
                  CustomButton(text: "Press mee!", onPressed: () => {}),
                ],
              ),
            ),
          ),

        ],
      )
    );
  }
}
