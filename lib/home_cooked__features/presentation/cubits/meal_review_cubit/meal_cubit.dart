import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:kamn/home_cooked__features/data/models/home_cook_model_test.dart';
import 'package:kamn/home_cooked__features/data/models/meals_model.dart';
import 'package:kamn/home_cooked__features/presentation/cubits/meal_review_cubit/meal_state.dart';

import '../../../data/repositories/home_cook_repository.dart';

@injectable
class MealCubit extends Cubit<MealState> {
  AddHomeCookRepository homeCookRepository;
  MealCubit(this.homeCookRepository)
      : super(MealState(state: MealStatus.initial));

  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController prepController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> addMealKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateMealKey = GlobalKey<FormState>();
  TextEditingController? deliveryFeeController = TextEditingController();
  final deliveryformKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageMeal(int index) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("picker is:$pickedFile");

      final newImages = List<File?>.from(state.mealImages);
      newImages[index] = File(pickedFile.path);
      emit(state.copyWith(
          mealImages: newImages, state: MealStatus.mealImagePicked));
      print("newImages is:$newImages");
      print("mealstate is:${state.mealImages}");
    } else {
      print("picker is null");
    }
  }

  Future<void> uploadMealImages() async {
    emit(state.copyWith(
      state: MealStatus.mealImageLoading,
    ));
    final images = state.mealImages.whereType<File>().toList();
    final uploadResponse =
        await homeCookRepository.uploadMealImages(images, (progress) {
      print("now on $progress");
      // emit(state.copyWith(
      //   state: MealStatus.mealImageLoading,
      //  // uploadProgress: progress,
    });

    uploadResponse.fold(
      (error) {
        emit(state.copyWith(
          state: MealStatus.mealImageError,
          error: error.erorr,
        ));

        print("errorimage is:${error.erorr}");

        return null;
      },
      (newUrls) {
        // final oldUrls = state.selectedMeal?.imageUrls ?? [];

        final List oldUrls = (state.selectedMeal?.imageUrls != null &&
                state.selectedMeal!.imageUrls.isNotEmpty)
            ? state.selectedMeal!.imageUrls
                .where((img) => img.trim().isNotEmpty)
                .toList()
            : [];

        // Combine old and new URLs
        final updatedUrls = [...oldUrls, ...newUrls];

        // Update the meal with the combined image URLs
        updateimgMeal(state.selectedMeal!.copyWith(
          imageUrls: updatedUrls,
        ));

        print("updatedmeal is:${state.selectedMeal}");
      },
    );
  }

  void getMeals(String homeCookId) async {
    emit(state.copyWith(state: MealStatus.loading));
    final result = await homeCookRepository.getMeals(homeCookId);
    result.fold((error) {
      emit(state.copyWith(
        state: MealStatus.error,
        error: error.erorr,
      ));
    }, (myMeal) {
      if (myMeal.isEmpty) {
        emit(state.copyWith(
          state: MealStatus.success,
          myMeals: myMeal,
        ));
        return;
      }
      emit(state.copyWith(
          state: MealStatus.success, myMeals: myMeal, selectedMeal: myMeal[0]));
    });

    // emit(state.copyWith(state: MealStatus.loading));
    // emit(state.copyWith(
    //   state: MealStatus.success,
    //   myMeals: fakeMeals,
    //   selectedMeal: fakeMeals[0],
    // ));
    // homeCookRepository.getMealsStream(homeCookId).listen((result) {
    //   result.fold(
    //     (error) =>
    //         emit(state.copyWith(state: MealStatus.error, error: error.erorr)),
    //     (meals) => emit(state.copyWith(
    //       state: MealStatus.success,
    //       myMeals: meals,
    //       selectedMeal: meals[0],
    //     )),
    //   );
    // });
  }

  void addMeal(MealModel mealModel) async {
    final res = await homeCookRepository.addMealModel(mealModel);
    res.fold(
      (l) =>
          emit(state.copyWith(state: MealStatus.addMealError, error: l.erorr)),
      (r) {
        // final List<MealModel> updatedMeals =
        //     List<MealModel>.from(state.myMeals ?? [])..add(mealModel);

        final List<MealModel> updatedMeals =
            List<MealModel>.from(state.myMeals ?? []);
        updatedMeals.insert(0, mealModel); // insert at index 0 (beginning)

        emit(state.copyWith(
          state: MealStatus.addMealSuccess,
          selectedMeal: mealModel,
          myMeals: updatedMeals,
        ));
      },
    );
  }

  void deleteMeal(MealModel mealModel) async {
    final res =
        await homeCookRepository.deleteMeal(mealModel, "u0cBRLRyHcppREpHYdNf");
    // print("deleteMeal");

    res.fold(
        (l) => emit(
            state.copyWith(state: MealStatus.deleteMealError, error: l.erorr)),
        (r) {
      emit(state.copyWith(
          state: MealStatus.deleteMealSuccess,
          myMeals: state.myMeals
              ?.where((meal) => meal.id != mealModel.id)
              .toList()));
    });
  }

  void updateimgMeal(MealModel mealModel) async {
    final res = await homeCookRepository.updateMealModel(
        mealModel, "u0cBRLRyHcppREpHYdNf");
    res.fold(
        (l) => emit(
            state.copyWith(state: MealStatus.updateMealError, error: l.erorr)),
        (r) {
      final List<MealModel> updatedMeals = (state.myMeals ?? []).map((meal) {
        return meal.id == mealModel.id ? mealModel : meal;
      }).toList();
      emit(state.copyWith(
        state: MealStatus.updateMealSuccess,
        selectedMeal: mealModel,
        myMeals: updatedMeals,
        mealImages: [null, null, null],
      ));
      //  selectNewdMeal(mealModel);
    });
  }

  void selectNewdMeal(MealModel mealModel) {
    emit(state.copyWith(
      selectedMeal: mealModel,
      mealImages: [null, null, null],
      // selectedIngredients: List<String>.from(mealModel.ingredients),
    ));
  }

  void resetFlags() {
    emit(state.copyWith(
      state: MealStatus.success,
    ));
  }

  void resetFlagsOrderOptions() {
    emit(state.copyWith(
      state: MealStatus.addDeliveryOptionInitial,
    ));
  }

/////////////////

  Future<void> uploadDeliveryOption(HomeCookModel homeCookModel) async {
    emit(state.copyWith(state: MealStatus.loading));

    final result = await homeCookRepository
        .updateServiceProviderHomeCookAddDeliveryData(homeCookModel);

    result.fold((error) {
      emit(state.copyWith(
        state: MealStatus.addDeliveryOptionError,
        error: error.erorr,
      ));
    }, (success) {
      log("message updated home: success data");
      emit(state.copyWith(state: MealStatus.addDeliveryOptionSuccess));
    });
  }

  void togglePickupOption(bool isPickupSelected) {
    emit(state.copyWith(isPickupSelected: isPickupSelected));
  }

  void toggleDeliveryOption(bool isDeliverySelected) {
    emit(state.copyWith(isDeliverySelected: isDeliverySelected));
  }

  void initServiceProviderHomeCook(HomeCookModel homeCookModel) {
    emit(state.copyWith(
      homeCookModel: homeCookModel,
    ));
  }

  void selectedMeal(MealModel mealModel) {
    emit(state.copyWith(
      selectedMeal: mealModel,
      selectedIngredients: List<String>.from(mealModel.ingredients),
      specialtyTags: List<String>.from(mealModel.specialtyTags),
    ));
  }

  void clearSelectedMeal() {
    mealNameController.clear();
    prepController.clear();
    kcalController.clear();
    priceController.clear();
    descriptionController.clear();
    emit(state.copyWith(
      selectedMealType: "Breakfast",
      selectedIngredients: [],
      specialtyTags: [],
    ));
  }

///////

  void updateMeal(MealModel mealModel) async {
    final res = await homeCookRepository.updateMealModel(
        mealModel, "u0cBRLRyHcppREpHYdNf");
    res.fold(
        (l) => emit(
            state.copyWith(state: MealStatus.updateMealError, error: l.erorr)),
        (r) {
      final List<MealModel> updatedMeals = (state.myMeals ?? []).map((meal) {
        if (meal.id == mealModel.id) {
          return mealModel; // replace the old meal with the updated one
        } else {
          return meal; // keep others unchanged
        }
      }).toList();

      emit(state.copyWith(
        state: MealStatus.updateMealSuccess,
        selectedMeal: mealModel,
        myMeals: updatedMeals,
      ));
    }
        //  emit(state.copyWith(
        //     state: MealStatus.updateMealSuccess, selectedMeal: mealModel))

        );
  }

  void changeSelectedType(String type) {
    emit(state.copyWith(selectedMealType: type));
  }

  /// Add a specialty tag
  void addSpecialtyTag(String tag) {
    if (!state.specialtyTags.contains(tag)) {
      emit(state.copyWith(specialtyTags: [...state.specialtyTags, tag]));
    }
  }

  /// Remove a specialty tag
  void removeSpecialtyTag(String tag) {
    List<String> updatedTags = List.from(state.specialtyTags);
    updatedTags.remove(tag);
    emit(state.copyWith(specialtyTags: updatedTags));
  }

  void setSpecialtyTags(List<String> tags) {
    emit(state.copyWith(specialtyTags: tags));
  }

// void toggleSelection(String ingredientName) {
//     final updatedIngredients = List<String>.from(state.ingredients);

//     if (updatedIngredients.contains(ingredientName)) {
//       updatedIngredients.remove(ingredientName);
//     } else {
//       updatedIngredients.add(ingredientName);
//     }

//     emit(state.copyWith(ingredients: updatedIngredients));
//     print("Selected Ingredients: ${state.ingredients}");
//   }

  void toggleSelection(String ingredientName) {
    final updatedIngredients = List<String>.from(state.selectedIngredients);

    if (updatedIngredients.contains(ingredientName)) {
      updatedIngredients.remove(ingredientName);
    } else {
      updatedIngredients.add(ingredientName);
    }

    emit(state.copyWith(selectedIngredients: updatedIngredients));
    print("Updated Ingredients: ${state.selectedIngredients}");
  }

  void toggleSelectionforUpdate(String ingredientName) {
    final updatedIngredients = List<String>.from(state.selectedIngredients);

    if (updatedIngredients.contains(ingredientName)) {
      updatedIngredients.remove(ingredientName);
    } else {
      updatedIngredients.add(ingredientName);
    }

    final updatedMeal = state.selectedMeal!.copyWith(
      ingredients: updatedIngredients,
    );

    emit(state.copyWith(
      selectedIngredients: updatedIngredients,
      selectedMeal: updatedMeal,
    ));

    print("Updated Ingredients for Update: $updatedIngredients");
  }
}
