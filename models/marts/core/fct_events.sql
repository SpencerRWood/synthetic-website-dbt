select
    event_id,
    visitor_id,
    session_id,
    page_name,
    event_timestamp,
    session_event_number,
    visitor_event_number,
    previous_page_name,
    next_page_name,
    previous_event_timestamp,
    next_event_timestamp,
    is_session_entry_event,
    is_session_exit_event,
    seconds_since_previous_event
from {{ ref('int_events__ordered') }}
