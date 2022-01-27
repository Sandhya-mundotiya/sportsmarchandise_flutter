part of 'product_user_bloc.dart';

class ProductUserState extends Equatable {
  final List<Product> products;
  final List<Category> categories;
  final Category category;
  final Category subCategory;
  final TextEditingController purchaseDateController;
  final String purchaseDate;
  final bool isLoading;
  final TextEditingController priceController;
  final String price;



  ProductUserState({this.products,this.category,this.categories,this.subCategory,
    this.purchaseDate = "",this.purchaseDateController,this.isLoading = true,
    this.priceController,this.price = ""
  });


  factory ProductUserState.initial() {
    return ProductUserState(

      products: [],
      categories: [],
      category: Category(name: SELECT_VALUE),
      subCategory: Category(name: SELECT_VALUE),
      purchaseDateController: TextEditingController(),
      priceController: TextEditingController()
    );
  }

  ProductUserState update({
    List<Product> products,
    List<Category> categories,
    Category category,
    Category subCategory,
    String purchaseDate,
    bool isLoading,
    String price
  }) {

    TextEditingController tempPurchaseDateController = TextEditingController();
    TextEditingController tempPriceController = TextEditingController();

    tempPurchaseDateController.text = purchaseDate;
    tempPriceController.text = price;

    return copyWith(
      products: products,
      categories: categories,
      category: category,
      subCategory: subCategory,
      purchaseDateController: tempPurchaseDateController,
      price: price,
      priceController: tempPriceController,
      purchaseDate: purchaseDate,
      isLoading: isLoading,
    );
  }


  ProductUserState copyWith({
    List<Product> products,
    List<Category> categories,
    Category category,
    Category subCategory,
    TextEditingController purchaseDateController,
    TextEditingController priceController,
    String purchaseDate,
    bool isLoading,
    String price
  }) {

    TextEditingController tempPurchaseDateController = TextEditingController();
    TextEditingController tempPriceController = TextEditingController();

    tempPurchaseDateController.text = purchaseDate ?? this.purchaseDate;
    tempPriceController.text = price ?? this.price;


    return ProductUserState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      purchaseDateController: tempPurchaseDateController,
      priceController: tempPriceController,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      price: price ?? this.price,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [products,categories,category,subCategory,priceController,price,purchaseDateController,purchaseDate,isLoading];
}

