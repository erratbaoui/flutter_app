import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';



class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  bool _submitted = false;

  bool _isLoading = false;

  var focusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  void _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleForm() {
    setState(() {
      _submitted = false;
      _formType = (_formType == EmailSignInFormType.signIn)
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
      focusNode.requestFocus();
    });
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Not registered? create an account'
        : 'Already have an account? Sign in';
    bool formEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return [
      _buildEmailField(),
      SizedBox(height: 12),
      _buildPasswordField(),
      SizedBox(height: 12),
      FormSubmitButton(
        text: primaryText,
        onPressed: formEnabled ? _submit : null,
      ),
      SizedBox(height: 12),
      FlatButton(
        onPressed: !_isLoading ? _toggleForm : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordField() {
    bool validation =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: validation ? widget.invalidPassword : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      onEditingComplete: _submit,
      onChanged: (password) => _update(),
    );
  }

  TextField _buildEmailField() {
    bool validation = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => focusNode.nextFocus(),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'email@adress.com',
        errorText: validation ? widget.invalidEmail : null,
        enabled: _isLoading == false,
      ),
      focusNode: focusNode,
      onChanged: (email) => _update(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  _update() {
    setState(() {});
  }
}
