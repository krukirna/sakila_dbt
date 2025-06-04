select
    {{ macro_example('title', 'description') }} as macro_example_output,
    {{ clean_string('description') }} as cleaned_description
from {{source('stg', 'film') }}