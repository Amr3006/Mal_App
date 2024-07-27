// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Logic/Profile%20Cubit/profile_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Core/Assets.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/Seperator.dart';
import 'package:mal_app/Shared/Widgets/SnackMessage.dart';
import 'package:mal_app/Shared/Widgets/VerticalListBuilder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: secondary_color, width: 2));
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is FailedChangeProfilePictureState) {
          snackMessage(context: context, text: "Failed");
        } else if (state is FailedChangeNameState) {
          snackMessage(context: context, text: "Failed");
        } else if (state is FailedLogoutState) {
          snackMessage(context: context, text: "Failed to logout");
        } else if (state is SuccessLogoutState) {
          snackMessage(context: context, text: "Logged out successfully");
          AppNavigator.pushAndRemoveUntil(AppRoutes.loginScreen, context);
        }
      },
      builder: (context, state) {
        final cubit = ProfileCubit.get(context);
        final user = cubit.user;
        return SizedBox(
            width: screen_width,
            child: RefreshIndicator(
              color: main_color,
              onRefresh: () async {
                await cubit.getFavourites();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: Pads.medium_Padding,
                      child: Container(
                        height: screen_width,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              AssetsPaths.profile_cover_image,
                              fit: BoxFit.cover,
                              height: screen_width,
                              width: screen_width,
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                              child: const SizedBox(),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 88.r,
                            ),
                            SizedBox(
                              height: 160.r,
                              width: 160.r,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    backgroundImage:
                                        NetworkImage(user!.profilePicture),
                                    radius: 80.r,
                                  ),
                                  if (state is LoadingChangeProfilePictureState)
                                    SizedBox(
                                        width: 180.r,
                                        height: 180.r,
                                        child: const CircularProgressIndicator(
                                          color: Colors.blueGrey,
                                        )),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: secondary_color,
                                      radius: 20.r,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.changeImage();
                                        },
                                        icon:
                                            const Icon(FontAwesomeIcons.image),
                                        color: main_color,
                                        iconSize: 20.r,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        cursorColor: main_color,
                        controller: cubit.textController..text = user.name,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 30.sp, color: Colors.black),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minLines: 1,
                        enabled: cubit.enabled,
                        decoration: InputDecoration(
                            contentPadding: Pads.medium_Padding,
                            border: outlineInputBorder,
                            enabledBorder: outlineInputBorder,
                            focusedBorder: outlineInputBorder,
                            disabledBorder: InputBorder.none),
                      ),
                    ),
                    Gaps.small_Gap,
                    if (state is LoadingChangeNameState)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                      ),
                    Gaps.tiny_Gap,
                    Padding(
                      padding: Pads.small_Padding,
                      child: SizedBox(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: () {
                                cubit.logout();
                              },
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                foregroundDecoration: BoxDecoration(
                                    border: Border.all(width: 4),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      AssetsPaths.profile_cover_image,
                                      fit: BoxFit.cover,
                                      width: screen_width,
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 20, sigmaY: 10),
                                      child: const SizedBox(),
                                    ),
                                    Text(
                                      "LOGOUT",
                                      style: GoogleFonts.asap(
                                          letterSpacing: 2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.sp),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            Gaps.medium_Gap,
                            Expanded(
                                child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: () {
                                if (cubit.enabled) {
                                  cubit.changeName();
                                } else {
                                  cubit.changeEditMode();
                                }
                              },
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                foregroundDecoration: BoxDecoration(
                                    border: Border.all(width: 4),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      AssetsPaths.profile_cover_image,
                                      fit: BoxFit.cover,
                                      width: screen_width,
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 20, sigmaY: 10),
                                      child: const SizedBox(),
                                    ),
                                    Text(
                                      cubit.enabled ? "SAVE" : "EDIT",
                                      style: GoogleFonts.asap(
                                          letterSpacing: 2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.sp),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Gaps.medium_Gap,
                    HomeTitle("Favourites", fontSize: 20),
                    HSeperator(),
                    Gaps.small_Gap,
                    if (cubit.favourites.isEmpty && cubit.gotFavourites)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Animes you add your to favourites will be shown here",
                          style: GoogleFonts.aBeeZee(
                              fontSize: 18.sp,
                              color: Colors.black.withOpacity(0.65)),
                        ),
                      )
                    else
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              verticalAnimeListBuilder(
                                cubit.favourites[index],
                                context,
                                onPressed: () {},
                              ),
                          separatorBuilder: (context, index) => Gaps.small_Gap,
                          itemCount: cubit.favourites.length),
                    Gaps.large_Gap
                  ],
                ),
              ),
            ));
      },
    );
  }
}
