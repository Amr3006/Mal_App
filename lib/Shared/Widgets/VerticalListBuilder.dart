// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/AppNeuButton.dart';

Widget verticalAnimeListBuilder(AnimeModel model, BuildContext context,
    {required void Function() onPressed, bool browse = true}) {
  return Padding(
    padding: EdgeInsets.only(left: 16.r, right: 16.r, bottom: 16.r),
    child: Builder(
      builder: (context) {
        return AppNeuButton(
          onPressed: () {
            if (browse) {
              AppNavigator.push(AppRoutes.detailedAnimeScreen(model), context);
            }
            onPressed();
          },
          height: 140.r,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Colors.white,
          child: Padding(
            padding: Pads.small_Padding,
            child: Row(
              children: [
                Container(
                  width: 100.w,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 2),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                          image: NetworkImage(model.image!), fit: BoxFit.cover)),
                ),
                Gaps.medium_Gap,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.tiny_Gap,
                      Text(
                        model.titles![0].title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.firaSans(
                          fontSize: 18.sp,
                        ),
                      ),
                      Gaps.tiny_Gap,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${model.score ?? "Unk."}",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          Gaps.tiny_Gap,
                          RatingBarIndicator(
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: main_color,
                              );
                            },
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.5),
                            rating: (model.score ?? 0) / 2,
                          ),
                        ],
                      ),
                      Text(
                        "Episodes : ${model.episodes ?? "Unkown"}",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    ),
  );
}
