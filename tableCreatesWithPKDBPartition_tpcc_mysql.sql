drop table if exists config;
create table config (
  cfg_name    varchar(30) primary key,
  cfg_value   varchar(50)
);

drop table if exists warehouse;
create table warehouse (
  w_id        integer   not null,
  w_name      varchar(10),
  w_street_1  varchar(20),
  w_street_2  varchar(20),
  w_city      varchar(20),
  w_state     char(2),
  w_zip       char(9),
  w_tax       decimal(4,4),
  w_ytd       decimal(12,2),
  primary key (w_id)
) dbpartition by hash(w_id);

drop table if exists district;
create table district (
  d_id         integer       not null,
  d_w_id       integer       not null,
  d_name       varchar(10),
  d_street_1   varchar(20),
  d_street_2   varchar(20),
  d_city       varchar(20),
  d_state      char(2),
  d_zip        char(9),
  d_tax        decimal(4,4),
  d_ytd        decimal(12,2),
  d_next_o_id  integer,
  primary key (d_w_id, d_id)
) dbpartition by hash(d_w_id);

drop table if exists customer;
create table customer (
  c_id           integer        not null,
  c_d_id         integer        not null,
  c_w_id         integer        not null,
  c_first        varchar(16),
  c_middle       char(2),
  c_last         varchar(16),
  c_street_1     varchar(20),
  c_street_2     varchar(20),
  c_city         varchar(20),
  c_state        char(2),
  c_zip          char(9),
  c_phone        char(16),
  c_since        timestamp,
  c_credit       char(2),
  c_credit_lim   bigint,
  c_discount     decimal(4,4),
  c_balance      decimal(12,2),
  c_ytd_payment  decimal(12,2),
  c_payment_cnt  integer,
  c_delivery_cnt integer,
  c_data         text,
  primary key (c_w_id, c_d_id, c_id)
) dbpartition by hash(c_w_id);

-- commented this out since it reports errors
-- create sequence hist_id_seq;

drop table if exists history;
create table history (
  h_c_id   integer,
  h_c_d_id integer,
  h_c_w_id integer,
  h_d_id   integer,
  h_w_id   integer,
  h_date   timestamp,
  h_amount decimal(6,2),
  h_data   varchar(24),
  hist_id  integer primary key,
) dbpartition by hash(h_c_w_id);

drop table if exists new_orders;
create table new_orders (
  no_o_id  integer   not null,
  no_d_id  integer   not null,
  no_w_id  integer   not null,
  primary key (no_w_id, no_d_id, no_o_id)
) dbpartition by hash(no_w_id);

drop table if exists orders;
create table orders (
  o_id         integer      not null,
  o_d_id       integer      not null,
  o_w_id       integer      not null,
  o_c_id       integer,
  o_entry_d    timestamp,
  o_carrier_id integer,
  o_ol_cnt     integer,
  o_all_local  integer,
  primary key (o_w_id, o_d_id, o_id)
) dbpartition by hash(o_w_id);

drop table if exists order_line;
create table order_line (
  ol_o_id         integer   not null,
  ol_d_id         integer   not null,
  ol_w_id         integer   not null,
  ol_number       integer   not null,
  ol_i_id         integer   not null,
  ol_supply_w_id  integer,
  ol_delivery_d   timestamp,
  ol_quantity     integer,
  ol_amount       decimal(6,2),
  ol_dist_info    char(24),
  primary key (ol_w_id, ol_d_id, ol_o_id, ol_number)
) dbpartition by hash(ol_w_id);

drop table if exists item;
create table item (
  i_id     integer      not null,
  i_im_id  integer,
  i_name   varchar(24),
  i_price  decimal(5,2),
  i_data   varchar(50),
  primary key (i_id)
);

drop table if exists stock;
create table stock (
  s_i_id       integer       not null,
  s_w_id       integer       not null,
  s_quantity   integer,
  s_dist_01    char(24),
  s_dist_02    char(24),
  s_dist_03    char(24),
  s_dist_04    char(24),
  s_dist_05    char(24),
  s_dist_06    char(24),
  s_dist_07    char(24),
  s_dist_08    char(24),
  s_dist_09    char(24),
  s_dist_10    char(24),
  s_ytd        decimal(8,0),
  s_order_cnt  integer,
  s_remote_cnt integer,
  s_data       varchar(50),
  primary key (s_w_id, s_i_id)
) dbpartition by hash(s_w_id);


