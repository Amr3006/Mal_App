// ignore_for_file: file_names, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Business%20Logic/Anime%20Cubit/anime_cubit.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class AnimeScreen extends StatelessWidget {
  const AnimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeCubit, AnimeState>(
      builder: (context, state) {
        AnimeCubit cubit = AnimeCubit.get(context);
        return Container(
          width: screen_width,
          child: Column(
            children: [
              Gaps.large_Gap,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Gaps.large_Gap,
                    Container(
                      padding: Pads.medium_Padding,
                      height: 250.h,
                      decoration: BoxDecoration(
                        color: background_color,
                        borderRadius: BorderRadiusDirectional.horizontal(
                            start: Radius.circular(12)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            topAnimeListBuilder(cubit.topAnimes[index]),
                        separatorBuilder: (context, index) => Gaps.medium_Gap,
                        itemCount: cubit.topAnimes.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget topAnimeListBuilder(AnimeModel model) {
    return InkWell(
      onTap: () {},
      child: NeuCard(
        cardColor: Colors.white,
        shadowColor: background_shadow_color,
        cardWidth: 180.w,
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
              height: 40.h,
              width: 180.w,
              padding: EdgeInsetsDirectional.only(start: 10),
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
                  "${model.titles![0].title}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
