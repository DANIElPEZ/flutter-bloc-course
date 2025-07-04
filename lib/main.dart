import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance/firebase_options.dart';
import 'package:personal_finance/app_theme.dart';
import 'package:personal_finance/blocs/auth/auth_bloc.dart';
import 'package:personal_finance/repositories/auth_repository.dart';
import 'package:personal_finance/app_router.dart';
import 'package:personal_finance/blocs/income_expense/income_expense_bloc.dart';
import 'package:personal_finance/blocs/income_expense/income_expense_event.dart';
import 'package:personal_finance/models/income_expense_model.dart';
import 'package:personal_finance/repositories/auth_repository.dart';
import 'package:personal_finance/repositories/income_expense_repository.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<IncomeExpenseRepository>(create: (context) => IncomeExpenseRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)
            ),
          ),
          BlocProvider<IncomeExpenseBloc>(
              create: (context)=> IncomeExpenseBloc(
                RepositoryProvider.of<IncomeExpenseRepository>(context)
              )..add(LoadTransactions())
          )
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppThemes.greenFinanceTheme,
              darkTheme: AppThemes.greenFinanceDarkTheme,
              themeMode: isDarkMode? ThemeMode.dark : ThemeMode.light,
              routerConfig: AppRouter.router
            );
          }
        ),
      ),
    );
  }
}