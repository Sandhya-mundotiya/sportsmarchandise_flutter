
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:merch/admin/add_category/category_cupid.dart';
import 'package:merch/admin/add_item/assets_cupid.dart';
import 'package:merch/admin/add_item/loader_cupid.dart';
import 'package:merch/cubid/product/product_detail_cubid.dart';
import 'package:merch/bloc/category/category_bloc.dart';
import 'package:merch/bloc/product/product_bloc.dart';
import 'package:merch/bloc/school/school_bloc.dart';
import 'package:merch/common/app_bloc_observer.dart';
import 'package:merch/common/app_selection_screen.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/firebase_options.dart';
import 'package:merch/repositories/category/category_repository.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:merch/repositories/school/school_repository.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        BlocProvider(create: (_) => CategoryCubit()),
        BlocProvider(create: (_) => AssetCubit()),
        BlocProvider(create: (_) => LoaderCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,navigatorKey: NavigationService.navigatorKey,
        title: 'Sport Center',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:const AppSelectionScreen(),
      ),
    );
  }
}

