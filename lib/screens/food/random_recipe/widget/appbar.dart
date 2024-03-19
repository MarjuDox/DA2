import 'package:cached_network_image/cached_network_image.dart';
import 'package:diabetes/core/animation/animation.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/food/recipe.dart';
import 'package:diabetes/screens/food/random_recipe/widget/favorite_bottom.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Recipe info;
  MySliverAppBar({
    required this.expandedHeight,
    required this.info,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: maxExtent),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        //overflow: Overflow.visible,
        children: [
          Positioned(
              child: Container(
            color: context.colorScheme.primary,
            child: Opacity(
              opacity: (1 - shrinkOffset / expandedHeight),
              child: Stack(
                children: [
                  const SizedBox(
                    height: 300,
                  ),
                  Positioned(
                    child: CachedNetworkImage(
                      imageUrl: info.image!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          )),
          AppBarWidget(
            expandedHeight: expandedHeight,
            shrinkOffset: shrinkOffset,
            info: info,
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Opacity(
                opacity: (1 - shrinkOffset / expandedHeight),
                child: DelayedDisplay(
                  delay: const Duration(microseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: kElevationToShadow[1],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              info.spoonacularScore!
                                  .roundToDouble()
                                  .toStringAsFixed(2),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.star_rounded,
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                      ),
                      FavoriteButton(info: info)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 25;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: maxExtent,
      );
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    Key? key,
    required this.expandedHeight,
    required this.shrinkOffset,
    required this.info,
  }) : super(key: key);

  final double expandedHeight;
  final double shrinkOffset;
  final Recipe info;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  Future<Uri> data() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://diabetesdemo.page.link/',
      link: Uri.parse(
          'https://diabetesdemo.page.link/demo/?id=${widget.info.id}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.da2.diabetes.diabetes',
        minimumVersion: 125,
      ),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: widget.info.title,
        description: widget.info.summary,
        imageUrl: Uri.parse(widget.info.image!),
      ),
    );

    // final Uri dynamicUrl = await parameters.buildURl();
    // final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    //   dynamicUrl,
    //   DynamicLinkParametersOptions(
    //       shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    // );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri shortUrl = dynamicLink.shortUrl;
    return shortUrl;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: Navigator.of(context).maybePop,
        icon: Icon(CupertinoIcons.back, color: context.colorScheme.onPrimary),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final url = await data();
            Share.share(
              'check out This tasty recipe $url',
            );
          },
          icon:
              Icon(CupertinoIcons.share, color: context.colorScheme.onPrimary),
        )
      ],
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Recipe Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
