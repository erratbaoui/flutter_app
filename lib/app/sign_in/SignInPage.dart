import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
        dispose: (_, bloc) => bloc.dispose(),
        create: (_) => SignInBloc(auth: auth),
        child: Consumer<SignInBloc>(
          builder: (_, bloc, __) => SignInPage(bloc: bloc),
          //child: SignInPage()),
        ));
  }

  void _showAlert(Exception exception, BuildContext context) {
    showExceptionAlertDialog(context,
        title: 'Sign in failed', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showAlert(e, context);
    }
  }

  void _signInWithEmail(BuildContext context) {
    //final auth = AuthProvider.of(context);
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'OPERATION ABORTED BY USER') _showAlert(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Time tracker",
            textAlign: TextAlign.justify,
          ),
        ),
        elevation: 6,
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(context, snapshot.data);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      //color: Colors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildHeader(isLoading),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: 'Sign in with google',
            textColor: Colors.black87,
            color: Colors.white,
            assetName: 'images/google-logo.png',
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Colors.blue[900],
            assetName: 'images/facebook-logo.png',
            onPressed: isLoading ? null : () {},
          ),
          SizedBox(height: 8),
          SignInButton(
            text: 'Sign in with Email',
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8),
          Text(
            'OR',
            style: TextStyle(color: Colors.black87, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          SignInButton(
            text: 'Sign in anonymously',
            color: Colors.lime[300],
            textColor: Colors.black87,
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    return !isLoading
        ? Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          )
        : Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 40.0,
            ),
          );
  }
}
