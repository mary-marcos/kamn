import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamn/core/routing/routes.dart';
import 'package:kamn/home_cooked__features/presentation/screen/meal_review_screen.dart';
import 'package:kamn/home_cooked__features/presentation/widgets/order_options/custom_button.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/helpers/spacer.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/style.dart';
import '../../../../core/utils/alert_dialog_utils.dart';
import '../../../data/models/delivery_model.dart';
import '../../../data/models/home_cook_model_test.dart';
import '../../cubits/meal_review_cubit/meal_cubit.dart';

class CustomOrderOptionsBusttons extends StatelessWidget {
  const CustomOrderOptionsBusttons({
    super.key,
    required this.cubit,
    required this.currentHomeCookModel,
  });
  final MealCubit cubit;
  final HomeCookModel currentHomeCookModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          onTap: () {
            Navigator.pop(context);
            /////////////////////////////////////////////
            // log("hoooooomeee model: ${cubit.state.homeCookModel}");
          },
          backcolor: AppPallete.ofWhiteColor,
          content: [
            const Icon(
              Icons.arrow_back_rounded,
            ),
            Text(
              Constants.back,
              style: TextStyles.fontCircularSpotify16BlackRegular,
            ),
          ],
        ),
        horizontalSpace(10),
        CustomButton(
            onTap: () {
              if (cubit.state.homeCookModel!.status == CurrentStatus.ACCEPTED) {
                if (cubit.state.isDeliverySelected ||
                    cubit.state.isPickupSelected) {
                  if (cubit.state.isDeliverySelected) {
                    // validate the delivery fee text field
                    //validate only if the delivery option is selected
                    if (cubit.deliveryformKey.currentState!.validate()) {
                      UpdateDeliveryData();
                    }
                  } else {
                    UpdateDeliveryData();
                  }
                } else {
                  // alert if checkbox is not selected
                  AlertDialogUtils.showAlert(
                      context: context,
                      title: "Error",
                      content: "Please select one option at least!");
                }
              } else {
                AlertDialogUtils.showAlert(
                  firstAction: () {
                    Navigator.of(context).pop();
                  },
                  context: context,
                  content:
                      "You can't add Order Option until your profile is approved.",
                  title: "Profile not approved",
                  firstbutton: "OK",
                );
              }
            },
            backcolor: AppPallete.blackColor,
            content: [
              Text(
                Constants.next,
                style: TextStyles.fontCircularSpotify16LightRegular,
              ),
              const Icon(
                Icons.arrow_forward,
                color: AppPallete.ofWhiteColor,
              ),
            ])
      ],
    );
  }

  UpdateDeliveryData() {
    cubit.uploadDeliveryOption(
      currentHomeCookModel.copyWith(
        delivery: DeliveryModel(
            isDelivery: cubit.state.isDeliverySelected,
            isPickup: cubit.state.isPickupSelected,
            deliveryFee: cubit.deliveryFeeController!.text.isEmpty
                ? null
                : double.tryParse(cubit.deliveryFeeController!.text)),
      ),
    );
  }
}
