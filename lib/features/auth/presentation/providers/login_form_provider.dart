

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


//! 3 - StateNotifierProvider - consume afuera
// * se usa el autodispose para que se destruya una vez vuelva a la pantalla de login

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {

  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  

  return LoginFormNotifier(loginUserCallback: loginUserCallback,);
});


//! 2 - Como implemento un notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {

  final Function(String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback
  }) : super(LoginFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSumbit() async{
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback( state.email.value, state.password.value );

    state = state.copyWith(isPosting: false);

  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }

  showPassword(){
    state = state.copyWith(
      obscureText: !state.obscureText
    );

  }


}




//! 1 - State - como quiero que luzca el estado

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final bool obscureText;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.obscureText = false});

  @override
  String toString() {
    return '''
LoginFormState:
isPosting: $isPosting
isFormPoster: $isFormPosted
isValid: $isValid
email: $email
password: $password
      ''';
  }

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    bool? obscureText
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        obscureText: obscureText ?? this.obscureText
      );
}

