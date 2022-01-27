
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/admin/bloc/product/product_bloc.dart';
import 'package:merch/admin/bloc/school/school_bloc.dart';
import 'package:merch/common/app_bloc_observer.dart';
import 'package:merch/common/app_selection_screen.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/firebase_options.dart';
import 'package:merch/repositories/category/category_repository.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:merch/repositories/school/school_repository.dart';
import 'package:merch/store/bloc/product_list/product_user_bloc.dart' as product_user_bloc;

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
          create: (context) => ProductBloc(
            productRepository: ProductRepository(),categoryBloc: BlocProvider.of<CategoryBloc>(context)
          )..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => product_user_bloc.ProductUserBloc(
              productRepository: ProductRepository(),categoryBloc: BlocProvider.of<CategoryBloc>(context)
          )..add(product_user_bloc.LoadProducts()),
        ),

        BlocProvider(
          create: (_) => SchoolBloc(
            SchoolRepository: SchoolRepository(),
          )..add(LoadSchools()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,navigatorKey: NavigationService.navigatorKey,
        title: 'Sport Center',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFFC388F6,<int, Color>{
          50: Color(0xFFE3F2FD),
          100: Color(0xFFBBDEFB),
          200: Color(0xFF90CAF9),
          300: Color(0xFF64B5F6),
          400: Color(0xFF42A5F5),
          500: Color(0xFFC388F6),
          600: Color(0xFF1E88E5),
          700: Color(0xFF1976D2),
          800: Color(0xFF1565C0),
          900: Color(0xFF0D47A1),
          },),
          appBarTheme: AppBarTheme(color: Colors.white)
        ),
        home:const AppSelectionScreen(),
      ),
    );
  }
}

