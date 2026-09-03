with page_links as (

    select * from {{ ref('stg_website_page_links') }}

),

funnel_graph as (

    select
        bool_or(from_page = 'cart' and to_page = 'checkout')
            as has_cart_to_checkout_link,
        bool_or(from_page = 'checkout' and to_page = 'order_confirmation')
            as has_checkout_to_confirmation_link
    from page_links

),

session_pages as (

    select
        session_id,
        min(event_timestamp) filter (where page_name = 'home') as home_at,
        min(event_timestamp) filter (where page_name = 'blog') as blog_at,
        min(event_timestamp) filter (where page_name = 'products')
            as products_at,
        min(event_timestamp) filter (where page_name = 'cart') as cart_at,
        min(event_timestamp) filter (where page_name = 'checkout') as checkout_at,
        min(event_timestamp) filter (
            where page_name = 'order_confirmation'
        ) as order_confirmation_at
    from {{ ref('int_events__ordered') }}
    group by 1

),

session_funnel as (

    select
        sessions.session_started_at::date as date_day,
        session_pages.home_at is not null as reached_home,
        session_pages.blog_at is not null as reached_blog,
        session_pages.products_at is not null as reached_products,
        session_pages.cart_at is not null as reached_cart,
        session_pages.checkout_at > session_pages.cart_at as reached_checkout,
        session_pages.order_confirmation_at > session_pages.checkout_at
        and session_pages.checkout_at > session_pages.cart_at
            as reached_order_confirmation
    from {{ ref('int_sessions__derived') }} as sessions
    inner join session_pages
        on sessions.session_id = session_pages.session_id

),

daily_funnel as (

    select
        session_funnel.date_day,
        count(*) filter (where session_funnel.reached_home) as home_session_count,
        count(*) filter (where session_funnel.reached_blog) as blog_session_count,
        count(*) filter (
            where session_funnel.reached_products
        ) as products_session_count,
        count(*) filter (where session_funnel.reached_cart) as cart_session_count,
        count(*) filter (
            where
            funnel_graph.has_cart_to_checkout_link
            and session_funnel.reached_checkout
        ) as checkout_session_count,
        count(*) filter (
            where
            funnel_graph.has_cart_to_checkout_link
            and funnel_graph.has_checkout_to_confirmation_link
            and session_funnel.reached_order_confirmation
        ) as order_confirmation_session_count
    from session_funnel
    cross join funnel_graph
    group by 1

)

select * from daily_funnel
