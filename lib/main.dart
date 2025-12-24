import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/app_cubit.dart';
import 'logic/auth_cubit.dart';
import 'services/supabase_service.dart';
import 'core/localization.dart';
import 'core/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/welcome_page.dart';
import 'database/repositories/user_repository.dart';
import 'database/repositories/queue_repository.dart';
import 'database/repositories/queue_client_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase here with your URL and anon/public key.
  // Replace the empty strings with your project's values or
  // provide them at runtime when you have the credentials.
  await SupabaseService.initialize(url: 'https://rmxccujkhrmownftuvsn.supabase.co', anonKey: 'sb_publishable_ktYqW-uVXqp18sEImXdbyA_aUX8OVaF');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    final queueRepository = QueueRepository();
    final queueClientRepository = QueueClientRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: queueRepository),
        RepositoryProvider.value(value: queueClientRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppCubit()),
          BlocProvider(
              create: (context) => AuthCubit(
                  userRepository: RepositoryProvider.of<UserRepository>(context))),
        ],
        child: Builder(
          builder: (context) {
            return BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final locale = QNowLocalizations().currentLocale;

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                  title: QNowLocalizations.getTranslation('app_title'),
                  supportedLocales: QNowLocalizations().supportedLocalesList,
                  locale: locale,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supported) {
                    if (locale == null) {
                      return QNowLocalizations().currentLocale;
                    }
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
                          context
                              .read<AppCubit>()
                              .setUserLoggedIn(true, user: state.user);
                        } else if (state is AuthInitial) {
                          context.read<AppCubit>().setUserLoggedIn(false);
                        }
                      },
                      child: child,
                    );
                  },
                  home: WelcomePage(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}