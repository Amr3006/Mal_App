// ignore_for_file: file_names, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal_app/Logic/Feed%20Cubit/feed_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/HomeTitle.dart';
import 'package:mal_app/Shared/Widgets/HorizontalListBuilder.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/VerticalListBuilder.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        FeedCubit cubit = FeedCubit.get(context);
        return Container(
          width: screen_width,
          child: RefreshIndicator(
            color: main_color,
            onRefresh: () async {
              cubit.clear();
              await Future.wait([
                cubit.getPopularCharacters(),
                cubit.getRecent(),
                cubit.getSeasonAnimes(),
                cubit.getTopAnimes(),
              ]);
            },
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
                          clipBehavior: Clip.none,
                          padding: Pads.medium_Padding,
                          height: 250.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            boxShadow: [BoxShadow(offset: Offset(3, 3))],
                            color: secondary_color,
                            borderRadius: BorderRadiusDirectional.horizontal(
                                start: Radius.circular(12)),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                horizontalListBuilder(
                                    cubit.topAnimes[index], context),
                            separatorBuilder: (context, index) =>
                                Gaps.medium_Gap,
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
                              color: secondary_color,
                              borderRadius: BorderRadiusDirectional.horizontal(
                                  start: Radius.circular(12)),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  horizontalListBuilder(
                                      cubit.popularCharcters[index], context),
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
                  if (cubit.recentAnimes.isNotEmpty)
                    Column(
                      children: [
                        Gaps.small_Gap,
                        HomeTitle("Recently Visited"),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              Gaps.large_Gap,
                              Container(
                                clipBehavior: Clip.none,
                                padding: Pads.medium_Padding,
                                height: 250.h,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  boxShadow: [BoxShadow(offset: Offset(3, 3))],
                                  color: secondary_color,
                                  borderRadius:
                                      BorderRadiusDirectional.horizontal(
                                          start: Radius.circular(12)),
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  clipBehavior: Clip.none,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      horizontalListBuilder(
                                          cubit.recentAnimes[index], context),
                                  separatorBuilder: (context, index) =>
                                      Gaps.medium_Gap,
                                  itemCount: cubit.recentAnimes.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              Gaps.large_Gap,
                            ],
                          ),
                        ),
                      ],
                    ),
                  Gaps.small_Gap,
                  HomeTitle("Season Animes"),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => verticalAnimeListBuilder(
                      cubit.seasonAnimes[index],
                      context,
                      onPressed: () {},
                    ),
                    itemCount: cubit.seasonAnimes.length,
                  ),
                  if (cubit.seasonAnimes.isNotEmpty &&
                      state is LoadingSeasonAnimeState)
                    AppProgressIndicator(size: 40),
                  Gaps.huge_Gap
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
