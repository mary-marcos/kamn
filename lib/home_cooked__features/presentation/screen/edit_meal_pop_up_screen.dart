import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamn/core/const/constants.dart';
import 'package:kamn/core/helpers/spacer.dart';
import 'package:kamn/core/helpers/validators.dart';
import 'package:kamn/core/theme/style.dart';
import 'package:kamn/healthy_food_features/data/models/category_data.dart';
import 'package:kamn/home_cooked__features/data/models/meals_model.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_cubit.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_state.dart';
import 'package:kamn/home_cooked__features/presentation/screen/meal_info_screen.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/Food_details_info/custom_homecook_ingredients.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/Food_details_info/custom_meal_type_selection.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/Food_details_info/custom_reqired_txt.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/Food_details_info/custom_specialty_dropdown.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/Food_details_info/custom_txt_field.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/add_home_cook/add_home_cook_info/custom_save_button.dart';

import '../widgets/Food_details_info/custom_homecook_ingredients_for_update.dart';

//edit mafdy basha
class EditMealPopUpScreen extends StatefulWidget {
  @override
  _EditMealPopUpScreenState createState() => _EditMealPopUpScreenState();
}

class _EditMealPopUpScreenState extends State<EditMealPopUpScreen> {
  @override
  Widget build(BuildContext context) {
    final mealCubit = context.read<MealCubit>();
    final selectedMeal = mealCubit.state.selectedMeal;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 50.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
/////////////////////////////////////////////////////

          verticalSpace(8.h),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Meal Type",
                      style: TextStyles.circularSpotify14RegularDarkBlack),
                  verticalSpace(7.h),
                  BlocBuilder<MealCubit, MealState>(
                    builder: (context, state) {
                      return CustomMealTypeSelection(
                        selectedMealType: selectedMeal!.type,
                        //selectedMealType: state.selectedMealType,
                        onMealTypeSelected: (mealType) {
                          mealCubit.changeSelectedType(mealType);
                        },
                      );
                    },
                  ),
                  verticalSpace(12.h),
                  Form(
                    key: mealCubit.updateMealKey,
                    child: Column(children: [
                      customRequiredTxt("Meal Name"),
                      verticalSpace(7.h),
                      CustomTxtField(
                        text: selectedMeal!.name.toString(),
                        hasCounter: false,
                        height: 35.73.h,
                        width: 315.w,
                        hintText: "Enter Meal Name",
                        txtController: mealCubit.mealNameController,
                        valodator: emptyValidator,
                      ),
                      verticalSpace(12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          customRequiredTxt("Prep time"),
                          customRequiredTxt("🔥 ${Constants.kCal}"),
                        ],
                      ),
                      verticalSpace(7.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomTxtField(
                            text: selectedMeal.prepTime.toString(),
                            hasCounter: false,
                            height: 35.73.h,
                            width: 120.w,
                            hintText: "00:00",
                            txtController: mealCubit.prepController,
                            suffixtext: Constants.minute,
                            valodator: numbersValidator,
                          ),
                          CustomTxtField(
                            text: selectedMeal.calories.toString(),
                            hasCounter: false,
                            height: 35.73.h,
                            width: 120.w,
                            hintText: "0",
                            txtController: mealCubit.kcalController,
                            suffixtext: "🔥",
                            valodator: numbersValidator,
                          ),
                        ],
                      ),
                      verticalSpace(12.h),
                      customRequiredTxt("Price"),
                      CustomTxtField(
                        text: selectedMeal.price.toString(),
                        hasCounter: false,
                        height: 35.73.h,
                        width: 315.w,
                        hintText: "Enter price",
                        txtController: mealCubit.priceController,
                        suffixtext: Constants.egp,
                        valodator: numbersValidator,
                      ),
                    ]),
                  ),

                  ///***** TAGS ****///
                  verticalSpace(12.h),
                  customRequiredTxt("Specialty Tags"),
                  verticalSpace(7.h),
                  BlocBuilder<MealCubit, MealState>(
                    builder: (context, state) {
                      return Center(
                        child: CustomSpecialityDropdownWithTags(),
                      );
                    },
                  ),
                  verticalSpace(10.h),
                  Center(
                    child: Text(
                      "Choose tags like Vega, or Keto to help users find your meals.",
                      style: TextStyles.fontCircularSpotify10StealGrayMedium,
                    ),
                  ),
                  verticalSpace(7.h),
                  //CustomSpecialityTags(),
                  verticalSpace(12.h),
                  Text("Ingredients",
                      style: TextStyles.circularSpotify14RegularGreycolor),
                  Text(
                    "List all ingredients used, This helps users with allergies or dietary preferences.",
                    style: TextStyles.fontCircularSpotify8StealGrayRegular,
                  ),
                  verticalSpace(12.h),
// CustomHomecookIngredients(
//   ingredients: ingredients, // Pass all available ingredients
//   selectedIngredients: selectedMeal.ingredients.cast<String>(), // Ensure correct type
// )

                  CustomHomecookIngredientsForUpdate(
                    ingredients: ingredients,
                    selectedIngredients:
                        selectedMeal?.ingredients.cast<String>() ?? [],
                  ),

                  verticalSpace(12.h),
                  Text("Details",
                      style: TextStyles.circularSpotify14RegularDarkBlack),
                  verticalSpace(7.h),
                  CustomTxtField(
                    text: selectedMeal.details.toString(),
                    hasCounter: true,
                    height: 111.h,
                    width: 315.w,
                    hintText: "Enter description",
                    txtController: mealCubit.descriptionController,
                    maxLines: 7,
                  ),
                  verticalSpace(20.h),
                ],
              ),
            ),
          ),

          BlocConsumer<MealCubit, MealState>(
            listener: (context, state) {
              if (state.isUpdateMealLoading) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Text("Updating Meal..."),
                      ],
                    ),
                  ),
                );
              } else if (state.isUpdateMealSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Meal updated successfully!")),
                );
                Navigator.pop(context);

                // Navigator.pop(context);

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => BlocProvider.value(
                //       value: mealCubit,
                //       child: MealInfoScreen(),
                //     ),
                //   ),
                // );
              } else if (state.isUpdateMealError) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
              }
            },
            builder: (context, state) {
              return state.isUpdateMealLoading
                  ? CircularProgressIndicator()
                  : CustomSaveButton(
                      onPressed: () {
                        print("ID: ${selectedMeal.id}");
                        if (mealCubit.updateMealKey.currentState!.validate()) {
                          MealModel updatedMeal = selectedMeal.copyWith(
                            name: mealCubit.mealNameController.text,
                            type: context
                                .read<MealCubit>()
                                .state
                                .selectedMealType,
                            prepTime: int.parse(mealCubit.prepController.text),
                            calories: int.parse(mealCubit.kcalController.text),
                            price: double.parse(mealCubit.priceController.text),
                            ingredients:
                                mealCubit.state.selectedMeal!.ingredients,
                            details: mealCubit.descriptionController.text,
                            id: selectedMeal.id,
                            specialtyTags: mealCubit.state.specialtyTags,
                            imageUrls: [""],
                          );
                          if (updatedMeal == selectedMeal) {
                            return;
                          } else {
                            mealCubit.updateMeal(updatedMeal);
                            print(updatedMeal);
                          }
                        }
                      },
                      //good job you can do it
                      title: Constants.save,
                    );
            },
          ),

          // CustomSaveButton(
          //     onPressed: () {
          //       if (mealCubit.updateMealKey.currentState!.validate()) {
          //         MealModel mealmodel = MealModel(
          //           name: mealCubit.mealNameController.text,
          //           type: context.read<MealCubit>().state.selectedMealType,
          //           prepTime: int.parse(mealCubit.prepController.text),
          //           calories: int.parse(mealCubit.kcalController.text),
          //           price: double.parse(mealCubit.priceController.text),
          //           ingredients: mealCubit.state.ingredients,
          //           details: mealCubit.descriptionController.text,
          //           id: Uuid().v4(),
          //           specialtyTags: mealCubit.state.specialtyTags,
          //           imageUrls: [""],
          //         );
          //         mealCubit.updateMeal(mealmodel);
          //         print(mealmodel);
          //       }
          //     },
          //     title: Constants.addMeal),
          verticalSpace(10.h),
        ],
      ),
    );
  }
}
