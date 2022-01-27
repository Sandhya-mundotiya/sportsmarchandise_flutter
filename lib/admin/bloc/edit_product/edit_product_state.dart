part of 'edit_product_bloc.dart';

class EditProductState extends Equatable {

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
  final List<String> imagesNetwork;
  final FocusNode nameFocus;
  final FocusNode descFocus;
  final FocusNode priceFocus;
  final List<Category> categoryList;

  EditProductState({
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
    this.imagesNetwork,
  });


  factory EditProductState.initial() {
    return EditProductState(

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
      imagesNetwork: [],
    );
  }

  EditProductState update({
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
    List<String> imagesNetwork,
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
      imagesNetwork: imagesNetwork,
    );
  }


  EditProductState copyWith({
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
    List<String> imagesNetwork,
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


    return EditProductState(
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
      imagesNetwork: imagesNetwork ?? this.imagesNetwork,
    );
  }

  @override
  List<Object> get props => [catValue,selectedCategory,selectedSubCategory,nameController,descController,
    priceController,categoryController,subCategoryController,categoryList,nameFocus,descFocus,priceFocus,isCategory,images,isLoading,imagesNetwork];
}

