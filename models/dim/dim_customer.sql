{{
	  config(
		unique_key = 'customer_id',
		post_hook = "update {{source('stg', 'z_refresh_from')}} set to_refresh = 0 where table_name = '{{ this }}'",
		indexes=[
			{'columns': ['create_date']}
			],
		identifier = 'ua_2025'
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
		c.customer_id,
		c.store_id,
		c.first_name,
		c.last_name,
		c.email,
		c.address_id,
		c.create_date,
		c.last_update,
		c.active,
		'{{ run_started_at }}'::timestamp AT TIME ZONE 'UTC' as etl_time,
		'{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}' as etl_time_str
from {{ source('stg','customer') }} as c
left join {{ source('stg','address') }} as a on a.address_id = c.address_id 
left join {{ source('stg','city') }} as ci on ci.city_id = a.city_id 


{% if is_incremental() %}
	where c.last_update >= coalesce(
								(select from_date from refresh_date ), 
								{{ var('init_date') }})

{% endif %}