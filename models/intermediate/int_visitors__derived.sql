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
        sum(click_count) as click_count,
        sum(product_view_count) as product_view_count,
        sum(search_count) as search_count,
        sum(add_to_cart_count) as add_to_cart_count,
        sum(begin_checkout_count) as begin_checkout_count,
        sum(purchase_count) as purchase_count,
        sum(form_submit_count) as form_submit_count,
        sum(newsletter_signup_count) as newsletter_signup_count,
        sum(order_count) as order_count,
        sum(total_order_value) as total_order_value,
        sum(total_items_purchased) as total_items_purchased,
        sum(total_quantity_added_to_cart) as total_quantity_added_to_cart,
        max(max_cart_value) as max_cart_value,
        bool_or(reached_order_confirmation) as reached_order_confirmation
    from sessions
    group by 1

)

select * from visitors
