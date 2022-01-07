
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/bloc/product/product_bloc.dart';
import 'package:merch/bloc/school/school_bloc.dart';
import 'package:merch/common/AppBlocObserver.dart';
import 'package:merch/common/AppSelectionScreen.dart';
import 'package:merch/firebase_options.dart';
import 'package:merch/repositories/category/category_repository.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:merch/repositories/school/school_repository.dart';
GetIt getIt = GetIt.instance;
Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryBloc(
            categoryRepository: CategoryRepository(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(LoadProducts()),
        ),
        BlocProvider(
          create: (_) => SchoolBloc(
            SchoolRepository: SchoolRepository(),
          )..add(LoadSchools()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sport Center',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:const AppSelectionScreen(),
      ),
    );
  }
}

