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
        count(*) filter (where event_type = 'page_view') as page_view_count,
        count(*) filter (where event_type = 'click') as click_count,
        count(*) filter (where event_type = 'product_view') as product_view_count,
        count(*) filter (where event_type = 'search') as search_count,
        count(*) filter (where event_type = 'add_to_cart') as add_to_cart_count,
        count(*) filter (where event_type = 'begin_checkout')
            as begin_checkout_count,
        count(*) filter (where event_type = 'purchase') as purchase_count,
        count(*) filter (where event_type = 'form_submit') as form_submit_count,
        count(*) filter (where event_type = 'newsletter_signup')
            as newsletter_signup_count,
        count(distinct order_id) filter (where event_type = 'purchase')
            as order_count,
        coalesce(
            sum(order_value) filter (where event_type = 'purchase'),
            0
        ) as total_order_value,
        coalesce(
            sum(items_count) filter (where event_type = 'purchase'),
            0
        ) as total_items_purchased,
        coalesce(
            sum(quantity) filter (where event_type = 'add_to_cart'),
            0
        ) as total_quantity_added_to_cart,
        max(cart_value) as max_cart_value,
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
        click_count,
        product_view_count,
        search_count,
        add_to_cart_count,
        begin_checkout_count,
        purchase_count,
        form_submit_count,
        newsletter_signup_count,
        order_count,
        total_order_value,
        total_items_purchased,
        total_quantity_added_to_cart,
        max_cart_value,
        entry_page_name,
        exit_page_name,
        reached_order_confirmation,
        extract(epoch from session_ended_at - session_started_at)
            as session_duration_seconds
    from sessions

)

select * from final
