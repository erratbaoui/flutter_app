enum EmailSignInFormType { register, signIn }
class EmailSignInModel {
  final String email;
  final String password;
  final EmailSignInFormType type;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.type = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
}
