{% macro delete_from(this) %}
    delete from {{ this }}
{% endmacro %}