import 'package:go_router/go_router.dart';

import 'package:recipe_finder_app/screens/login_screen.dart';
import 'package:recipe_finder_app/screens/onboarding_screen.dart';
import 'package:recipe_finder_app/screens/register_screen.dart';
import 'package:recipe_finder_app/screens/splash_screen.dart';
import 'package:recipe_finder_app/screens/recipe_details_screen.dart';
import 'package:recipe_finder_app/screens/ai_recipe_generator_screen.dart';
import 'package:recipe_finder_app/screens/edit_profile_screen.dart';
import 'package:recipe_finder_app/screens/search_screen.dart';
import 'package:recipe_finder_app/screens/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/app',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/ai-recipe',
      builder: (context, state) => const AiRecipeGeneratorScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/recipe/:id',
      builder: (context, state) {
        return RecipeDetailsScreen(recipeId: state.pathParameters['id']!);
      },
    ),
  ],
);
