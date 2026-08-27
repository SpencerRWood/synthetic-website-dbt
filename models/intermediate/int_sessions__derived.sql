with ordered_events as (

    select * from {{ ref('int_events__ordered') }}

),

sessions as (

    select
        session_id,
        visitor_id,
        min(event_timestamp) as session_started_at,
        max(event_timestamp) as session_ended_at,
        count(*) as event_count,
        max(session_event_number) as page_view_count,
        (array_agg(page_name order by event_timestamp, event_id))[1]
            as entry_page_name,
        (array_agg(page_name order by event_timestamp desc, event_id desc))[1]
            as exit_page_name,
        bool_or(page_name = 'order_confirmation') as reached_order_confirmation
    from ordered_events
    group by 1, 2

),

final as (

    select
        session_id,
        visitor_id,
        session_started_at,
        session_ended_at,
        event_count,
        page_view_count,
        entry_page_name,
        exit_page_name,
        reached_order_confirmation,
        extract(epoch from session_ended_at - session_started_at)
            as session_duration_seconds
    from sessions

)

select * from final
