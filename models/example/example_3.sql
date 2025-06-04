select *
from {{ source('stg', 'customer')}}