{% macro posthook(table) %}
   update {{table}} set to_refresh = 0 where table_name = '{{ this }}'
{% endmacro %}