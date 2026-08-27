with source_events as (

    select * from {{ source('raw', 'events') }}

),

renamed as (

    select
        event_id,
        visitor_id,
        session_id,
        page,
        page as page_name,
        timestamp,
        timestamp as event_timestamp,
        event_type,
        properties,
        nullif(properties ->> 'product_id', '') as product_id,
        nullif(properties ->> 'category', '') as category,
        case
            when nullif(properties ->> 'price', '') ~ '^-?[0-9]+(\.[0-9]+)?$'
                then (properties ->> 'price')::numeric
        end as price,
        case
            when nullif(properties ->> 'quantity', '') ~ '^-?[0-9]+$'
                then (properties ->> 'quantity')::integer
        end as quantity,
        case
            when nullif(properties ->> 'cart_value', '') ~ '^-?[0-9]+(\.[0-9]+)?$'
                then (properties ->> 'cart_value')::numeric
        end as cart_value,
        nullif(properties ->> 'search_query', '') as search_query,
        case
            when nullif(properties ->> 'results_count', '') ~ '^-?[0-9]+$'
                then (properties ->> 'results_count')::integer
        end as results_count,
        case
            when nullif(properties ->> 'items_count', '') ~ '^-?[0-9]+$'
                then (properties ->> 'items_count')::integer
        end as items_count,
        nullif(properties ->> 'order_id', '') as order_id,
        case
            when nullif(properties ->> 'order_value', '') ~ '^-?[0-9]+(\.[0-9]+)?$'
                then (properties ->> 'order_value')::numeric
        end as order_value,
        nullif(properties ->> 'form_id', '') as form_id,
        nullif(properties ->> 'newsletter_id', '') as newsletter_id,
        nullif(properties ->> 'first_name', '') as first_name,
        nullif(properties ->> 'last_name', '') as last_name,
        nullif(properties ->> 'email', '') as email,
        nullif(properties ->> 'phone', '') as phone,
        nullif(properties ->> 'shipping_state', '') as shipping_state,
        nullif(properties ->> 'shipping_postal_code', '')
            as shipping_postal_code
    from source_events

)

select * from renamed
