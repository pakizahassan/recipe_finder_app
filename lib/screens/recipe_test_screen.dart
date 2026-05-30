// Compile with your Gemini key, for example:
// flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_finder_app/ai/ai_config.dart';
import 'package:recipe_finder_app/ai/gemini_recipe_service.dart';
import 'package:recipe_finder_app/theme/app_theme.dart';

class RecipeTestScreen extends StatefulWidget {
  const RecipeTestScreen({super.key});

  @override
  State<RecipeTestScreen> createState() => _RecipeTestScreenState();
}

class _RecipeTestScreenState extends State<RecipeTestScreen> {
  final _ingredientsController = TextEditingController();
  final _recipeService = GeminiRecipeService();

  bool _isLoading = false;
  String? _recipe;
  String? _errorMessage;

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _submitIngredients() async {
    final ingredients = _ingredientsController.text
        .split(',')
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      setState(() {
        _recipe = null;
        _errorMessage = 'Enter at least one ingredient.';
      });
      return;
    }

    if (!AiConfig.isConfigured) {
      setState(() {
        _recipe = null;
        _errorMessage =
            'Missing GEMINI_API_KEY. Start Flutter with --dart-define-from-file=config.json.';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _recipe = null;
      _errorMessage = null;
    });

    try {
      final recipe = await _recipeService.generateRecipe(ingredients);
      if (!mounted) return;
      setState(() => _recipe = recipe);
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Recipe Test',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ingredientsController,
                enabled: !_isLoading,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: 'Ingredients',
                  hintText: 'e.g. chicken, rice, garlic, onion',
                  prefixIcon: Icon(Icons.kitchen_rounded),
                ),
                onSubmitted: (_) => _isLoading ? null : _submitIngredients(),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _isLoading ? null : _submitIngredients,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(_isLoading ? 'Generating...' : 'Generate Recipe'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _RecipeOutput(
                    isLoading: _isLoading,
                    recipe: _recipe,
                    errorMessage: _errorMessage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeOutput extends StatelessWidget {
  const _RecipeOutput({
    required this.isLoading,
    required this.recipe,
    required this.errorMessage,
  });

  final bool isLoading;
  final String? recipe;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          errorMessage!,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.5,
            color: AppColors.error,
          ),
        ),
      );
    }

    if (recipe == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            'Your generated recipe will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: SelectableText(
          recipe!,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
