import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../models.dart';
import 'skeleton_text.dart';

typedef OnPuppyFavorite = Function(Puppy puppy, bool isFavorite);

const String PuppyCardAnimationTag = 'PuppyCardImageAnimationTag';

class PuppyCard extends StatelessWidget {
  PuppyCard({
    Puppy puppy,
    OnPuppyFavorite onFavorite,
    Function(Puppy) onVisible,
    Function(Puppy) onCardPressed,
    Key key,
  })  : _puppy = puppy,
        _onFavorite = onFavorite,
        _onVisible = onVisible,
        _onCardPressed = onCardPressed,
        super(key: key);

  final Puppy _puppy;
  final OnPuppyFavorite _onFavorite;
  final Function(Puppy) _onVisible;
  final Function(Puppy) _onCardPressed;

  @override
  Widget build(BuildContext context) => _onVisible == null
      ? _buildCard()
      : VisibilityDetector(
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.7) {
              _onVisible(_puppy);
            }
          },
          key: Key("VisiblePuppyCard${_puppy.id}"),
          child: _buildCard(),
        );

  Widget _buildCard() => GestureDetector(
        onTap: () => _onCardPressed?.call(_puppy),
        child: Padding(
          key: Key("PuppyCard${_puppy.id}"),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Card(
            elevation: 2,
            child: ListTile(
              contentPadding: EdgeInsets.only(
                left: 12,
                right: 0,
                top: 8,
                bottom: 4,
              ),
              leading: Hero(
                tag: '$PuppyCardAnimationTag ${_puppy.id}',
                child: CircleAvatar(
                  backgroundImage: AssetImage(_puppy.asset),
                  radius: 26,
                ),
              ),
              title: SkeletonText(
                text: _puppy.displayName,
                height: 19,
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 12),
                child: SkeletonText(
                  text: _puppy.displayCharacteristics,
                  height: 67,
                ),
              ),
              trailing: _puppy.asFavIcon(
                favorite: () => _onFavorite(_puppy, true),
                unfavorite: () => _onFavorite(_puppy, false),
              ),
            ),
          ),
        ),
      );
}

extension _PuppyAsFavIcon on Puppy {
  Widget asFavIcon({VoidCallback favorite, VoidCallback unfavorite}) =>
      isFavorite
          ? IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: unfavorite,
            )
          : IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: favorite,
            );
}
