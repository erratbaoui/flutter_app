
abstract class StringValidator{
  bool isValid(String value);
}

class NoneEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators{
  final StringValidator emailValidator = NoneEmptyStringValidator();
  final StringValidator passwordValidator = NoneEmptyStringValidator();
  final String invalidEmail = 'Email can\' be empty';
  final String invalidPassword = 'Password can\' be empty';
}