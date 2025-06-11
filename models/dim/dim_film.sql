{% set my_column_list = ['trailers', 'deleted scenes', 'behind the scenes', 'commentaries'] %}




select
{% for feature in my_column_list %}
  case when special_features ilike '%{{feature}}%' then 1 else 0 end as "is_{{feature}}"
    {% if not loop.last %},{% endif %}
{% endfor %}
from {{ source('stg', 'film') }}