import 'package:cached_network_image/cached_network_image.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/food/equipments.dart';
import 'package:flutter/material.dart';

class EquipmentsListView extends StatelessWidget {
  final List<Equipment> equipments;

  const EquipmentsListView({Key? key, required this.equipments})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(
            width: 26,
          ),
          ...equipments.map((equipment) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.shadow.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://spoonacular.com/cdn/equipment_100x100/${equipment.image}",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      equipment.name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color:
                              context.colorScheme.secondary.withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
