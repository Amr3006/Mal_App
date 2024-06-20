// ignore_for_file: file_names, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Business%20Logic/Feed%20Cubit/feed_cubit.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class AnimeScreen extends StatelessWidget {
  const AnimeScreen.AnimeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        FeedCubit cubit = FeedCubit.get(context);
        return Container(
          width: screen_width,
          child: SingleChildScrollView(
            controller: cubit.scrollController,
            child: Column(
              children: [
                HomeTitle("Top Animes"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      Gaps.large_Gap,
                      Container(
                        padding: Pads.medium_Padding,
                        height: 250.h,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          boxShadow: [BoxShadow(offset: Offset(3, 3))],
                          color: background_color,
                          borderRadius: BorderRadiusDirectional.horizontal(
                              start: Radius.circular(12)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              horizontalListBuilder(cubit.topAnimes[index]),
                          separatorBuilder: (context, index) => Gaps.medium_Gap,
                          itemCount: cubit.topAnimes.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Gaps.large_Gap,
                    ],
                  ),
                ),
                Gaps.small_Gap,
                HomeTitle("Popular Characters"),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        Gaps.large_Gap,
                        Container(
                          padding: Pads.medium_Padding,
                          height: 250.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            boxShadow: [BoxShadow(offset: Offset(3, 3))],
                            color: background_color,
                            borderRadius: BorderRadiusDirectional.horizontal(
                                start: Radius.circular(12)),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                horizontalListBuilder(cubit.popularCharcters[index]),
                            separatorBuilder: (context, index) =>
                                Gaps.medium_Gap,
                            itemCount: cubit.popularCharcters.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        Gaps.large_Gap,
                      ],
                    ),
                  ),
                ),
                Gaps.small_Gap,
                HomeTitle("Season Animes"),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      seasonAnimeListBuilder(cubit.seasonAnimes[index]),
                  itemCount: cubit.seasonAnimes.length,
                ),
                if (cubit.seasonAnimes.isNotEmpty &&
                    state is LoadingSeasonAnimeState)
                  AppProgressIndicator(size: 40),
                Gaps.huge_Gap
              ],
            ),
          ),
        );
      },
    );
  }

  Widget seasonAnimeListBuilder(AnimeModel model) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: Pads.medium_Padding,
        child: NeuCard(
          borderRadius: BorderRadius.circular(4),
          cardHeight: 140.r,
          cardColor: Colors.white,
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
                          image: NetworkImage(model.image!),
                          fit: BoxFit.cover)),
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
                                color: navigation_bar_color,
                              );
                            },
                            itemCount: 5,
                            itemSize: 18,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
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
        ),
      ),
    );
  }

  Widget horizontalListBuilder(final model) {
    bool isAnimeModel = false;
    if (model is AnimeModel) {
      isAnimeModel = true;
    }
    return InkWell(
      onTap: () {},
      child: Directionality(
        textDirection: TextDirection.ltr,
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
                    "${isAnimeModel ?  model.titles![0].title : model.name}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
