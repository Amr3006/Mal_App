import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal_app/Business%20Logic/Anime%20Details%20Cubit/anime_details_cubit.dart';
import 'package:mal_app/Data/Models/Anime%20Model.dart';

class DetailedAnimeScreen extends StatelessWidget {
  final AnimeModel model;

  const DetailedAnimeScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailedAnimeCubit()..getData(model.malId),
      child: BlocBuilder<DetailedAnimeCubit, DetailedAnimeState>(
        builder: (context, state) {
          return const Placeholder();
        },
      ),
    );
  }
}
