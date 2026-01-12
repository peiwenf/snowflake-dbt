{{ config(materialized='view') }}

with store_sales as (
    select * from {{ source('retail_src', 'SNOW_STORE_SALES') }}
),
date_dim as (
    select
        d_date_sk,
        d_date
    from {{ source('retail_src', 'SNOW_DATE') }}
),
customer as (
    select
        c_customer_sk,
        c_customer_id,
        c_first_name,
        c_last_name,
        c_birth_year,
        c_birth_country
    from {{ source('retail_src', 'SNOW_CUSTOMER') }}
),
item as (
    select
        i_item_sk,
        i_item_id,
        i_brand,
        i_category,
        i_class,
        i_product_name,
        i_current_price
    from {{ source('retail_src', 'SNOW_ITEM') }}
)

select
    -- keys
    ss.ss_ticket_number,
    ss.ss_sold_date_sk,
    ss.ss_item_sk,
    ss.ss_customer_sk,

    -- time
    to_date(d.d_date) as sold_date,
    cast(d.d_date as timestamp_tz) as sold_at,

    -- customer dims
    c.c_customer_id,
    c.c_first_name,
    c.c_last_name,
    c.c_birth_year,
    c.c_birth_country,

    -- item dims
    i.i_item_id,
    i.i_brand,
    i.i_category,
    i.i_class,
    i.i_product_name,
    i.i_current_price,

    -- measures
    ss.ss_quantity,
    ss.ss_sales_price,
    ss.ss_ext_sales_price,
    ss.ss_net_paid,
    ss.ss_net_paid_inc_tax,
    ss.ss_net_provit

from store_sales ss
left join date_dim d
  on ss.ss_sold_date_sk = d.d_date_sk
left join customer c
  on ss.ss_customer_sk = c.c_customer_sk
left join item i
  on ss.ss_item_sk = i.i_item_sk
where d.d_date is not null
