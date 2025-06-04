{% macro clean_string(col) %}
    lower(lower(regexp_replace({{ col }}, '[^a-zA-Z0-9]', '', 'g')))
{% endmacro %}