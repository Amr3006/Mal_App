// ignore_for_file: file_names

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';
import 'package:mal_app/Logic/New%20Post%20Cubit/new_post_cubit.dart';
import 'package:mal_app/Logic/Search%20Cubit/search_cubit.dart';
import 'package:mal_app/Shared/Constants/Dimensions.dart';
import 'package:mal_app/Shared/Core/App%20Navigator.dart';
import 'package:mal_app/Shared/Design/Colors.dart';
import 'package:mal_app/Shared/Widgets/ProgressIndicator.dart';
import 'package:mal_app/Shared/Widgets/VerticalListBuilder.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool animationForward = false;
  late FocusNode _node;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _animationController.addStatusListener((status) {
      animationForward = status == AnimationStatus.completed ||
          status == AnimationStatus.forward;
    });
    _node = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    _animationController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPostCubit(),
      child: BlocConsumer<NewPostCubit, NewPostState>(
        listener: (context, state) {
          if (state is SuccessUploadPostState) {
            AppNavigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = NewPostCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  children: [
                    if (cubit.uploadingPost)
                      const LinearProgressIndicator(color: community_color_dark,backgroundColor: community_color_light,),
                    TextFormField(
                      controller: _textEditingController,
                      focusNode: _node,
                      cursorColor: community_color_dark,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write what you want to share"),
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          gridBuilder(cubit.pickedImages[index], cubit),
                      shrinkWrap: true,
                      itemCount: cubit.pickedImages.length,
                    ),
                    Gaps.medium_Gap,
                    ListView.separated(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Gaps.small_Gap,
                      itemBuilder: (context, index) => animeListBuilder(cubit.pickedAnimes[index],cubit),
                      itemCount: cubit.pickedAnimes.length,
                    ),
                    Gaps.medium_Gap
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              actions: [
                MaterialButton(
                    onPressed: () {
                      if (!cubit.uploadingPost) {
                        cubit.post(_textEditingController.text);
                      }
                    },
                    splashColor: community_color_light.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80)),
                    child: const Text(
                      "POST",
                      style: TextStyle(color: community_color_dark),
                    ))
              ],
            ),
            floatingActionButton: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => SizedBox(
                height:
                    _animationController.value == 1 ? screen_height / 2 : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Positioned(
                      bottom: _animationController.value * (screen_height / 6),
                      child: FloatingActionButton.small(
                        onPressed: () {
                          cubit.pickImage();
                          _animationController.reverse();
                        },
                        shape: const CircleBorder(),
                        backgroundColor: secondary_color,
                        child: Icon(
                          FontAwesomeIcons.image,
                          color: main_color,
                          size: 20.r,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: _animationController.value * (screen_height / 12),
                      child: Builder(builder: (context) {
                        return FloatingActionButton.small(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => bottomSheetBuilder(cubit),
                                scrollControlDisabledMaxHeightRatio: 1,
                                useSafeArea: true);
                              _animationController.reverse();
                          },
                          shape: const CircleBorder(),
                          backgroundColor: secondary_color,
                          child: Icon(
                            FontAwesomeIcons.clapperboard,
                            color: main_color,
                            size: 20.r,
                          ),
                        );
                      }),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (animationForward) {
                          _animationController.reverse();
                        } else {
                          _animationController.forward();
                        }
                        _node.unfocus();
                      },
                      shape: const CircleBorder(),
                      backgroundColor: secondary_color,
                      child: Transform.rotate(
                          angle: _animationController.value * (pi / 4),
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: main_color,
                            size: 26.r,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget animeListBuilder(AnimeModel model, NewPostCubit newPostCubit) => Container(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          offset: Offset(4, 4)
        )
      ]
    ),
    foregroundDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(width: 3)
    ),
    child: Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      alignment: Alignment.bottomCenter,
      children: [
        Image.network(model.image!, fit: BoxFit.cover,),
        Positioned(
                  right: 8,
                  top: 8,
                  child: InkWell(
                    onTap: () {
                      newPostCubit.removeAnime(model);
                    },
                    child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor: community_color_light,
                        child: const Icon(Icons.close)),
                  ),
                ),
        Container(
              height: 50.h,
              padding: const EdgeInsetsDirectional.only(start: 20, bottom: 5),
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
                  model.titles!.first.title!,
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                ),
              ),
            )
      ],
    ),
  );

  Widget bottomSheetBuilder(NewPostCubit newPostCubit) => BlocProvider(
        create: (context) => SearchCubit(),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final cubit = SearchCubit.get(context);
            return SizedBox(
              width: screen_width,
              height: screen_height,
              child: Column(
                children: [
                  Gaps.tiny_Gap,
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
                                      browse: false,
                                      onPressed: () {
                                        newPostCubit
                                            .addAnime(cubit.results[index]);
                                        AppNavigator.pop(context);
                                      },
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
            );
          },
        ),
      );

  Widget gridBuilder(XFile file, NewPostCubit newPostCubit) => Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
         decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          offset: Offset(2, 2)
        )
      ]
    ),
    foregroundDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(width: 2)
    ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(file.path),
              fit: BoxFit.cover,
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Positioned(
                  right: 4,
                  top: 4,
                  child: InkWell(
                    onTap: () {
                      newPostCubit.removeImage(file);
                    },
                    child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor: community_color_light,
                        child: const Icon(Icons.close)),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
