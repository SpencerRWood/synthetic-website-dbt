select *
from {{ ref('fct_website_daily_metrics') }}
where
    session_count != (
        paid_search_session_count
        + display_session_count
        + unattributed_session_count
    )
