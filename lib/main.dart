
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:merch/admin/bloc/category/category_bloc.dart';
import 'package:merch/admin/bloc/history_list/history_list_admin_bloc.dart';
import 'package:merch/admin/bloc/product/product_bloc.dart';
import 'package:merch/admin/bloc/school/school_bloc.dart';
import 'package:merch/common/app_bloc_observer.dart';
import 'package:merch/common/app_selection_screen.dart';
import 'package:merch/constants/app_color.dart';
import 'package:merch/constants/utils/navigation_service.dart';
import 'package:merch/firebase_options.dart';
import 'package:merch/repositories/category/category_repository.dart';
import 'package:merch/repositories/history/history_repository.dart';
import 'package:merch/repositories/product/product_repository.dart';
import 'package:merch/repositories/school/school_repository.dart';
import 'package:merch/store/bloc/product_list/product_user_bloc.dart' as product_user_bloc;
import 'package:flutter_stripe/flutter_stripe.dart';


GetIt getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set the publishable key for Stripe - this is mandatory
  Stripe.publishableKey = 'pk_test_4R3QOVd7lK64gHdpf6HWi5qo';
  Stripe.merchantIdentifier = 'sports marchandise';
  await Stripe.instance.applySettings();

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
          create: (context) => HistoryListAdminBloc(
            categoryBloc: BlocProvider.of<CategoryBloc>(context),
            historyRepository: HistoryRepository()
              ),
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
          primarySwatch: MaterialColor(0xFFAB6A58,<int, Color>{
          50: Color(0xFFAB6A58),
          100: Color(0xFFAB6A5B),
          200: Color(0xFFC19A59),
          300: Color(0xFFC19A56),
          400: Color(0xFFC19A55),
          500: Color(0xFFC19A56),
          600: Color(0xFFC19A55),
          700: Color(0xFFC19A52),
          800: Color(0xFFC19A50),
          900: Color(0xFFC19A51),
          },),
          appBarTheme: AppBarTheme(color: appWhite,foregroundColor:appBlack)
        ),
        home:const AppSelectionScreen(),
      ),
    );
  }
}

