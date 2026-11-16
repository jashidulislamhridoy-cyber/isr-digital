-- ISR Digital: Recent Work setup. Run once in Supabase > SQL Editor.
create table if not exists public.portfolio_items (
  id bigint generated always as identity primary key,
  platform text not null check (platform in ('YouTube','Facebook','Instagram','Website')),
  title text not null,
  client text default '',
  metric text default '',
  link text default '',
  image_url text not null,
  position int not null default 0,
  created_at timestamptz default now()
);
alter table public.portfolio_items enable row level security;
drop policy if exists "public read items" on public.portfolio_items;
create policy "public read items" on public.portfolio_items for select using (true);
drop policy if exists "auth insert items" on public.portfolio_items;
create policy "auth insert items" on public.portfolio_items for insert to authenticated with check (true);
drop policy if exists "auth update items" on public.portfolio_items;
create policy "auth update items" on public.portfolio_items for update to authenticated using (true) with check (true);
drop policy if exists "auth delete items" on public.portfolio_items;
create policy "auth delete items" on public.portfolio_items for delete to authenticated using (true);
insert into storage.buckets (id, name, public) values ('portfolio', 'portfolio', true) on conflict (id) do nothing;
drop policy if exists "public read images" on storage.objects;
create policy "public read images" on storage.objects for select using (bucket_id = 'portfolio');
drop policy if exists "auth upload images" on storage.objects;
create policy "auth upload images" on storage.objects for insert to authenticated with check (bucket_id = 'portfolio');
drop policy if exists "auth delete images" on storage.objects;
create policy "auth delete images" on storage.objects for delete to authenticated using (bucket_id = 'portfolio');
