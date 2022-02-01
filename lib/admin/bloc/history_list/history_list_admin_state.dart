part of 'history_list_admin_bloc.dart';

class HistoryListAdminState extends Equatable {
  final List<ProductHistoryModel> products;
  final bool isLoading;
  final List<Category> categories;
  final Category category;
  final Category subCategory;
  final TextEditingController dateController;
  final String date;

  HistoryListAdminState({this.products,this.category,
    this.categories,this.subCategory,this.date = "",this.dateController,this.isLoading = true});


  factory HistoryListAdminState.initial() {
    return HistoryListAdminState(
      products: [],
      categories: [],
      category: Category(name: SELECT_VALUE),
      subCategory: Category(name: SELECT_VALUE),
      dateController: TextEditingController(),
    );
  }

  HistoryListAdminState update({
    List<ProductHistoryModel> products,
    List<Category> categories,
    Category category,
    Category subCategory,
    String date,
    bool isLoading,
  }) {

    TextEditingController tempDateController = TextEditingController();

    tempDateController.text = date;

    return copyWith(
      products: products,
      categories: categories,
      category: category,
      subCategory: subCategory,
      createdDateController: tempDateController,
      createdDate: date,
      isLoading: isLoading,
    );
  }


  HistoryListAdminState copyWith({
    List<ProductHistoryModel> products,
    List<Category> categories,
    Category category,
    Category subCategory,
    TextEditingController createdDateController,
    String createdDate,
    bool isLoading,
  }) {

    TextEditingController tempDateController = TextEditingController();

    tempDateController.text = createdDate ?? this.date;


    return HistoryListAdminState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      dateController: tempDateController,
      date: createdDate ?? this.date,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [products,isLoading,categories,category,subCategory,dateController,date];
}

