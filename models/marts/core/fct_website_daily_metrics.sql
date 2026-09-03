with sessions as (

    select * from {{ ref('int_sessions__derived') }}

),

daily_metrics as (

    select
        session_started_at::date as date_day,
        count(*) as session_count,
        count(*) filter (where channel = 'paid_search')
            as paid_search_session_count,
        count(*) filter (where channel = 'display') as display_session_count,
        count(*) filter (where channel is null) as unattributed_session_count,
        count(distinct visitor_id) as visitor_count,
        sum(event_count) as event_count,
        sum(page_view_count) as page_view_count,
        sum(product_view_count) as product_view_count,
        sum(search_count) as search_count,
        sum(add_to_cart_count) as add_to_cart_count,
        sum(begin_checkout_count) as begin_checkout_count,
        sum(purchase_count) as purchase_count,
        sum(newsletter_signup_count) as newsletter_signup_count,
        sum(order_count) as order_count,
        sum(total_order_value) as total_order_value,
        sum(total_items_purchased) as total_items_purchased,
        count(*) filter (where product_view_count > 0) as product_view_session_count,
        count(*) filter (where add_to_cart_count > 0) as add_to_cart_session_count,
        count(*) filter (where begin_checkout_count > 0)
            as begin_checkout_session_count,
        count(*) filter (where purchase_count > 0) as purchase_session_count
    from sessions
    group by 1

)

select * from daily_metrics
