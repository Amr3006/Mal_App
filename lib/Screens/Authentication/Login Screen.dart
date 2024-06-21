// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_import, file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Business%20Logic/Login%20Cubit/login_cubit.dart';
import 'package:mal_app/Business%20Logic/Sign%20Up%20Cubit/sign_up_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Core/Assets.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/AuthenticationFormField.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Shared/Widgets/NeuText.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/SnackMessage.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: Container(
          height: screen_height,
          color: background_color,
          child: SafeArea(
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is FailedLoginWithEmailAndPasswordState) {
                  if (state.error == 'user-not-found' || state.error == 'invalid-credential') {
                    snackMessage(context: context, text: "No user found for that email.");
                  } else if (state.error == 'wrong-password') {
                    snackMessage(context: context, text: "Wrong Password");
                  } else if (state.error == 'invalid-email') {
                    snackMessage(context: context, text: "Invalid E-mail");
                  }
                } else if (state is SuccessLoginWithEmailAndPasswordState) {
                  AppNavigator.pushReplacement(AppRoutes.homeScreen, context);
                }
              },
              builder: (context, state) {
                var cubit = LoginCubit.get(context);
                return ConditionalBuilder(
                  condition: state is! LoadingLoginWithEmailAndPasswordState,
                  fallback: (context) => AppProgressIndicator(),
                  builder: (context) => SingleChildScrollView(
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gaps.medium_Gap,
                          NeuText(text: "LOGIN", fontSize: 60, color: font_color),
                          Gaps.medium_Gap,
                          AuthenticationTextFormField(
                              context: context,
                              controller: cubit.emailController,
                              TextInputType: TextInputType.emailAddress,
                              validator_message: "Please enter your e-mail",
                              hint: "E-Mail"),
                          AuthenticationTextFormField(
                              context: context,
                              validator_message: "Please enter your password",
                              controller: cubit.passwordController,
                              TextInputType: TextInputType.visiblePassword,
                              hint: "Password",
                              prefix_icon: FontAwesomeIcons.eye,
                              prefix_function: () {
                                cubit.changeObscurity();
                              },
                              obscured: cubit.obscured),
                          Gaps.large_Gap,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 2,
                                  width: 120,
                                  color: Colors.grey,
                                ),
                                Gaps.small_Gap,
                                Text(
                                  "or",
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 18),
                                ),
                                Gaps.small_Gap,
                                Container(
                                  height: 2,
                                  width: 120,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                          Gaps.large_Gap,
                          NeuTextButton(
                              enableAnimation: true,
                              buttonColor: Colors.blue,
                              buttonWidth: 300.w,
                              child: Text(
                                "Login with Facebook",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.white),
                              )),
                          Gaps.medium_Gap,
                          NeuTextButton(
                              onPressed: () {},
                              enableAnimation: true,
                              buttonColor: Colors.white,
                              buttonWidth: 300.w,
                              child: Text(
                                "Login with Google",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp, color: Colors.black),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                  onPressed: () {
                                    AppNavigator.push(
                                        AppRoutes.signUpScreen, context);
                                  },
                                  style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(
                                          font_color.withAlpha(35)),
                                      splashFactory: InkSparkle.splashFactory),
                                  child: Text(
                                    "Create one",
                                    style: TextStyle(color: font_color),
                                  )),
                            ],
                          ),
                          Gaps.large_Gap,
                          Gaps.large_Gap,
                          NeuTextButton(
                            onPressed: () {
                              if (cubit.formKey.currentState!.validate()) {
                                cubit.loginWithEmailAndPassword();
                              }
                            },
                            buttonWidth: 200.w,
                            buttonHeight: 60.sp,
                            enableAnimation: true,
                            buttonColor: button_color,
                            child: Text(
                              "LOGIN",
                              style: GoogleFonts.kavoon(
                                  color: Colors.white, fontSize: 30.sp),
                            ),
                          ),
                          Gaps.large_Gap
                        ],
                      ),
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
