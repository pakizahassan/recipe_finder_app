import '../../features/recipes/data/models/category_model.dart';
import '../../features/recipes/data/models/recipe_model.dart';

final seedCategories = <CategoryModel>[
  const CategoryModel(id: 'all', name: 'All', icon: 'Dining'),
  const CategoryModel(id: 'breakfast', name: 'Breakfast', icon: 'Morning'),
  const CategoryModel(id: 'dessert', name: 'Dessert', icon: 'Sweet'),
  const CategoryModel(id: 'seafood', name: 'Seafood', icon: 'Coastal'),
  const CategoryModel(id: 'vegetarian', name: 'Vegetarian', icon: 'Garden'),
  const CategoryModel(id: 'chicken', name: 'Chicken', icon: 'Protein'),
  const CategoryModel(id: 'beef', name: 'Beef', icon: 'Classic'),
];

final seedRecipes = <RecipeModel>[
  const RecipeModel(
    id: 'r1',
    title: 'Cloud Soft Ricotta Pancakes',
    imageUrl:
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=900&q=85',
    rating: 4.8,
    cookTimeMinutes: 20,
    categoryId: 'breakfast',
    description:
        'Light breakfast pancakes finished with berries, maple, and citrus cream.',
    calories: 320,
    ingredients: ['Ricotta', 'Flour', 'Eggs', 'Blueberries', 'Maple syrup'],
    instructions: [
      'Whisk ricotta, eggs, flour, and milk into a smooth batter.',
      'Cook small rounds on a buttered skillet until golden.',
      'Serve warm with berries, maple syrup, and citrus zest.',
    ],
    isFeatured: false,
  ),
  const RecipeModel(
    id: 'r2',
    title: 'Dark Chocolate Lava Cake',
    imageUrl:
        'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=900&q=85',
    rating: 4.9,
    cookTimeMinutes: 30,
    categoryId: 'dessert',
    description:
        'A rich molten cake with a soft center and salted vanilla cream.',
    calories: 450,
    ingredients: ['Dark chocolate', 'Butter', 'Eggs', 'Sugar', 'Flour'],
    instructions: [
      'Melt chocolate and butter until glossy.',
      'Fold in eggs, sugar, and flour without overmixing.',
      'Bake until the edges set and the center remains molten.',
    ],
  ),
  const RecipeModel(
    id: 'r3',
    title: 'Garlic Butter Shrimp Skillet',
    imageUrl:
        'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=900&q=85',
    rating: 4.7,
    cookTimeMinutes: 15,
    categoryId: 'seafood',
    description: 'Fast seared shrimp with lemon, herbs, and a glossy pan sauce.',
    calories: 280,
    ingredients: ['Shrimp', 'Garlic', 'Butter', 'Lemon', 'Parsley'],
    instructions: [
      'Season shrimp and sear in a hot skillet.',
      'Add garlic, butter, lemon juice, and parsley.',
      'Toss until coated and serve immediately.',
    ],
  ),
  const RecipeModel(
    id: 'r4',
    title: 'Avocado Garden Bowl',
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900&q=85',
    rating: 4.6,
    cookTimeMinutes: 25,
    categoryId: 'vegetarian',
    description: 'A bright bowl with grains, greens, avocado, and tahini lime.',
    calories: 390,
    ingredients: ['Quinoa', 'Avocado', 'Kale', 'Chickpeas', 'Tahini'],
    instructions: [
      'Cook quinoa and cool slightly.',
      'Layer greens, chickpeas, avocado, and grains.',
      'Drizzle with tahini lime dressing.',
    ],
  ),
  const RecipeModel(
    id: 'r5',
    title: 'Crispy Buttermilk Chicken',
    imageUrl:
        'https://images.unsplash.com/photo-1562967914-608f82629710?w=900&q=85',
    rating: 4.8,
    cookTimeMinutes: 45,
    categoryId: 'chicken',
    description: 'Juicy chicken with a crisp peppered crust and honey drizzle.',
    calories: 520,
    ingredients: ['Chicken thighs', 'Buttermilk', 'Flour', 'Paprika', 'Honey'],
    instructions: [
      'Marinate chicken in seasoned buttermilk.',
      'Dredge in spiced flour until fully coated.',
      'Fry until crisp and finish with honey.',
    ],
  ),
  const RecipeModel(
    id: 'f1',
    title: 'Classic Beef Bourguignon',
    imageUrl:
        'https://images.unsplash.com/photo-1574484284002-952d92456975?w=1200&q=85',
    rating: 4.9,
    cookTimeMinutes: 180,
    categoryId: 'beef',
    description:
        'Slow-braised beef with red wine, pearl onions, mushrooms, and herbs.',
    calories: 680,
    ingredients: ['Beef chuck', 'Red wine', 'Mushrooms', 'Pearl onions', 'Thyme'],
    instructions: [
      'Brown seasoned beef in batches.',
      'Deglaze with red wine and add aromatics.',
      'Braise low and slow until the beef is tender.',
    ],
    isFeatured: true,
  ),
];
