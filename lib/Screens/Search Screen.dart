// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Logic/Search%20Cubit/search_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/AppNeuButton.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..initializeScrollListener(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = SearchCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: Pads.medium_Padding,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 2),
                          color: Colors.teal[100],
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(4, 4),
                            )
                          ]),
                      child: TextFormField(
                        controller: cubit.searchController,
                        onChanged: (value) {
                          cubit.getData();
                        },
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp),
                        cursorColor: navigation_bar_color,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 12),
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: cubit.scrollController,
                        itemBuilder: (context, index) =>
                            verticalAnimeListBuilder(cubit.results[index], context),
                            itemCount: cubit.results.length,
                          ),
                  ),
                  if (state is LoadingMoreDataState)
                    AppProgressIndicator(size: 40),
                  if (state is LoadingMoreDataState)
                    Gaps.huge_Gap
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget verticalAnimeListBuilder(AnimeModel model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.r, right: 16.r, bottom: 16.r),
      child: AppNeuButton(
        onPress: () {
          AppNavigator.push(AppRoutes.detailedAnimeScreen(model), context);
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
    );
  }
}
