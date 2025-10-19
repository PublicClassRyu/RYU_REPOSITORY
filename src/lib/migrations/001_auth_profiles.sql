-- buat table profiles
create table public.profiles (
  id uuid not null references auth.users on delete cascade,
  name text,
  role text,
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,

  primary key (id)
);

alter table public.profiles enable row level security;

-- buat function untuk masukin data dari /login ke table public.profiles pas akun user udah dibuat di /login
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, name, role, avatar_url)
  values (new.id, new.raw_user_meta_data ->> 'name', new.raw_user_meta_data ->> 'role', new.raw_user_meta_data ->> 'avatar_url');
  return new;
end;
$$;

-- buat trigger ke function di atas setiap user baru registrasi
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- buat function untuk menghapus data user dari public.profiles
create function public.handle_delete_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  delete from public.profiles where id = old.id;
  return old;
end;
$$;

-- buat trigger ke function hapus data di atas setiap user di hapus 
create trigger on_auth_user_delated
  after delete on auth.users
  for each row execute procedure public.handle_delete_user();