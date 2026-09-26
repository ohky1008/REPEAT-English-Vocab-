-- 단어 오답노트 - Supabase 데이터베이스 스키마
-- Supabase 대시보드 → SQL Editor → New query 에 이 파일 전체를 붙여넣고 Run 하세요.

create extension if not exists pgcrypto;

create table if not exists public.lists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.words (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  list_id uuid not null references public.lists(id) on delete cascade,
  word text not null,
  pos text,
  meaning text not null,
  example text,
  syn_ant text,
  wrong_count int not null default 0,
  correct_count int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists words_user_id_idx on public.words(user_id);
create index if not exists words_list_id_idx on public.words(list_id);
create index if not exists lists_user_id_idx on public.lists(user_id);

alter table public.lists enable row level security;
alter table public.words enable row level security;

drop policy if exists "lists_select_own" on public.lists;
drop policy if exists "lists_insert_own" on public.lists;
drop policy if exists "lists_update_own" on public.lists;
drop policy if exists "lists_delete_own" on public.lists;
create policy "lists_select_own" on public.lists for select using (auth.uid() = user_id);
create policy "lists_insert_own" on public.lists for insert with check (auth.uid() = user_id);
create policy "lists_update_own" on public.lists for update using (auth.uid() = user_id);
create policy "lists_delete_own" on public.lists for delete using (auth.uid() = user_id);

drop policy if exists "words_select_own" on public.words;
drop policy if exists "words_insert_own" on public.words;
drop policy if exists "words_update_own" on public.words;
drop policy if exists "words_delete_own" on public.words;
create policy "words_select_own" on public.words for select using (auth.uid() = user_id);
create policy "words_insert_own" on public.words for insert with check (auth.uid() = user_id);
create policy "words_update_own" on public.words for update using (auth.uid() = user_id);
create policy "words_delete_own" on public.words for delete using (auth.uid() = user_id);

-- 실시간 동기화(다른 기기 변경사항을 즉시 반영)를 위해 두 테이블을 realtime publication에 추가
alter publication supabase_realtime add table public.lists;
alter publication supabase_realtime add table public.words;
