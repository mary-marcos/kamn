import 'dart:io';

import 'package:kamn/home_cooked__features/data/models/home_cook_model_test.dart';
import 'package:kamn/home_cooked__features/data/models/meals_model.dart';

enum MealStatus {
  initial,
  loading,
  success,
  error,
  addMealLoading,
  addMealSuccess,
  addMealError,
  updateMealLoading,
  updateMealSuccess,
  updateMealError,
  addDeliveryOptionInitial,
  addDeliveryOptionSuccess,
  addDeliveryOptionError,
  deleteMealLoading,
  deleteMealSuccess,
  deleteMealError,

  mealImageSuccess,
  mealImageError,
  mealImageLoading,
  mealImagePicked,
}

///

extension MealReviewExtension on MealState {
  bool get isInitial => state == MealStatus.initial;
  bool get isLoading => state == MealStatus.loading;
  bool get isSuccess => state == MealStatus.success;
  bool get isError => state == MealStatus.error;
  bool get isAddMealLoading => state == MealStatus.addMealLoading;
  bool get isAddMealSuccess => state == MealStatus.addMealSuccess;
  bool get isAddMealError => state == MealStatus.addMealError;
  bool get isUpdateMealLoading => state == MealStatus.updateMealLoading;
  bool get isUpdateMealSuccess => state == MealStatus.updateMealSuccess;
  bool get isUpdateMealError => state == MealStatus.updateMealError;
  bool get addDeliveryOptionInitial =>
      state == MealStatus.addDeliveryOptionInitial;
  bool get isAddDeliveryOptionSuccess =>
      state == MealStatus.addDeliveryOptionSuccess;
  bool get isAddDeliveryOptionError =>
      state == MealStatus.addDeliveryOptionError;

  bool get isDeleteMealLoading => state == MealStatus.deleteMealLoading;
  bool get isDeleteMealSuccess => state == MealStatus.deleteMealSuccess;
  bool get isDeleteMealError => state == MealStatus.deleteMealError;

  bool get isMealImageLoading => state == MealStatus.mealImageLoading;
  bool get isMealImageSuccess => state == MealStatus.mealImageSuccess;
  bool get isMealImageError => state == MealStatus.mealImageError;
  bool get isMealImagePicked => state == MealStatus.mealImagePicked;
}

class MealState {
  final MealStatus state;
  final String? error;
  final MealModel? meal;
  final MealModel? selectedMeal;
  final List<MealModel>? myMeals;
  final bool isPickupSelected;
  final bool isDeliverySelected;
  final HomeCookModel? homeCookModel;
  String selectedMealType;
  List<String> specialtyTags = [];
  List<String> ingredients = [];
  List<String> selectedIngredients = [];
  List<File?> mealImages;
  //  final Map<String, List<PlaygroundModel>>? playgroundsMap;

  MealState(
      {required this.state,
      this.error,
      this.meal,
      this.selectedMeal,
      this.myMeals,
      this.homeCookModel,
      this.isPickupSelected = false,
      this.isDeliverySelected = false,
      this.selectedMealType = "Breakfast",
      this.specialtyTags = const [],
      this.ingredients = const [],
      this.selectedIngredients = const [],
      this.mealImages = const [null, null, null]});

  MealState copyWith({
    MealStatus? state,
    String? error,
    HomeCookModel? homeCookModel,
    String? selectedMealType,
    List<String>? specialtyTags,
    bool? isPickupSelected,
    bool? isDeliverySelected,
    MealModel? meal,
    MealModel? selectedMeal,
    List<MealModel>? myMeals,
    List<String>? ingredients,
    List<String>? selectedIngredients,
    List<File?>? mealImages,
    //  Map<String, List<PlaygroundModel>>? playgroundsMap,
  }) {
    return MealState(
      state: state ?? this.state,
      error: error ?? this.error,
      meal: meal ?? this.meal,
      selectedMeal: selectedMeal ?? this.selectedMeal,
      myMeals: myMeals ?? this.myMeals,
      homeCookModel: homeCookModel ?? this.homeCookModel,
      isPickupSelected: isPickupSelected ?? this.isPickupSelected,
      isDeliverySelected: isDeliverySelected ?? this.isDeliverySelected,
      selectedMealType: selectedMealType ?? this.selectedMealType,
      specialtyTags: specialtyTags ?? this.specialtyTags,
      ingredients: ingredients ?? this.ingredients,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      mealImages: mealImages ?? this.mealImages,

      // playgroundsMap: playgroundsMap ?? this.playgroundsMap,
    );
  }

  @override
  String toString() {
    return 'MealState{state: $state, error: $error, meal: $meal, selectedMeal: $selectedMeal, myMeals: $myMeals, homeCookModel: $homeCookModel, selectedMealType: $selectedMealType, specialtyTags: $specialtyTags, ingredients: $ingredients, selectedIngredients: $selectedIngredients, isPickupSelected: $isPickupSelected, isDeliverySelected: $isDeliverySelected}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MealState &&
        other.state == state &&
        other.error == error &&
        other.meal == meal &&
        other.selectedMeal == selectedMeal &&
        other.myMeals == myMeals &&
        other.homeCookModel == homeCookModel &&
        other.selectedMealType == selectedMealType &&
        other.specialtyTags == specialtyTags &&
        other.ingredients == ingredients &&
        other.selectedIngredients == selectedIngredients &&
        other.isPickupSelected == isPickupSelected &&
        other.mealImages == mealImages &&
        other.isDeliverySelected == isDeliverySelected;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        error.hashCode ^
        meal.hashCode ^
        selectedMeal.hashCode ^
        myMeals.hashCode ^
        homeCookModel.hashCode ^
        selectedMealType.hashCode ^
        specialtyTags.hashCode ^
        ingredients.hashCode ^
        selectedIngredients.hashCode ^
        mealImages.hashCode ^
        isDeliverySelected.hashCode;
  }
}
