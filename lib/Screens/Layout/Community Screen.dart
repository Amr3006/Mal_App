// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal_app/Data/Models/Post%20Model.dart';
import 'package:mal_app/Logic/Community%20Cubit/community_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/VerticalListBuilder.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        final cubit = CommunityCubit.get(context);
        return RefreshIndicator.adaptive(
          color: community_color_dark,
          backgroundColor: Colors.white,
          onRefresh: () async {
            cubit.postIDs.clear();
            cubit.posts.clear();
            await cubit.getPosts();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      postListBuilder(cubit.posts[cubit.postIDs[index]]!),
                  itemCount: cubit.postIDs.length,
                ),
                Gaps.huge_Gap,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget postListBuilder(PostModel model) {
    DateTime time = DateTime.parse(model.dateTime);
    int year = time.year,
        month = time.month,
        day = time.day,
        hour = time.hour,
        minute = time.minute;
    final urls = model.images;
    final images = urls.map((url) {
      return gridBuilder(url);
    }).toList();
    return Container(
      decoration: const BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(width: 1.5, color: Colors.grey))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Pads.medium_Padding,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: NetworkImage(model.userProfilePic),
                ),
                Gaps.small_Gap,
                Expanded(
                  child: Column(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        model.userName,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "$day/$month/$year $hour:$minute",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: screen_width,
            height: 1.5,
            color: Colors.grey,
          ),
          Padding(
            padding: Pads.medium_Padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.postText,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
                Gaps.small_Gap,
                if (model.animes.isNotEmpty)
                  ListView.builder(
                    itemCount: model.animes.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => verticalAnimeListBuilder(
                          model.animes[index], context,
                          onPressed: () {})),
                  Gaps.small_Gap,
                if (model.images.isNotEmpty)
                  StaggeredGrid.count(
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    crossAxisCount: 2,
                    children: images,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gridBuilder(String image) => Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Image.network(
          repeat: ImageRepeat.repeat,
          image,
          fit: BoxFit.cover,
        ),
      );
}
