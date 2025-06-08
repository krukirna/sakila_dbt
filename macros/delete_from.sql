{% macro delete_from(this) %}

{% if is_incremental() %}

    delete from {{ this }}

{% endif %}



{% endmacro %}