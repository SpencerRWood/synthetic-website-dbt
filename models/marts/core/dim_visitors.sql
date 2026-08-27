with visitors as (

    select * from {{ ref('int_visitors__derived') }}

),

visitor_profiles as (

    select * from {{ ref('int_visitor_profiles__latest') }}

)

select
    visitors.visitor_id,
    visitors.first_seen_at,
    visitors.last_seen_at,
    visitors.session_count,
    visitors.event_count,
    visitors.page_view_count,
    visitors.click_count,
    visitors.product_view_count,
    visitors.search_count,
    visitors.add_to_cart_count,
    visitors.begin_checkout_count,
    visitors.purchase_count,
    visitors.form_submit_count,
    visitors.newsletter_signup_count,
    visitors.order_count,
    visitors.total_order_value,
    visitors.total_items_purchased,
    visitors.total_quantity_added_to_cart,
    visitors.max_cart_value,
    visitors.reached_order_confirmation,
    visitor_profiles.first_name,
    visitor_profiles.last_name,
    visitor_profiles.email,
    visitor_profiles.phone,
    visitor_profiles.shipping_state,
    visitor_profiles.shipping_postal_code,
    visitor_profiles.profile_first_observed_at,
    visitor_profiles.profile_last_observed_at
from visitors
left join visitor_profiles
    on visitors.visitor_id = visitor_profiles.visitor_id
