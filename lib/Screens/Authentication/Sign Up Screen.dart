// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Business%20Logic/Sign%20Up%20Cubit/sign_up_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Widgets/AuthenticationFormField.dart';
import 'package:mal_app/Shared/Widgets/NeuText.dart';
import 'package:mal_app/Shared/Widgets/SnackMessage.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

import '../../Shared/Design/Colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Scaffold(
        body: Container(
          width: screen_width,
          height: screen_height,
          color: background_color,
          child: SafeArea(
            child: BlocConsumer<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state is FailedSignUpWithEmailAndPasswordState) {
                  if (state.error == "invalid-email") {
                    snackMessage(context: context, text: "Invalid Email");
                  } else if (state.error == "weak-password") {
                    snackMessage(context: context, text: "Weak Password");
                  } else if (state.error == "email-already-in-use") {
                    snackMessage(context: context, text: "This Email Exists");
                  }
                } else if (state is FailedCreateUserWithEmailAndPasswordState) {
                  print(state.error);
                } else if (state is SuccessCreateUserWithEmailAndPasswordState) {
                  AppNavigator.pop(context);
                  AppNavigator.pushReplacement(AppRoutes.homeScreen, context);
                }
              },
              builder: (context, state) {
                var cubit = SignUpCubit.get(context);
                return Form(
                  key: cubit.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gaps.medium_Gap,
                        NeuText(
                            text: "SIGN UP", fontSize: 60, color: button_color),
                        Gaps.medium_Gap,
                        AuthenticationTextFormField(
                            context: context,
                            controller: cubit.nameController,
                            TextInputType: TextInputType.text,
                            validator_message: "Please enter your name",
                            hint: "Name"),
                        AuthenticationTextFormField(
                            context: context,
                            controller: cubit.phoneController,
                            TextInputType: TextInputType.phone,
                            validator_message: "Please enter your phone",
                            hint: "Phone"),
                        AuthenticationTextFormField(
                            context: context,
                            controller: cubit.emailController,
                            TextInputType: TextInputType.emailAddress,
                            validator_message: "Please enter an e-mail",
                            hint: "E-Mail"),
                        AuthenticationTextFormField(
                            context: context,
                            controller: cubit.passwordController,
                            TextInputType: TextInputType.visiblePassword,
                            validator_message: "Please enter a password",
                            hint: "Password",
                            prefix_icon: FontAwesomeIcons.eye,
                            prefix_function: () {
                              cubit.changeObscurity();
                            },
                            obscured: cubit.obscured),
                        Gaps.large_Gap,
                        Gaps.large_Gap,
                        NeuTextButton(
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.createUser();
                            }
                          },
                          buttonWidth: 200.w,
                          buttonHeight: 60.sp,
                          enableAnimation: true,
                          text: Text(
                            "SIGN UP",
                            style: GoogleFonts.kavoon(
                                color: Colors.white, fontSize: 30.sp),
                          ),
                          buttonColor: font_color,
                        ),
                        Gaps.large_Gap
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
