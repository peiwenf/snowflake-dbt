select
  *
from {{ source('retail_src', 'SNOW_STORE_SALES') }}
