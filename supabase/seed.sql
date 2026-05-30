-- ============================================================
-- RECIPE FINDER APP — SUPABASE SCHEMA + SEED DATA
-- Run this entire script in your Supabase SQL Editor once.
-- ============================================================

-- ── 1. PROFILES ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id          UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  display_name TEXT,
  avatar_url  TEXT,
  bio         TEXT DEFAULT 'Food lover & home cook',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owners can view own profile"   ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Owners can create own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Owners can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Auto-create profile row whenever a user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'display_name', 'Food Lover')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ── 2. CATEGORIES ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.categories (
  id   TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT DEFAULT 'Dining'
);

INSERT INTO public.categories (id, name, icon) VALUES
  ('breakfast',     'Breakfast',     'Morning'),
  ('desserts',      'Desserts',      'Sweet'),
  ('seafood',       'Seafood',       'Coastal'),
  ('vegetarian',    'Vegetarian',    'Garden'),
  ('chicken',       'Chicken',       'Protein'),
  ('beef',          'Beef',          'Classic'),
  ('italian',       'Italian',       'Dining'),
  ('asian',         'Asian',         'Dining'),
  ('american',      'American',      'Dining'),
  ('mediterranean', 'Mediterranean', 'Dining'),
  ('mexican',       'Mexican',       'Dining')
ON CONFLICT (id) DO NOTHING;

-- ── 3. RECIPES ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.recipes (
  id               TEXT PRIMARY KEY,
  title            TEXT NOT NULL,
  description      TEXT    DEFAULT '',
  image_url        TEXT    DEFAULT '',
  category_id      TEXT    REFERENCES public.categories(id),
  rating           DECIMAL(3,1) DEFAULT 4.5,
  cook_time_minutes INTEGER DEFAULT 30,
  calories         INTEGER DEFAULT 400,
  ingredients      TEXT[]  DEFAULT '{}',
  instructions     TEXT[]  DEFAULT '{}',
  is_featured      BOOLEAN DEFAULT FALSE,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Recipes viewable by everyone" ON public.recipes FOR SELECT USING (true);

INSERT INTO public.recipes
  (id, title, description, image_url, category_id, rating, cook_time_minutes, calories, ingredients, instructions, is_featured)
VALUES

-- ── Italian ──
('spaghetti-carbonara',
 'Spaghetti Carbonara',
 'A creamy Roman pasta made with eggs, Pecorino Romano, guanciale, and black pepper — no cream needed.',
 'https://images.unsplash.com/photo-1546549032-9571cd6b27df?w=800&q=80',
 'italian', 4.9, 25, 580,
 ARRAY['400g spaghetti','150g guanciale or pancetta','4 large eggs','100g Pecorino Romano, grated','50g Parmesan, grated','Freshly ground black pepper','Salt for pasta water'],
 ARRAY['Cook spaghetti in heavily salted boiling water until al dente, reserving 1 cup pasta water.','Fry guanciale over medium heat until crispy, then remove pan from heat.','Whisk eggs with grated cheeses and a generous amount of black pepper.','Drain pasta and immediately add to the guanciale pan off heat.','Quickly toss in egg-cheese mixture, adding pasta water bit by bit to create a creamy sauce.','Plate immediately with extra cheese and cracked pepper.'],
 TRUE),

('margherita-pizza',
 'Margherita Pizza',
 'Classic Neapolitan pizza with San Marzano tomato sauce, fresh mozzarella, and basil.',
 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
 'italian', 4.8, 40, 520,
 ARRAY['250g pizza dough','80ml San Marzano tomato sauce','150g fresh mozzarella, sliced','Fresh basil leaves','2 tbsp extra-virgin olive oil','Salt'],
 ARRAY['Preheat oven to 250°C (480°F) with a pizza stone inside.','Stretch dough into a 12-inch round on a lightly floured surface.','Spread tomato sauce, leaving a 1-inch border.','Arrange mozzarella slices evenly.','Bake 8-10 minutes until crust is golden and cheese is bubbling.','Remove, top with fresh basil and a drizzle of olive oil.'],
 FALSE),

-- ── Asian ──
('chicken-tikka-masala',
 'Chicken Tikka Masala',
 'Tender marinated chicken in a rich, aromatic tomato-cream sauce. A timeless favourite.',
 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&q=80',
 'asian', 4.8, 45, 620,
 ARRAY['700g chicken breast, cubed','200ml plain yogurt','2 tsp garam masala','1 tsp turmeric','2 tsp cumin','400g crushed tomatoes','200ml heavy cream','1 large onion, diced','4 cloves garlic','1 inch ginger, grated','Fresh coriander'],
 ARRAY['Marinate chicken in yogurt, half the spices, and salt for 30+ minutes.','Grill or pan-sear chicken until lightly charred. Set aside.','Sauté onion, garlic, and ginger until golden. Add remaining spices, cook 1 min.','Add crushed tomatoes, simmer 15 minutes.','Blend sauce until smooth, return to heat.','Add chicken and cream, simmer 10 minutes until thickened.','Garnish with coriander. Serve with basmati rice or naan.'],
 TRUE),

('pad-thai',
 'Pad Thai',
 'Thailand''s national noodle dish — sweet, savory, tangy, with a satisfying crunch.',
 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=800&q=80',
 'asian', 4.7, 30, 540,
 ARRAY['200g flat rice noodles','200g shrimp or chicken','3 tbsp fish sauce','2 tbsp tamarind paste','1 tbsp palm sugar','2 eggs','2 cloves garlic, minced','3 spring onions','100g bean sprouts','50g crushed roasted peanuts','Lime wedges'],
 ARRAY['Soak rice noodles in warm water 20 minutes; drain.','Mix fish sauce, tamarind, and sugar for the sauce.','Stir-fry garlic in a very hot wok. Add protein and cook through.','Add noodles and sauce, toss to coat everything.','Push aside, scramble eggs on the empty side, then combine.','Add bean sprouts and spring onions for the last 30 seconds.','Serve topped with peanuts, a lime wedge, and chili flakes.'],
 FALSE),

('beef-stir-fry',
 'Beef & Broccoli Stir Fry',
 'A quick high-heat stir fry with tender sliced beef, crisp broccoli, and savory sauce.',
 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800&q=80',
 'asian', 4.6, 20, 480,
 ARRAY['500g flank steak, thinly sliced','2 cups broccoli florets','3 tbsp soy sauce','1 tbsp oyster sauce','1 tsp sesame oil','1 tsp cornstarch','2 cloves garlic','1 tsp fresh ginger','2 tbsp vegetable oil'],
 ARRAY['Marinate beef in soy sauce, cornstarch, and sesame oil for 15 minutes.','Blanch broccoli in boiling water 2 minutes; drain and set aside.','Heat wok to smoking hot. Stir-fry beef in batches until browned, remove.','Add garlic and ginger to wok, then add broccoli.','Return beef, add oyster sauce and toss everything together over high heat.','Serve immediately over steamed rice.'],
 FALSE),

-- ── American ──
('bbq-smash-burger',
 'BBQ Smash Burger',
 'A juicy double smash patty with smoky BBQ sauce, crispy bacon, and American cheese.',
 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80',
 'american', 4.9, 20, 780,
 ARRAY['500g ground beef (80/20)','4 brioche buns','8 slices American cheese','4 strips bacon','BBQ sauce','Lettuce, tomato, sliced onion','Salt and black pepper','Butter for buns'],
 ARRAY['Divide beef into 8 equal balls. Season generously.','Cook bacon until crispy; set aside.','Heat a cast iron or flat-top to very high heat.','Add beef balls, smash flat with a spatula immediately. Cook 2 min.','Flip once, add cheese, then stack two patties per burger.','Toast buttered buns. Assemble: bun base, lettuce, tomato, patty stack, bacon, BBQ sauce, top bun.','Serve immediately with fries.'],
 TRUE),

('baked-mac-cheese',
 'Baked Mac & Cheese',
 'Ultra-creamy stovetop mac finished under the broiler for a golden, bubbling crust.',
 'https://images.unsplash.com/photo-1635700611-7e36cd5a2c3a?w=800&q=80',
 'american', 4.7, 35, 680,
 ARRAY['400g macaroni','3 tbsp butter','3 tbsp flour','500ml whole milk','200g sharp cheddar, grated','100g Gruyère, grated','1 tsp mustard powder','½ tsp smoked paprika','Panko breadcrumbs','Salt and pepper'],
 ARRAY['Cook macaroni until just al dente. Drain.','Melt butter in a saucepan, whisk in flour and cook 1 minute.','Gradually whisk in milk over medium heat until thick and smooth.','Remove from heat, stir in ¾ of the cheese, mustard, paprika. Season.','Fold in macaroni. Pour into a baking dish.','Top with remaining cheese and breadcrumbs.','Broil 5-7 minutes until golden and bubbling.'],
 FALSE),

-- ── Mediterranean ──
('greek-salad',
 'Classic Greek Salad',
 'A refreshing village salad with ripe tomatoes, cucumber, Kalamata olives, and feta.',
 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
 'mediterranean', 4.6, 10, 280,
 ARRAY['4 large ripe tomatoes, chunked','1 large cucumber, chunked','1 red onion, thinly sliced','200g feta cheese block','100g Kalamata olives','1 green bell pepper, sliced','4 tbsp extra-virgin olive oil','1 tsp dried oregano','Salt and pepper'],
 ARRAY['Combine tomatoes, cucumber, onion, and bell pepper in a wide bowl.','Add olives throughout.','Place the whole feta block on top — do not crumble it.','Drizzle very generously with olive oil.','Sprinkle with dried oregano, salt, and cracked pepper.','Serve immediately with crusty bread.'],
 FALSE),

('caesar-salad',
 'Caesar Salad',
 'Crisp romaine lettuce, house-made Caesar dressing, shaved Parmesan, and golden croutons.',
 'https://images.unsplash.com/photo-1551248429-40975aa4de74?w=800&q=80',
 'mediterranean', 4.7, 15, 350,
 ARRAY['2 heads romaine lettuce, torn','1 cup croutons','75g Parmesan, shaved','1 clove garlic, minced','1 tsp Worcestershire sauce','1 tsp Dijon mustard','2 tbsp lemon juice','4 tbsp good olive oil','Salt and white pepper'],
 ARRAY['Whisk garlic, Worcestershire, mustard, and lemon juice together.','Slowly drizzle in olive oil while whisking to emulsify the dressing.','Season with salt and white pepper.','Toss romaine with most of the dressing and half the Parmesan.','Top with croutons and remaining Parmesan.','Serve at once with extra dressing on the side.'],
 FALSE),

-- ── Mexican ──
('street-chicken-tacos',
 'Street-Style Chicken Tacos',
 'Smoky charred chicken in warm corn tortillas with fresh salsa, avocado, and lime.',
 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800&q=80',
 'mexican', 4.8, 30, 490,
 ARRAY['600g chicken thighs','2 tsp chili powder','1 tsp cumin','1 tsp garlic powder','12 corn tortillas','2 avocados, sliced','Fresh tomato salsa','Lime wedges','Fresh coriander','Sour cream'],
 ARRAY['Season chicken with chili powder, cumin, garlic powder, and salt.','Grill or pan-fry chicken thighs 5-6 minutes per side until cooked through.','Rest 5 minutes, then slice thinly across the grain.','Warm tortillas in a dry pan for 30 seconds each side.','Assemble tacos with chicken, avocado, salsa, and coriander.','Finish with a squeeze of fresh lime. Serve immediately.'],
 TRUE),

-- ── Desserts ──
('chocolate-lava-cake',
 'Chocolate Lava Cake',
 'A warm fudgy cake with a molten chocolate center. Served with vanilla ice cream.',
 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&q=80',
 'desserts', 4.9, 20, 580,
 ARRAY['200g dark chocolate (70%)','150g unsalted butter','200g icing sugar','4 whole eggs','4 egg yolks','100g all-purpose flour','Pinch of salt','Butter and cocoa powder for ramekins','Vanilla ice cream to serve'],
 ARRAY['Preheat oven to 220°C. Butter 6 ramekins and dust with cocoa powder.','Melt chocolate and butter together over a bain-marie until glossy.','Whisk in icing sugar until well combined.','Beat in whole eggs and yolks one at a time.','Fold in flour and salt just until combined — do not overmix.','Fill ramekins ¾ full. Refrigerate up to 24 hours or bake immediately.','Bake 10-12 minutes until edges are set but center still jiggles.','Run a knife around the edge, invert onto a plate. Serve at once with ice cream.'],
 FALSE),

-- ── Breakfast ──
('brioche-french-toast',
 'Brioche French Toast',
 'Thick-cut brioche soaked in vanilla custard, pan-fried golden, with maple syrup and berries.',
 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800&q=80',
 'breakfast', 4.8, 15, 520,
 ARRAY['4 thick slices brioche','3 large eggs','80ml whole milk','1 tsp vanilla extract','1 tsp ground cinnamon','2 tbsp unsalted butter','Maple syrup to serve','Fresh mixed berries','Powdered sugar for dusting'],
 ARRAY['Whisk eggs, milk, vanilla, and cinnamon together in a shallow dish.','Soak each brioche slice 30-45 seconds per side until saturated.','Melt butter in a non-stick pan over medium heat.','Cook slices 2-3 minutes per side until deep golden brown and caramelized.','Serve immediately dusted with powdered sugar, berries, and a generous pour of maple syrup.'],
 FALSE),

('eggs-benedict',
 'Eggs Benedict',
 'Toasted English muffins with Canadian bacon, perfectly poached eggs, and rich Hollandaise.',
 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800&q=80',
 'breakfast', 4.7, 25, 650,
 ARRAY['4 large eggs (for poaching)','4 English muffins, split and toasted','8 slices Canadian bacon','3 egg yolks (for hollandaise)','150g unsalted butter, melted','1 tbsp fresh lemon juice','Pinch of cayenne pepper','Salt and white pepper','Fresh chives to garnish'],
 ARRAY['Make hollandaise: whisk yolks with lemon juice over a bain-marie until thick ribbons form.','Slowly drizzle in melted butter while whisking. Season with salt, pepper, and cayenne. Keep warm.','Fill a wide pan with water and a splash of vinegar. Bring to a gentle simmer.','Crack each egg into a small cup. Create a gentle swirl and slide eggs in. Poach 3-4 minutes.','Warm Canadian bacon in a pan. Toast English muffins.','Assemble: muffin half, bacon, poached egg, generous Hollandaise.','Garnish with snipped chives and a pinch of cayenne.'],
 FALSE),

-- ── Seafood ──
('garlic-butter-shrimp',
 'Garlic Butter Shrimp Skillet',
 'Fast seared shrimp with lemon, herbs, and a glossy garlic butter pan sauce.',
 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&q=80',
 'seafood', 4.7, 15, 280,
 ARRAY['500g large shrimp, peeled and deveined','4 cloves garlic, minced','4 tbsp unsalted butter','2 tbsp olive oil','Juice of 1 lemon','Handful flat-leaf parsley, chopped','Pinch of red chili flakes','Salt and pepper'],
 ARRAY['Pat shrimp dry. Season with salt, pepper, and chili flakes.','Heat olive oil in a large skillet over high heat until shimmering.','Add shrimp in a single layer. Sear 1-2 minutes until pink underneath.','Flip, add garlic and butter. Cook 1 more minute while basting.','Remove from heat, add lemon juice and parsley.','Serve immediately with crusty bread to mop up the sauce.'],
 FALSE),

-- ── Vegetarian ──
('avocado-garden-bowl',
 'Avocado Garden Bowl',
 'A vibrant bowl with quinoa, crispy chickpeas, greens, and tahini-lime dressing.',
 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
 'vegetarian', 4.6, 25, 390,
 ARRAY['200g quinoa','400g canned chickpeas, drained','2 ripe avocados','100g baby kale or spinach','1 cucumber, sliced','Cherry tomatoes','2 tbsp tahini','Juice of 1 lime','1 tbsp olive oil','Salt and cumin'],
 ARRAY['Cook quinoa according to package directions. Let cool slightly.','Toss chickpeas with olive oil, cumin, and salt. Roast at 200°C for 20 minutes until crispy.','Whisk tahini, lime juice, 2 tbsp water, and a pinch of salt for the dressing.','Arrange quinoa, greens, cucumber, tomatoes, and avocado in bowls.','Top with crispy chickpeas.','Drizzle generously with tahini dressing.'],
 FALSE),

-- ── Chicken ──
('crispy-buttermilk-chicken',
 'Crispy Buttermilk Chicken',
 'Juicy chicken with a crisp peppered buttermilk crust and a honey drizzle.',
 'https://images.unsplash.com/photo-1562967914-608f82629710?w=800&q=80',
 'chicken', 4.8, 45, 520,
 ARRAY['800g chicken thighs','500ml buttermilk','200g all-purpose flour','2 tsp smoked paprika','1 tsp garlic powder','1 tsp black pepper','1 tsp cayenne','Vegetable oil for frying','Honey to serve'],
 ARRAY['Marinate chicken in buttermilk mixed with half the spices for at least 2 hours (overnight is best).','Mix flour with remaining spices.','Remove chicken from marinade, allowing excess to drip off.','Dredge thoroughly in spiced flour, pressing firmly.','Fry at 170°C for 12-15 minutes until deep golden and cooked through.','Drain on a rack. Finish with a drizzle of honey.'],
 FALSE),

-- ── Beef ──
('beef-bourguignon',
 'Classic Beef Bourguignon',
 'Slow-braised French beef with red wine, pearl onions, mushrooms, and fresh thyme.',
 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=800&q=80',
 'beef', 4.9, 180, 680,
 ARRAY['1kg beef chuck, cut into 5cm cubes','750ml good red wine (Burgundy)','200g pearl onions','300g cremini mushrooms','4 strips bacon, chopped','4 cloves garlic','2 carrots, sliced','2 tbsp tomato paste','Fresh thyme and bay leaves','2 tbsp flour','Salt and pepper'],
 ARRAY['Season beef generously. Sear in batches in a hot Dutch oven until deeply browned.','Fry bacon, pearl onions, and mushrooms separately.','Sauté garlic and carrots in the same pot.','Return beef, add wine, tomato paste, flour, and herbs.','Bring to a simmer, add back bacon and onions.','Cover and braise in a 160°C oven for 2.5 hours until fall-apart tender.','Adjust seasoning. Serve over mashed potatoes or wide egg noodles.'],
 TRUE)

ON CONFLICT (id) DO NOTHING;

-- ── 4. FAVORITES ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.favorites (
  id        UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id   UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id TEXT REFERENCES public.recipes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own favorites"   ON public.favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own favorites" ON public.favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own favorites" ON public.favorites FOR DELETE USING (auth.uid() = user_id);

-- ── 5. AVATAR STORAGE BUCKET ──────────────────────────────────
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Anyone can view avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "Authenticated users can upload avatars"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'avatars' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update avatars"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'avatars' AND auth.role() = 'authenticated');

-- ── Done! ──────────────────────────────────────────────────────
