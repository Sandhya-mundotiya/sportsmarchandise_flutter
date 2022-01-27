part of 'product_bloc.dart';

class ProductState extends Equatable {

  final List<Product> products;
  final List<Category> categories;
  final Category category;
  final Category subCategory;
  final TextEditingController createdDateController;
  final String createdDate;
  final bool isLoading;


   ProductState({this.products,this.category,this.categories,this.subCategory,this.createdDate = "",this.createdDateController,this.isLoading = true});


  factory ProductState.initial() {
    return ProductState(

      products: [],
      categories: [],
      category: Category(name: SELECT_VALUE),
      subCategory: Category(name: SELECT_VALUE),
      createdDateController: TextEditingController(),
    );
  }

  ProductState update({
    List<Product> products,
    List<Category> categories,
    Category category,
    Category subCategory,
    String createdDate,
    bool isLoading,
  }) {

    TextEditingController tempCreatedDateController = TextEditingController();

    tempCreatedDateController.text = createdDate;

    return copyWith(
      products: products,
      categories: categories,
      category: category,
      subCategory: subCategory,
      createdDateController: tempCreatedDateController,
      createdDate: createdDate,
      isLoading: isLoading,
    );
  }


  ProductState copyWith({
    List<Product> products,
    List<Category> categories,
    Category category,
    Category subCategory,
    TextEditingController createdDateController,
    String createdDate,
    bool isLoading,
  }) {

    TextEditingController tempCreatedDateController = TextEditingController();

    tempCreatedDateController.text = createdDate ?? this.createdDate;


    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      createdDateController: tempCreatedDateController,
      createdDate: createdDate ?? this.createdDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }

   @override
   List<Object> get props => [products,categories,category,subCategory,createdDateController,createdDate,isLoading];
}






