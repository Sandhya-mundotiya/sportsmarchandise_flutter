part of 'edit_category_bloc.dart';

class EditCategoryState extends Equatable {


  final int catValue;
  final Category selectedCatOrSubCat;
  final Category selectedCategory;
  final TextEditingController nameController;
  final TextEditingController descController;
  final List<Category> categoryList;
  final FocusNode nameFocus;
  final FocusNode descFocus;
  final bool isLoading;
  final bool isEnable;

  EditCategoryState({
    this.catValue = 1,
    this.isLoading = false,
    this.isEnable = false,
    this.selectedCatOrSubCat,
    this.selectedCategory,
    this.nameController,
    this.descController,
    this.categoryList,
    this.nameFocus,
    this.descFocus,
  });

  factory EditCategoryState.initial() {
    return EditCategoryState(
        selectedCatOrSubCat: Category(name: SELECT_VALUE),
        selectedCategory: Category(name: SELECT_VALUE),
        nameController: TextEditingController(),
        descController: TextEditingController(),
        nameFocus: FocusNode(),
      descFocus: FocusNode()
    );
  }

  EditCategoryState update({
    int catValue,
    Category selectedCatOrSubCat,
    Category selectedCategory,
    String nameValue,
    String descValue,
    List<Category> categoryList,
    FocusNode nameFocus,
    bool isLoading,
    bool isEnable,
    FocusNode descFocus
  }) {
    return copyWith(
      catValue: catValue,
      selectedCatOrSubCat: selectedCatOrSubCat,
      selectedCategory: selectedCategory,
      nameValue: nameValue,
      descValue: descValue,
      categoryList: categoryList,
      nameFocus: nameFocus,
      descFocus: descFocus,
      isLoading: isLoading,
        isEnable: isEnable
    );
  }

  EditCategoryState copyWith({
    int catValue,
    Category selectedCategory,
    Category selectedCatOrSubCat,
    String nameValue,
    String descValue,
    List<Category> categoryList,
    FocusNode nameFocus,
    FocusNode descFocus,
    bool isLoading,
    bool isEnable,
  }) {

    TextEditingController tempNameController = TextEditingController();
    TextEditingController tempDescController = TextEditingController();

    tempNameController.text = nameValue ?? this.nameController.text;
    tempDescController.text = descValue ?? this.descController.text;


    return EditCategoryState(
      catValue: catValue ?? this.catValue,
      selectedCatOrSubCat: selectedCatOrSubCat ?? this.selectedCatOrSubCat,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      nameController: tempNameController,
      descController: tempDescController,
      categoryList: categoryList ?? this.categoryList,
      nameFocus: nameFocus ?? this.nameFocus,
      isLoading: isLoading ?? this.isLoading,
      descFocus: descFocus ?? this.descFocus,
      isEnable: isEnable ?? this.isEnable,
    );
  }


  @override
  List<Object> get props => [catValue,selectedCatOrSubCat,nameController,descController,categoryList,nameFocus,descFocus,];
}
