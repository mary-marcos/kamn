import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kamn/core/const/icon_links.dart';
import 'package:kamn/core/helpers/spacer.dart';
import 'package:kamn/core/theme/app_pallete.dart';
import 'package:kamn/core/theme/style.dart';
import 'package:kamn/home_cooked__features/data/models/meals_model.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_cubit.dart';
import 'package:kamn/home_cooked__features/presentation/screen/food_etails_info_screen.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/meal_info/custom_speciality_tag.dart';

class CustomTags extends StatelessWidget {
  const CustomTags({
    super.key,
    required this.meal,
  });

  final MealModel meal;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealCubit>();

    void navigateToEditMealScreen(MealModel mealModel) {
      cubit.selectedMeal(mealModel);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: cubit,
          child: const EditMealScreen(),
        ),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "🏷️ Labels: ",
          style: TextStyles.fontCircularSpotify7BlackRegular,
        ),

        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: meal.specialtyTags
                .map((tag) => CustomSpecialityTag(tag))
                .toList(),
          ),
        ),
        horizontalSpace(4),

        // أزرار التعديل والحذف
        Row(
          children: [
            EditDeleteActionsButton(
              icon: IconLinks.penEdit,
              onTap: () {
                //edit
                navigateToEditMealScreen(meal);
              },
            ),
            horizontalSpace(6),
            EditDeleteActionsButton(
              icon: IconLinks.trashBinVector,
              onTap: () {
                print("meal id: ${meal.id}");
                //delete
                context.read<MealCubit>().deleteMeal(
                      meal,
                    );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class EditDeleteActionsButton extends StatelessWidget {
  const EditDeleteActionsButton({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 17.w,
        height: 17.h,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: AppPallete.ofWhiteColor4,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppPallete.greyborder),
        ),
        child: SvgPicture.asset(
          icon,
        ),
      ),
    );
  }
}
