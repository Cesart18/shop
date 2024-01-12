import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/email.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/fullname.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/password.dart';

// final obscureTextProvider = StateProvider<bool>((ref) => false);

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormstate>((ref) {

      final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

class RegisterFormNotifier extends StateNotifier<RegisterFormstate> {

  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({ required this.registerUserCallback}) : super(RegisterFormstate());

  showPassword() {
    final obscureText = state.obscureText;
    state = state.copyWith(obscureText: !obscureText);
  }

  onFullNameChanged(String value) {
    final newFullName = FullName.dirty(value);

    state = state.copyWith(
        fullName: newFullName,
        isValid: Formz.validate([newFullName, state.password, state.email]));
  }

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([newEmail, state.password, state.fullName]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email, state.fullName]));
  }

  onFormSumbit() async {
    _touchEveryField();
  if (!state.isValid) return;
    if (state.password != state.repeatPassword) return;

    state = state.copyWith(isPosting: true);

    await registerUserCallback(state.email.value, state.password.value, state.fullName.value);

    state = state.copyWith(isPosting: false);

  }

  onRepeatPassword(String value) {
    final repeatPassword = Password.dirty(value);
    state = state.copyWith(
        repeatPassword: repeatPassword,
        isValid: Formz.validate(
            [repeatPassword, state.email, state.password, state.fullName]));
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        fullName: fullName,
        isValid: Formz.validate([email, password, fullName]));
  }
}

class RegisterFormstate {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final FullName fullName;
  final Password repeatPassword;
  final bool obscureText;

  RegisterFormstate(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.fullName = const FullName.pure(),
      this.repeatPassword = const Password.pure(),
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
fullName: $fullName
      ''';
  }

  RegisterFormstate copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password,
          FullName? fullName,
          Password? repeatPassword,
          bool? obscureText}) =>
      RegisterFormstate(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password,
          fullName: fullName ?? this.fullName,
          repeatPassword: repeatPassword ?? this.repeatPassword,
          obscureText: obscureText ?? this.obscureText);
}
