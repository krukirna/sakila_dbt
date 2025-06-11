{{
  config(
    materialized = 'incremental',
    unique_key = 'rental_id'
  )
}}

select

from {{source('stg', 'rental')}} as rental
left join {{ ref('dim_customer') }}