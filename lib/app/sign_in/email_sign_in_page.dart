import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_stateful.dart';



class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<AuthBase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Time tracker"),
        elevation: 6,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormStateful(),
          ),
        ),
      ),
    );
  }


}
