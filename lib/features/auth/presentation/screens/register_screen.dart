import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../providers/auth_provider.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        // if ( !context.canPop() ) return;
                        context.go('/login');
                      }, 
                      icon: const Icon( Icons.arrow_back_rounded, size: 40, color: Colors.white )
                    ),
                    const Spacer(flex: 1),
                    Text('Crear cuenta', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox( height: 50 ),
    
                Container(
                  height: size.height - 160, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  Widget build(BuildContext context, ref) {
    final registerForm = ref.watch(registerFormProvider);
    final registerFormRead = ref.read(registerFormProvider.notifier);

    final textStyles = Theme.of(context).textTheme;

   ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
    Future.delayed(const Duration(milliseconds: 100));
      showSnackbar(context, next.errorMessage);
    });


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // const SizedBox( height: 50 ),
          const Spacer(flex: 1,),
          Text('Nueva cuenta', style: textStyles.titleMedium ),
          // const SizedBox( height: 50 ),
          const Spacer(),
      
           CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.emailAddress,
            onChanged: registerFormRead.onFullNameChanged,
            errorMessage: registerForm.isFormPosted 
            ? registerForm.fullName.errorMessage
            : null,
          ),
          const SizedBox( height: 30 ),
      
           CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: registerFormRead.onEmailChanged,
            errorMessage: registerForm.isFormPosted 
            ? registerForm.email.errorMessage
            : null,
          ),
          const SizedBox( height: 30 ),
      
           CustomTextFormField(
            label: 'Contraseña',
            obscureText: !registerForm.obscureText,
            onChanged: registerFormRead.onPasswordChanged,
            errorMessage: registerForm.isFormPosted 
            ? registerForm.password.errorMessage 
            : null,
            suffixIcon: IconButton(
              onPressed: (){
                registerFormRead.showPassword();
              },
               icon: registerForm.obscureText
               ? const Icon(Icons.visibility)
               : const Icon(Icons.visibility_off)),
            
          ),
          
          const SizedBox( height: 30 ),
      
           CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: !registerForm.obscureText,
            onChanged: registerFormRead.onRepeatPassword,
            errorMessage: registerForm.isFormPosted ? (registerForm.repeatPassword.value != registerForm.password.value)
            ? 'La contrasena debe ser la misma'
            : null
            : null,
            
          ),
          
          const SizedBox( height: 30 ),
      
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Crear',
              buttonColor: Colors.black,
              onPressed: registerForm.isPosting
              ? null
              : registerFormRead.onFormSumbit
              ,
            )
          ),
      
          const Spacer( flex: 2 ),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: (){
                  if ( context.canPop()){
                    return context.pop();
                  }
                  context.go('/login');
                  
                }, 
                child: const Text('Ingresa aquí')
              )
            ],
          ),
      
          const Spacer( flex: 1),
        ],
      ),
    );
  }
}