-- Run this in Supabase SQL Editor to allow AI-generated recipes
-- to be inserted into the main recipes table.

-- Enable RLS if not already enabled
ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;

-- Allow anyone (including anonymous users) to insert new recipes
CREATE POLICY "Allow anon insert recipes"
  ON public.recipes FOR INSERT
  WITH CHECK (true);

-- Allow upsert (update on conflict)
CREATE POLICY "Allow anon update recipes"
  ON public.recipes FOR UPDATE
  USING (true);
