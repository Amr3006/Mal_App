// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/AppNeuButton.dart';


Widget horizontalListBuilder(final model, BuildContext context) {
    bool isAnimeModel = false;
    if (model is AnimeModel) {
      isAnimeModel = true;
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppNeuButton(
        onPressed: () {
          if (isAnimeModel) {
            AppNavigator.push(AppRoutes.detailedAnimeScreen(model), context);
          } else {
            AppNavigator.push(AppRoutes.detailedCharacterScreen(model), context);
          }
        },
        backgroundColor: Colors.white,
        shadowColor: background_shadow_color,
        width: 180.w,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage("${model.image}"),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: 50.h,
              padding: const EdgeInsetsDirectional.only(start: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.black,
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "${isAnimeModel ?  model.titles![0].title : model.name}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }