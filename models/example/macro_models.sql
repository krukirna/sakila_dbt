select
{{ macro_example('title', 'description') }} as macro_example_output
from {{source('stg', 'film') }}