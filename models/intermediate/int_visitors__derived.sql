with sessions as (

    select * from {{ ref('int_sessions__derived') }}

),

visitors as (

    select
        visitor_id,
        min(session_started_at) as first_seen_at,
        max(session_ended_at) as last_seen_at,
        count(*) as session_count,
        sum(event_count) as event_count,
        sum(page_view_count) as page_view_count,
        bool_or(reached_order_confirmation) as reached_order_confirmation
    from sessions
    group by 1

)

select * from visitors
