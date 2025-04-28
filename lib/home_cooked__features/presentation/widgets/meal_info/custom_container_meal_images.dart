import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kamn/core/const/image_links.dart';
import 'package:kamn/core/theme/app_pallete.dart';
import 'package:kamn/core/theme/style.dart';
import 'package:kamn/core/utils/alert_dialog_utils.dart';
import 'package:kamn/home_cooked__features/data/models/home_cook_model_test.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_cubit.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_state.dart';
import 'package:kamn/home_cooked__features/presentation/screen/add_meal_pop_up_screen.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/meal_info/custom_frame.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/meal_info/custom_meal_list.dart';

class CustomContainerMealImages extends StatelessWidget {
  const CustomContainerMealImages({super.key, required this.mealCubit});
  final MealCubit mealCubit;
  // final List<File?> _images = [null, null, null, null];
  void _openAddMealBottomSheet(BuildContext context, MealCubit cubit) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows the bottom sheet to take full height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) => BlocProvider.value(
              value: cubit,
              child: AddMealPopUpScreen(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomFrame(
        width: double.infinity,
        // heigh: 555.h,
        content:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Meal Images',
              style: TextStyles.fontCircularSpotify14BlackRegular),
          Text(
            'Upload a high-quality photo of your meal.\nBright lighting and simple backgrounds work best!',
            style: TextStyles.fontCircularSpotify8AccentBlackRegular,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 95.h,
            child: BlocBuilder<MealCubit, MealState>(
              builder: (context, state) {
                List<File?> _images = state.mealImages;
                // List imageUrls = state.selectedMeal?.imageUrls ;
                print("imaaaag: ${_images}");

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  //    _images.length,
                  separatorBuilder: (context, index) => SizedBox(width: 16.w),
                  itemBuilder: (context, index) {
                    final File? localImage = state.mealImages.length > index
                        ? state.mealImages[index]
                        : null;

                    final imageUrls = state.selectedMeal?.imageUrls;
                    final String? firestoreUrl = (imageUrls != null &&
                            index >= 0 &&
                            index < imageUrls.length &&
                            imageUrls[index] != null &&
                            imageUrls[index].isNotEmpty)
                        ? imageUrls[index]
                        : null;

                    print("imaaaagurll: $firestoreUrl");
                    // final String? firestoreUrl =
                    //     (state.selectedMeal?.imageUrls != null &&
                    //             state.selectedMeal!.imageUrls!.length > index)
                    //         ? state.selectedMeal!.imageUrls[index]
                    //         : null;
                    // print("imaaaagurll: ${firestoreUrl}");

                    Widget displayedImage;

                    if (localImage != null) {
                      // If a new local image is picked
                      displayedImage = Image.file(
                        localImage,
                        width: 122.w,
                        height: 94.h,
                        fit: BoxFit.cover,
                      );
                    } else if (firestoreUrl != null) {
                      // If an image URL is available from Firestore
                      displayedImage = Image.network(
                        firestoreUrl,
                        width: 122.w,
                        height: 94.h,
                        fit: BoxFit.cover,
                      );
                    } else {
                      // If no image is available, show the static image
                      displayedImage = const CustomStaticImg();
                    }

                    return GestureDetector(
                      onTap: () {
                        if (firestoreUrl != null) {
                        } else {
                          mealCubit.pickImageMeal(index);
                        }
                      },
                      //_pickImage(index),

                      child: DottedBorder(
                        color: Colors.grey.shade400,
                        strokeWidth: 0.5.w,
                        dashPattern: [12, 8], // 6 units dash, 3 units gap
                        borderType: BorderType.RRect,
                        radius: Radius.circular(16.r),
                        child: Container(
                          width: 121.w,
                          height: 94.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              width: 0.5.w,
                              color: AppPallete.ofWhiteColor4,
                            ),
                            color: AppPallete.ofWhiteColor4, // background color
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: displayedImage,
                          ),
                        ),
                      ),
                      // child: Container(
                      //   width: 121.w,
                      //   height: 94.h,
                      //   decoration: BoxDecoration(
                      //     color: AppPallete.ofWhiteColor4,
                      //     borderRadius: BorderRadius.circular(12.r),
                      //     border: Border.all(
                      //       width: 0.2.w,
                      //       color: Colors.grey.shade400,
                      //     ),
                      //   ),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(12.r),
                      //     child: displayedImage,
                      //   ),

                      //   // _images[index] == null
                      //   //     ? CustomStaticImg()
                      //   //     : ClipRRect(
                      //   //         borderRadius: BorderRadius.circular(12.r),
                      //   //         child: Image.file(
                      //   //           _images[index]!,
                      //   //           width: 122.w,
                      //   //           height: 94.h,
                      //   //           fit: BoxFit.cover,
                      //   //         ),
                      //   //       ),
                      // ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              if (mealCubit.state.homeCookModel!.status !=
                  CurrentStatus.ACCEPTED) {
                AlertDialogUtils.showAlert(
                  firstAction: () {
                    Navigator.of(context).pop();
                  },
                  context: context,
                  content:
                      "You can't upload images until your profile is approved.",
                  title: "Profile not approved",
                  firstbutton: "OK",
                );
              } else {
                mealCubit.uploadMealImages();
              }
            },
            child: Container(
              width: double.infinity,
              height: 42.h,
              padding: const EdgeInsets.all(10.64),
              decoration: ShapeDecoration(
                color: const Color(0xFF0C0C0C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(69.20),
                ),
              ),
              child: Text(
                'upload images',
                style: TextStyles.fontCircularSpotify10WhiteMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Introduce Your Meal',
            style: TextStyles.fontCircularSpotify16BlackMedium,
          ),
          Text(
            'Fill in your meal’s name, price, and special details.',
            style: TextStyles.fontCircularSpotify10StealGrayMedium,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              if (mealCubit.state.homeCookModel!.status !=
                  CurrentStatus.ACCEPTED) {
                AlertDialogUtils.showAlert(
                  firstAction: () {
                    Navigator.of(context).pop();
                  },
                  context: context,
                  content:
                      "You can't  add meals until your profile is approved.",
                  title: "Profile not approved",
                  firstbutton: "OK",
                );
              } else {
                _openAddMealBottomSheet(context, mealCubit);
              }
            },
            child: Container(
              width: double.infinity,
              height: 42.h,
              padding: const EdgeInsets.all(10.64),
              decoration: ShapeDecoration(
                color: const Color(0xFF0C0C0C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(69.20),
                ),
              ),
              child: Text(
                'Add meal',
                style: TextStyles.fontCircularSpotify10WhiteMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Text(
              'Meals can be anything you prepare — from breakfast items to special dinners.',
              textAlign: TextAlign.center,
              style: TextStyles.fontCircularSpotify7GreyMedium,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(height: 250.h, child: CustomMealList(cubit: mealCubit)),
        ]),
      ),
    );
  }
}

class CustomStaticImg extends StatelessWidget {
  const CustomStaticImg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          ImageLinks.uploadimg,
          height: 15.h,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppPallete.ofWhiteColor4,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              width: 0.3.w,
              color: Colors.grey.shade400,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2.r,
                offset: Offset(0.h, 1.w),
              ),
            ],
          ),
          child: Text(
            'Choose file',
            style: TextStyles.circularSpotify14RegularDarkBlack,
          ),
        ),
      ],
    );
  }
}
