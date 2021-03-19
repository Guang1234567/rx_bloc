import 'package:bloc_sample/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';

class SearchPage extends StatelessWidget {
  static const searchPage = 'Search page';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PuppyListBloc, PuppyListState>(
        key: const Key(Keys.puppySearchPage),
        builder: (context, state) => RefreshIndicator(
          onRefresh: () {
            context
                .read<PuppyListBloc>()
                .add(ReloadFavoritePuppies(silently: true));
            return Future.delayed(const Duration(seconds: 1));
          },
          child: SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 67),
              itemCount: state.searchedPuppies.length,
              itemBuilder: (context, index) {
                final item = state.searchedPuppies[index];
                // context.read<PuppyListBloc>().searchedPuppies[index];
                return PuppyCard(
                  key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                  // onVisible: (puppy) => context
                  //       .read<PuppiesExtraDetailsBloc>()
                  //       .add(FetchPuppiesExtraDetailsEvent(puppy)),
                  puppy: item,
                );
              },
            ),
          ),
        ),
      );
}
