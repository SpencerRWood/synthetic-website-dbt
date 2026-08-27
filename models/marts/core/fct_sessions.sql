select
    session_id,
    visitor_id,
    session_started_at,
    session_ended_at,
    session_duration_seconds,
    event_count,
    page_view_count,
    entry_page_name,
    exit_page_name,
    reached_order_confirmation
from {{ ref('int_sessions__derived') }}
