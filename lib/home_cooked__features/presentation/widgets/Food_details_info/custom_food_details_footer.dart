import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamn/core/const/constants.dart';
import 'package:kamn/core/const/image_links.dart';
import 'package:kamn/core/helpers/spacer.dart';
import 'package:kamn/core/theme/app_pallete.dart';
import 'package:kamn/core/theme/style.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_cubit.dart';
import 'package:kamn/home_cooked__features/presentation/screen/edit_meal_pop_up_screen.dart';

class CustomFoodDetailsFooter extends StatelessWidget {
  const CustomFoodDetailsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealCubit>();
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled:
                    true, // Allows the bottom sheet to take full height
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                ),
                builder: (context) => BlocProvider.value(
                      value: cubit,
                      child: EditMealPopUpScreen(),
                    ));
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(160.w, 50.h),
            foregroundColor: AppPallete.whiteColor,
            backgroundColor: AppPallete.orangeColor,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageLinks.editPin, width: 14.w, height: 14.h),
              horizontalSpace(10.w),
              Text(
                Constants.edit,
                style: TextStyles.fontCircularSpotify14WhiteMedium,
              ),
            ],
          ),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(160.w, 50.h),
            foregroundColor: AppPallete.whiteColor,
            backgroundColor: AppPallete.blackColor,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageLinks.check, width: 14.w, height: 14.h),
              horizontalSpace(10.w),
              Text(
                Constants.save,
                style: TextStyles.fontCircularSpotify14WhiteMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
