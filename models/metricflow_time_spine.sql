{{ config(materialized='view') }}

select distinct
  to_date(d_date) as date_day
from {{ source('retail_src', 'SNOW_DATE') }}
where d_date is not null
