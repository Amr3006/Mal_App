// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Logic/Search%20Cubit/search_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Core/App%20Routes.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/VerticalListBuilder.dart';

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
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          cubit.getData();
                        },
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp),
                        cursorColor: main_color,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 12),
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Expanded(
                    child: state is LoadingDataState
                        ? AppProgressIndicator()
                        : RefreshIndicator(
                            color: main_color,
                            onRefresh: () async {
                              await cubit.getData();
                            },
                            child: SingleChildScrollView(
                              controller: cubit.scrollController,
                              child: Column(
                                children: [
                                  if (cubit.gotSearch && cubit.results.isEmpty)
                                    const Text("There is no results to show"),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        verticalAnimeListBuilder(
                                      cubit.results[index],
                                      context,
                                      onPressed: () {},
                                    ),
                                    itemCount: cubit.results.length,
                                  ),
                                  if (state is LoadingMoreDataState)
                                    AppProgressIndicator(size: 40),
                                  if (state is LoadingMoreDataState)
                                    Gaps.medium_Gap
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
