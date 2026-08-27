with events as (

    select * from {{ ref('stg_raw__events') }}

),

ordered as (

    select
        event_id,
        visitor_id,
        session_id,
        page,
        page_name,
        timestamp,
        event_timestamp,
        event_type,
        properties,
        product_id,
        category,
        price,
        quantity,
        cart_value,
        search_query,
        results_count,
        items_count,
        order_id,
        order_value,
        form_id,
        newsletter_id,
        row_number() over (
            partition by session_id
            order by event_timestamp, event_id
        ) as session_event_number,
        row_number() over (
            partition by visitor_id
            order by event_timestamp, event_id
        ) as visitor_event_number,
        lag(page_name) over (
            partition by session_id
            order by event_timestamp, event_id
        ) as previous_page_name,
        lead(page_name) over (
            partition by session_id
            order by event_timestamp, event_id
        ) as next_page_name,
        lag(event_timestamp) over (
            partition by session_id
            order by event_timestamp, event_id
        ) as previous_event_timestamp,
        lead(event_timestamp) over (
            partition by session_id
            order by event_timestamp, event_id
        ) as next_event_timestamp
    from events

),

final as (

    select
        event_id,
        visitor_id,
        session_id,
        page,
        page_name,
        timestamp,
        event_timestamp,
        event_type,
        properties,
        product_id,
        category,
        price,
        quantity,
        cart_value,
        search_query,
        results_count,
        items_count,
        order_id,
        order_value,
        form_id,
        newsletter_id,
        session_event_number,
        visitor_event_number,
        previous_page_name,
        next_page_name,
        previous_event_timestamp,
        next_event_timestamp,
        session_event_number = 1 as is_session_entry_event,
        next_event_timestamp is null as is_session_exit_event,
        extract(epoch from event_timestamp - previous_event_timestamp)
            as seconds_since_previous_event
    from ordered

)

select * from final
