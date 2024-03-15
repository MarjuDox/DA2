import 'package:diabetes/core/service/firebase_database_service.dart';
import 'package:diabetes/model/pill_schedule/pill_schedule_model.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/common_widget/shimmerx.dart';
import 'package:diabetes/screens/pill/add_schedule_sheet.dart';
import 'package:diabetes/screens/pill/pill_viewmodel.dart';
import 'package:diabetes/screens/pill/widget/pill_schedule_card.dart';
import 'package:diabetes/screens/sign_in/page/sign_in_page.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PillScheduleSection extends ConsumerWidget {
  const PillScheduleSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillScheduleListAsync =
        ref.watch(pillScheduleListProvider).unwrapPrevious();
    return pillScheduleListAsync.maybeWhen(
      data: (pillScheduleList) {
        return FadeIn(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(pillScheduleListProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: pillScheduleList.length,
              itemBuilder: (context, index) {
                final item = pillScheduleList[index];
                return InkWell(
                  customBorder: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(cornerRadius: 20, cornerSmoothing: 1)),
                  ),
                  onTap: () async {
                    if (item.isExpired) {
                      return;
                    }
                    final User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                      return;
                    }
                    final result =
                        await showModalBottomSheet<PillScheduleModel>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => ModifyScheduleSheet(
                                  userId: user.uid,
                                  schedule: item,
                                ));
                    if (result != null) {
                      FirebaseDatabaseService.addUserSchedule(result)
                          .then((value) {
                        ref.invalidate(pillScheduleListProvider);
                      });
                    }
                  },
                  child: CardX(
                    child: PillScheduleCardContent(item: item),
                  ),
                );
              },
            ),
          ),
        );
      },
      orElse: () {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 12,
          ),
          itemCount: 5,
          itemBuilder: (context, index) => CardX(
            child: ShimmerX(
              child: PillScheduleCardContent(
                item: PillScheduleModel.blank(),
              ),
            ),
          ),
        );
      },
    );
  }
}
