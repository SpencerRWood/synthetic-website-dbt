select *
from {{ ref('fct_website_daily_conversion_funnel') }}
where
    checkout_session_count > cart_session_count
    or order_confirmation_session_count > checkout_session_count
