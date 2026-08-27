select
    visitor_id,
    first_seen_at,
    last_seen_at,
    session_count,
    event_count,
    page_view_count,
    reached_order_confirmation
from {{ ref('int_visitors__derived') }}
