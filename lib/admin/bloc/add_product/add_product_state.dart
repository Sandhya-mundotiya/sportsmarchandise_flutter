part of 'add_product_bloc.dart';

class AddProductState extends Equatable {
  final int  catValue;
  final Category selectedCategory;
  final Category selectedSubCategory;
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final TextEditingController subCategoryController;
  final bool isCategory;
  final bool isLoading;
  final List<Asset> images;
  final FocusNode nameFocus;
  final FocusNode descFocus;
  final FocusNode priceFocus;
  final List<Category> categoryList;

  AddProductState({
    this.catValue = 1,
    this.selectedCategory,
    this.selectedSubCategory,
    this.nameController,
    this.descController,
    this.priceController,
    this.categoryController,
    this.subCategoryController,
    this.isCategory = false,
    this.images,
    this.nameFocus,
    this.descFocus,
    this.priceFocus,
    this.categoryList,
    this.isLoading = false,
  });


  factory AddProductState.initial() {
    return AddProductState(

      nameController: TextEditingController(),
      descController: TextEditingController(),
      priceController: TextEditingController(),
      categoryController: TextEditingController(),
      subCategoryController: TextEditingController(),
      nameFocus: FocusNode(),
      descFocus: FocusNode(),
      priceFocus: FocusNode(),
      categoryList: [Category(name: SELECT_VALUE)],
      images: <Asset>[],
    );
  }

  AddProductState update({
    int catValue,
    Category selectedCategory,
    Category selectedSubCategory,
    String nameValue,
    String descValue,
    String priceValue,
    String categoryValue,
    String subCategoryValue,
    List<Category> categoryList,
    FocusNode nameFocus,
    FocusNode descFocus,
    FocusNode priceFocus,
    bool isCategory,
    List<Asset> images,
    bool isLoading,
  }) {
    return copyWith(
      catValue: catValue,
      selectedSubCategory: selectedSubCategory,
      selectedCategory: selectedCategory,
      nameValue: nameValue,
      descValue: descValue,
      priceValue: priceValue,
      categoryValue: categoryValue,
      subCategoryValue: subCategoryValue,
      categoryList: categoryList,
      nameFocus: nameFocus,
      descFocus: descFocus,
      priceFocus: priceFocus,
      isCategory: isCategory,
      images: images,
      isLoading: isLoading,
    );
  }


  AddProductState copyWith({
    int catValue,
    Category selectedCategory,
    Category selectedSubCategory,
    String nameValue,
    String descValue,
    String priceValue,
    String categoryValue,
    String subCategoryValue,
    List<Category> categoryList,
    FocusNode nameFocus,
    FocusNode descFocus,
    FocusNode priceFocus,
    bool isCategory,
    List<Asset> images,
    bool isLoading,
  }) {

    TextEditingController tempNameController = TextEditingController();
    TextEditingController tempDescController = TextEditingController();
    TextEditingController tempPriceController = TextEditingController();
    TextEditingController tempCategoryController = TextEditingController();
    TextEditingController tempSubCategoryController = TextEditingController();

    tempNameController.text = nameValue ?? this.nameController.text;
    tempDescController.text = descValue ?? this.descController.text;
    tempPriceController.text = priceValue ?? this.priceController.text;
    tempCategoryController.text = categoryValue ?? this.categoryController.text;
    tempSubCategoryController.text = subCategoryValue ?? this.subCategoryController.text;


    return AddProductState(
      catValue: catValue ?? this.catValue,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      nameController: tempNameController,
      descController: tempDescController,
      priceController: tempPriceController,
      categoryController: tempCategoryController,
      subCategoryController: tempSubCategoryController,
      categoryList: categoryList ?? this.categoryList,
      nameFocus: nameFocus ?? this.nameFocus,
      descFocus: descFocus ?? this.descFocus,
      priceFocus: priceFocus ?? this.priceFocus,
      isCategory: isCategory ?? this.isCategory,
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [catValue,selectedCategory,selectedSubCategory,nameController,descController,
    priceController,categoryController,subCategoryController,categoryList,nameFocus,descFocus,priceFocus,isCategory,images,isLoading];
}

