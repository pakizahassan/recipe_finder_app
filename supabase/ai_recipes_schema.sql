-- Run this in your Supabase project → SQL Editor

CREATE TABLE IF NOT EXISTS public.ai_recipes (
  id                   UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  food_name            TEXT        NOT NULL,
  food_name_normalized TEXT        NOT NULL,
  title                TEXT        NOT NULL,
  description          TEXT        NOT NULL DEFAULT '',
  ingredients          TEXT[]      NOT NULL DEFAULT '{}',
  steps                TEXT[]      NOT NULL DEFAULT '{}',
  cooking_time         TEXT        NOT NULL DEFAULT '',
  calories             TEXT        NOT NULL DEFAULT '',
  servings             TEXT        NOT NULL DEFAULT '',
  chef_tips            TEXT        NOT NULL DEFAULT '',
  image_url            TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Unique index so duplicate food names upsert instead of inserting twice
CREATE UNIQUE INDEX IF NOT EXISTS ai_recipes_normalized_name_idx
  ON public.ai_recipes (food_name_normalized);

-- Enable Row Level Security
ALTER TABLE public.ai_recipes ENABLE ROW LEVEL SECURITY;

-- Anyone (including anonymous users) can read cached recipes
CREATE POLICY "Public read ai_recipes"
  ON public.ai_recipes FOR SELECT
  USING (true);

-- Allow inserts/upserts from anonymous users (the app writes cached recipes)
CREATE POLICY "Public insert ai_recipes"
  ON public.ai_recipes FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Public update ai_recipes"
  ON public.ai_recipes FOR UPDATE
  USING (true);
