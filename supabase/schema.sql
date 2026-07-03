-- ============================================================
-- AgroLink Uganda — Supabase / PostgreSQL Schema
-- Farmer + SACCO Super App
-- ============================================================

create extension if not exists "uuid-ossp";
create extension if not exists "postgis";

-- ============================================================
-- ENUM TYPES
-- ============================================================
create type user_role as enum ('farmer', 'sacco_admin', 'vendor', 'buyer', 'extension_officer');
create type loan_status as enum ('pending', 'approved', 'rejected', 'disbursed', 'repaying', 'closed', 'defaulted');
create type order_status as enum ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled');
create type payment_method as enum ('mtn_momo', 'airtel_money', 'bank_transfer', 'cash');
create type payment_status as enum ('pending', 'success', 'failed', 'refunded');
create type transaction_type as enum ('deposit', 'withdrawal', 'loan_disbursement', 'loan_repayment', 'share_purchase', 'dividend');

-- ============================================================
-- USERS (extends Supabase auth.users)
-- ============================================================
create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  phone_number text unique not null,
  full_name text not null,
  role user_role not null default 'farmer',
  gender text,
  district text,
  profile_photo_url text,
  language text default 'en',
  dark_mode boolean default false,
  is_verified boolean default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_users_role on public.users(role);
create index idx_users_phone on public.users(phone_number);

-- ============================================================
-- FARMERS
-- ============================================================
create table public.farmers (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  family_size int,
  main_crop text,
  farming_experience_years int,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_farmers_user on public.farmers(user_id);

-- ============================================================
-- FARMS
-- ============================================================
create table public.farms (
  id uuid primary key default uuid_generate_v4(),
  farmer_id uuid not null references public.farmers(id) on delete cascade,
  name text not null,
  location text,
  district text,
  soil_type text,
  altitude_m numeric,
  size_acres numeric,
  main_crops text[],
  date_planted date,
  photo_urls text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_farms_farmer on public.farms(farmer_id);

-- ============================================================
-- FARM BOUNDARIES (GPS land measurement)
-- ============================================================
create table public.farm_boundaries (
  id uuid primary key default uuid_generate_v4(),
  farm_id uuid not null references public.farms(id) on delete cascade,
  boundary_points jsonb not null, -- [{lat, lng, order}]
  area_acres numeric,
  area_hectares numeric,
  perimeter_m numeric,
  map_snapshot_url text,
  created_at timestamptz not null default now()
);
create index idx_boundaries_farm on public.farm_boundaries(farm_id);

-- ============================================================
-- LIVESTOCK
-- ============================================================
create table public.livestock (
  id uuid primary key default uuid_generate_v4(),
  farm_id uuid not null references public.farms(id) on delete cascade,
  animal_type text not null,
  count int not null default 0,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_livestock_farm on public.livestock(farm_id);

-- ============================================================
-- CROP RECORDS (Farm activity records)
-- ============================================================
create table public.crop_records (
  id uuid primary key default uuid_generate_v4(),
  farm_id uuid not null references public.farms(id) on delete cascade,
  activity_type text not null, -- planting, harvest, spraying, fertilizer, labour
  crop_name text,
  quantity numeric,
  unit text,
  cost numeric default 0,
  income numeric default 0,
  activity_date date not null,
  notes text,
  created_at timestamptz not null default now()
);
create index idx_crop_records_farm on public.crop_records(farm_id);
create index idx_crop_records_date on public.crop_records(activity_date);

-- ============================================================
-- WEATHER (cached lookups)
-- ============================================================
create table public.weather (
  id uuid primary key default uuid_generate_v4(),
  district text not null,
  forecast_date date not null,
  temperature_c numeric,
  humidity_pct numeric,
  wind_kmh numeric,
  rain_probability_pct numeric,
  condition text,
  is_planting_day boolean default false,
  is_spraying_day boolean default false,
  created_at timestamptz not null default now(),
  unique(district, forecast_date)
);
create index idx_weather_district_date on public.weather(district, forecast_date);

-- ============================================================
-- SACCOS
-- ============================================================
create table public.saccos (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  admin_id uuid not null references public.users(id),
  district text,
  registration_number text,
  account_balance numeric default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_saccos_admin on public.saccos(admin_id);

-- ============================================================
-- SACCO MEMBERS
-- ============================================================
create table public.members (
  id uuid primary key default uuid_generate_v4(),
  sacco_id uuid not null references public.saccos(id) on delete cascade,
  user_id uuid not null references public.users(id) on delete cascade,
  member_number text,
  join_date date default current_date,
  is_active boolean default true,
  created_at timestamptz not null default now(),
  unique(sacco_id, user_id)
);
create index idx_members_sacco on public.members(sacco_id);
create index idx_members_user on public.members(user_id);

-- ============================================================
-- SAVINGS
-- ============================================================
create table public.savings (
  id uuid primary key default uuid_generate_v4(),
  member_id uuid not null references public.members(id) on delete cascade,
  balance numeric not null default 0,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index idx_savings_member on public.savings(member_id);

-- ============================================================
-- SHARES
-- ============================================================
create table public.shares (
  id uuid primary key default uuid_generate_v4(),
  member_id uuid not null references public.members(id) on delete cascade,
  share_count int not null default 0,
  share_value numeric not null default 0,
  total_value numeric generated always as (share_count * share_value) stored,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_shares_member on public.shares(member_id);

-- ============================================================
-- LOANS
-- ============================================================
create table public.loans (
  id uuid primary key default uuid_generate_v4(),
  member_id uuid not null references public.members(id) on delete cascade,
  loan_type text not null,
  amount numeric not null,
  purpose text,
  repayment_period_months int not null,
  guarantor_id uuid references public.members(id),
  interest_rate numeric default 10,
  outstanding_balance numeric,
  status loan_status not null default 'pending',
  applied_at timestamptz not null default now(),
  approved_at timestamptz,
  disbursed_at timestamptz,
  due_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_loans_member on public.loans(member_id);
create index idx_loans_status on public.loans(status);

-- ============================================================
-- TRANSACTIONS (SACCO ledger)
-- ============================================================
create table public.transactions (
  id uuid primary key default uuid_generate_v4(),
  member_id uuid not null references public.members(id) on delete cascade,
  loan_id uuid references public.loans(id),
  type transaction_type not null,
  amount numeric not null,
  payment_method payment_method,
  reference text,
  notes text,
  created_at timestamptz not null default now()
);
create index idx_transactions_member on public.transactions(member_id);
create index idx_transactions_type on public.transactions(type);

-- ============================================================
-- VENDORS
-- ============================================================
create table public.vendors (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  shop_name text not null,
  description text,
  logo_url text,
  district text,
  rating numeric default 0,
  is_verified boolean default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_vendors_user on public.vendors(user_id);

-- ============================================================
-- PRODUCTS (Marketplace)
-- ============================================================
create table public.products (
  id uuid primary key default uuid_generate_v4(),
  vendor_id uuid not null references public.vendors(id) on delete cascade,
  name text not null,
  category text not null, -- seeds, fertilizer, feeds, chemicals, tools, machinery, produce
  description text,
  price numeric not null,
  unit text,
  stock_quantity numeric default 0,
  image_urls text[],
  is_produce boolean default false,
  location text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_products_vendor on public.products(vendor_id);
create index idx_products_category on public.products(category);

-- ============================================================
-- ORDERS
-- ============================================================
create table public.orders (
  id uuid primary key default uuid_generate_v4(),
  buyer_id uuid not null references public.users(id),
  vendor_id uuid not null references public.vendors(id),
  product_id uuid not null references public.products(id),
  quantity numeric not null,
  total_price numeric not null,
  delivery_location text,
  status order_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_orders_buyer on public.orders(buyer_id);
create index idx_orders_vendor on public.orders(vendor_id);
create index idx_orders_status on public.orders(status);

-- ============================================================
-- PAYMENTS
-- ============================================================
create table public.payments (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid references public.orders(id),
  loan_id uuid references public.loans(id),
  user_id uuid not null references public.users(id),
  amount numeric not null,
  method payment_method not null,
  status payment_status not null default 'pending',
  provider_reference text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_payments_user on public.payments(user_id);
create index idx_payments_order on public.payments(order_id);

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
create table public.notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  title text not null,
  body text not null,
  type text not null, -- weather, loan_due, order_update, marketplace, ai_recommendation
  is_read boolean default false,
  created_at timestamptz not null default now()
);
create index idx_notifications_user on public.notifications(user_id);
create index idx_notifications_read on public.notifications(is_read);

-- ============================================================
-- CROP RECOMMENDATIONS (AI Advisor)
-- ============================================================
create table public.crop_recommendations (
  id uuid primary key default uuid_generate_v4(),
  farm_id uuid not null references public.farms(id) on delete cascade,
  recommended_crop text not null,
  reason text,
  confidence numeric,
  expected_yield text,
  best_planting_window text,
  created_at timestamptz not null default now()
);
create index idx_crop_reco_farm on public.crop_recommendations(farm_id);

-- ============================================================
-- DISEASE SCANS (AI image upload/detection)
-- ============================================================
create table public.disease_scans (
  id uuid primary key default uuid_generate_v4(),
  farm_id uuid not null references public.farms(id) on delete cascade,
  crop_name text,
  image_url text not null,
  detected_disease text,
  confidence numeric,
  treatment_advice text,
  created_at timestamptz not null default now()
);
create index idx_disease_scans_farm on public.disease_scans(farm_id);

-- ============================================================
-- MESSAGES (AI chat / support)
-- ============================================================
create table public.messages (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  sender text not null, -- 'user' or 'ai'
  content text not null,
  created_at timestamptz not null default now()
);
create index idx_messages_user on public.messages(user_id);

-- ============================================================
-- SUPPORT TICKETS
-- ============================================================
create table public.support_tickets (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.users(id) on delete cascade,
  subject text not null,
  description text not null,
  status text not null default 'open',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_tickets_user on public.support_tickets(user_id);

-- ============================================================
-- updated_at trigger function
-- ============================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

do $$
declare t text;
begin
  for t in select unnest(array[
    'users','farmers','farms','livestock','saccos','members','savings','shares',
    'loans','vendors','products','orders','payments','support_tickets'
  ])
  loop
    execute format('create trigger trg_set_updated_at before update on public.%I for each row execute function public.set_updated_at();', t);
  end loop;
end $$;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
alter table public.users enable row level security;
alter table public.farmers enable row level security;
alter table public.farms enable row level security;
alter table public.farm_boundaries enable row level security;
alter table public.livestock enable row level security;
alter table public.crop_records enable row level security;
alter table public.weather enable row level security;
alter table public.saccos enable row level security;
alter table public.members enable row level security;
alter table public.savings enable row level security;
alter table public.shares enable row level security;
alter table public.loans enable row level security;
alter table public.transactions enable row level security;
alter table public.vendors enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.payments enable row level security;
alter table public.notifications enable row level security;
alter table public.crop_recommendations enable row level security;
alter table public.disease_scans enable row level security;
alter table public.messages enable row level security;
alter table public.support_tickets enable row level security;

-- Users can read/update their own profile
create policy "users_select_own" on public.users for select using (auth.uid() = id);
create policy "users_update_own" on public.users for update using (auth.uid() = id);
create policy "users_insert_own" on public.users for insert with check (auth.uid() = id);

-- Farmers own their farmer record
create policy "farmers_owner" on public.farmers for all using (
  user_id = auth.uid()
);

-- Farms belong to farmer -> user
create policy "farms_owner" on public.farms for all using (
  farmer_id in (select id from public.farmers where user_id = auth.uid())
);

create policy "boundaries_owner" on public.farm_boundaries for all using (
  farm_id in (select f.id from public.farms f join public.farmers fa on f.farmer_id = fa.id where fa.user_id = auth.uid())
);

create policy "livestock_owner" on public.livestock for all using (
  farm_id in (select f.id from public.farms f join public.farmers fa on f.farmer_id = fa.id where fa.user_id = auth.uid())
);

create policy "crop_records_owner" on public.crop_records for all using (
  farm_id in (select f.id from public.farms f join public.farmers fa on f.farmer_id = fa.id where fa.user_id = auth.uid())
);

-- Weather is public read
create policy "weather_public_read" on public.weather for select using (true);

-- SACCO admin manages their own sacco
create policy "sacco_admin_manage" on public.saccos for all using (admin_id = auth.uid());
create policy "sacco_members_read" on public.saccos for select using (
  id in (select sacco_id from public.members where user_id = auth.uid())
);

-- Members: self + sacco admin
create policy "members_self" on public.members for select using (
  user_id = auth.uid() or sacco_id in (select id from public.saccos where admin_id = auth.uid())
);
create policy "members_admin_manage" on public.members for insert with check (
  sacco_id in (select id from public.saccos where admin_id = auth.uid())
);
create policy "members_admin_update" on public.members for update using (
  sacco_id in (select id from public.saccos where admin_id = auth.uid())
);

-- Savings/Shares/Loans: member self + sacco admin
create policy "savings_access" on public.savings for select using (
  member_id in (select id from public.members where user_id = auth.uid())
  or member_id in (select m.id from public.members m join public.saccos s on m.sacco_id = s.id where s.admin_id = auth.uid())
);
create policy "shares_access" on public.shares for select using (
  member_id in (select id from public.members where user_id = auth.uid())
  or member_id in (select m.id from public.members m join public.saccos s on m.sacco_id = s.id where s.admin_id = auth.uid())
);
create policy "loans_access" on public.loans for select using (
  member_id in (select id from public.members where user_id = auth.uid())
  or member_id in (select m.id from public.members m join public.saccos s on m.sacco_id = s.id where s.admin_id = auth.uid())
);
create policy "loans_apply" on public.loans for insert with check (
  member_id in (select id from public.members where user_id = auth.uid())
);
create policy "transactions_access" on public.transactions for select using (
  member_id in (select id from public.members where user_id = auth.uid())
  or member_id in (select m.id from public.members m join public.saccos s on m.sacco_id = s.id where s.admin_id = auth.uid())
);

-- Vendors manage their own shop; public can read
create policy "vendors_public_read" on public.vendors for select using (true);
create policy "vendors_owner_manage" on public.vendors for all using (user_id = auth.uid());

-- Products public read; vendor manages own
create policy "products_public_read" on public.products for select using (true);
create policy "products_vendor_manage" on public.products for all using (
  vendor_id in (select id from public.vendors where user_id = auth.uid())
);

-- Orders: buyer or vendor involved
create policy "orders_access" on public.orders for select using (
  buyer_id = auth.uid() or vendor_id in (select id from public.vendors where user_id = auth.uid())
);
create policy "orders_create" on public.orders for insert with check (buyer_id = auth.uid());
create policy "orders_update" on public.orders for update using (
  buyer_id = auth.uid() or vendor_id in (select id from public.vendors where user_id = auth.uid())
);

-- Payments: owner only
create policy "payments_owner" on public.payments for all using (user_id = auth.uid());

-- Notifications: owner only
create policy "notifications_owner" on public.notifications for all using (user_id = auth.uid());

-- AI: farm owner
create policy "crop_reco_owner" on public.crop_recommendations for all using (
  farm_id in (select f.id from public.farms f join public.farmers fa on f.farmer_id = fa.id where fa.user_id = auth.uid())
);
create policy "disease_scans_owner" on public.disease_scans for all using (
  farm_id in (select f.id from public.farms f join public.farmers fa on f.farmer_id = fa.id where fa.user_id = auth.uid())
);

-- Messages / tickets: owner only
create policy "messages_owner" on public.messages for all using (user_id = auth.uid());
create policy "tickets_owner" on public.support_tickets for all using (user_id = auth.uid());
