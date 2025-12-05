import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/app_cubit.dart';
import 'logic/auth_cubit.dart';
import 'database/db_helper.dart';
import 'core/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_colors.dart';
import 'presentation/welcome_page.dart';
import 'database/repositories/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseHelper = DatabaseHelper();
    
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: databaseHelper),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppCubit()),
          BlocProvider(create: (context) => AuthCubit(userRepository: UserRepository(databaseHelper: databaseHelper))),
        ],
        child: Builder(
          builder: (context) {
            return BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                Locale currentLocale = QNowLocalizations().currentLocale;
                
                // Update locale if state has changed
                if (state is LanguageChanged) {
                  currentLocale = state.locale;
                }
                
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: QNowLocalizations.getTranslation('app_title'),
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: state is AppLoaded && state.isDarkMode 
                      ? ThemeMode.dark 
                      : ThemeMode.light,
                  supportedLocales: QNowLocalizations().supportedLocalesList,
                  locale: currentLocale,
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    localeResolutionCallback: (locale, supported) {
                      if (locale == null) return QNowLocalizations().currentLocale;
                      for (final supportedLocale in supported) {
                        if (supportedLocale.languageCode == locale.languageCode) {
                          return supportedLocale;
                        }
                      }
                      return QNowLocalizations().currentLocale;
                    },
                  builder: (context, child) {
                    return BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          context.read<AppCubit>().setUserLoggedIn(true, user: state.user);
                        } else if (state is AuthInitial) {
                          context.read<AppCubit>().setUserLoggedIn(false);
                        }
                      },
                      child: child,
                    );
                  },
                  home: const WelcomePage(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}