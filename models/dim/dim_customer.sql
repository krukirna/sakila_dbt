{{
	  config(
		unique_key = 'customer_id',
		pre_hook = "delete from {{this}}",
		post_hook = "update {{source('stg', 'z_refresh_from')}} set to_refresh = 0 where table_name = '{{ this }}'"
		)
}}

with refresh_date as (
	select from_date
	from {{ source('stg','z_refresh_from') }}
	where table_name = '{{this}}' and to_refresh = 1
)
select  ci.city as city, 
		c.first_name || ' ' || c.last_name as full_name,
		right(c.email, length(c.email) - position('@' in c.email)) as domain,
		case when c.activebool then 'yes' else 'no' end as active_desc,
		c.*
from {{ source('stg','customer') }} as c
left join {{ source('stg','address') }} as a on a.address_id = c.address_id 
left join {{ source('stg','city') }} as ci on ci.city_id = a.city_id 


{% if is_incremental() %}
--	where c.last_update >= coalesce((select max(last_update) from {{ this }}), '1900-01-01')
	where c.last_update >= coalesce(
									(select from_date from refresh_date ), 
									(select max(last_update) from {{ this }}),
									'1900-01-01')
{% endif %}