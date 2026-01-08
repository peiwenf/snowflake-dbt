{{ config(materialized='view') }}

select distinct
  cast(d_date as date) as date_day
from {{ source('retail_src', 'SNOW_DATE') }}
where d_date is not null