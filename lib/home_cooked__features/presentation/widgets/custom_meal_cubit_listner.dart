import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_state.dart';
import 'package:kamn/home_cooked__features/presentation/screen/meal_review_screen.dart';
import '../../../core/utils/alert_dialog_utils.dart';
import '../cubits/meal_review_cubit/meal_cubit.dart';

class CustomMealCubitListner extends StatelessWidget {
  final Widget child;

  const CustomMealCubitListner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealCubit, MealState>(
        listener: (context, state) {
          final cubit = context.read<MealCubit>();
          if (state.isAddDeliveryOptionSuccess) {
            //Navigator.of(context).pop(); // Close the loading dialog
            // AlertDialogUtils.showAlert(
            //   context: context,
            //   content: "Delivery option added successfully!",
            //   title: "Success",
            // );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Delivery option added successfully!"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );

            cubit.resetFlagsOrderOptions();

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                    value: cubit, child: MealReviewScreen())));
          } else if (state.isAddDeliveryOptionError) {
            Navigator.of(context).pop();
            AlertDialogUtils.showAlert(
              context: context,
              content: state.error ?? "Error",
              title: "Error",
              firstbutton: "OK",
            );
            cubit.resetFlagsOrderOptions();
          }
          //  else if (state.isAddDeliveryOptionLoading) {
          //   AlertDialogUtils.showAlert(
          //     context: context,
          //     content: "loading",
          //     title: "loading",
          //   );
          // }
        },
        child: child);
  }
}
