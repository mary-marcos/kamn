import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamn/core/const/constants.dart';
import 'package:kamn/core/const/image_links.dart';
import 'package:kamn/core/helpers/spacer.dart';
import 'package:kamn/core/helpers/validators.dart';
import 'package:kamn/core/theme/app_pallete.dart';
import 'package:kamn/core/theme/style.dart';
import 'package:kamn/core/utils/alert_dialog_utils.dart';
import 'package:kamn/home_cooked__features/data/models/home_cook_model_test.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_state.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_Container.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_checkbox_tile.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_home_state.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_navbar.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_order_option_buttons.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_screen_header.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_textfield.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_tittle_text.dart';

import '../cubits/meal_review_cubit/meal_cubit.dart';
import '../widgets/custom_meal_cubit_listner.dart';

//edit
class OrderOptionsHomecook extends StatelessWidget {
  OrderOptionsHomecook({super.key});
  // HomeCookModel();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealCubit>();
    HomeCookModel currentHomeCookModel = cubit.state.homeCookModel!;

    return Scaffold(
        backgroundColor: AppPallete.whiteColor,
        body: CustomMealCubitListner(
          child: Padding(
            padding: EdgeInsets.only(right: 12.w, left: 13.w, top: 30.h),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomScreenHeader(
                      title: "Add Home Cook Data",
                      subTitle: "Set Up Your Home Cook Profile",
                    ),
                    const CustomNavBarOrderOptions(),
                    verticalSpace(10),

                    // Container(
                    //   height: 163.h,
                    //   width: 336.w,
                    //   decoration: const BoxDecoration(
                    //       image: DecorationImage(
                    //           fit: BoxFit.fill,
                    //           image: AssetImage(
                    //             ImageLinks.backgroundstyle,
                    //           ))),
                    // ),

                    CustomHomeState(mealCubit: cubit),

                    verticalSpace(10),
                    Center(
                      child: CustomContainer(
                        width: 335.w,
                        content: Form(
                            key: cubit.deliveryformKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const customTittleText(
                                  title: Constants.pickupor,
                                ),
                                Text(
                                  Constants.howgetmeals,
                                  style: TextStyles.circularSpotify8Grey,
                                ),
                                CustomCheckBoxTile(
                                  onTap: (val) {
                                    cubit.togglePickupOption(val ?? false);
                                  },
                                  title: Constants.pickup,
                                  subtitle: Constants.letCollectHomeAddress,
                                ),
                                divider(95, 95, thick: 6.sp),
                                CustomCheckBoxTile(
                                  onTap: (val) {
                                    cubit.toggleDeliveryOption(val ?? false);
                                  },
                                  title: Constants.delivery,
                                  subtitle: Constants.offerToDeliverMeals,
                                ),
                                const customTittleText(
                                  title: Constants.deliveryFee,
                                ),
                                BlocBuilder<MealCubit, MealState>(
                                    builder: (context, state) {
                                  return CustomCookTextFormFeld(
                                    enabled: state.isDeliverySelected,
                                    controller: cubit.deliveryFeeController,
                                    validator: numbersValidator,
                                    keyboardType: TextInputType.number,
                                    suffixIcon: Text(
                                      Constants.eGP,
                                      style: TextStyles
                                          .fontCircularSpotify12GrayRegular,
                                    ),
                                  );
                                }),
                                Text(
                                  "If you offer delivery, set a fee in EGP — or leave it free!",
                                  style: TextStyles
                                      .fontCircularSpotify10StealGrayMedium,
                                )
                              ],
                            )),
                      ),
                    ),

                    //buttons
                    verticalSpace(30),
                    CustomOrderOptionsBusttons(
                      cubit: cubit,
                      currentHomeCookModel: currentHomeCookModel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
