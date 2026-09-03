with page_links as (

    select * from {{ ref('stg_website_page_links') }}

),

observed_transitions as (

    select
        previous_page_name as from_page,
        page_name as to_page
    from {{ ref('int_events__ordered') }}
    where previous_page_name is not null

),

edge_counts as (

    select
        page_links.from_page,
        page_links.to_page,
        count(observed_transitions.to_page) as transition_count
    from page_links
    left join observed_transitions
        on
            page_links.from_page = observed_transitions.from_page
            and page_links.to_page = observed_transitions.to_page
    group by 1, 2

),

navigation as (

    select
        from_page,
        to_page,
        transition_count,
        sum(transition_count) over (
            partition by from_page
        ) as from_page_transition_count
    from edge_counts

),

website_pages as (

    select * from {{ ref('dim_website_pages') }}

)

select
    navigation.from_page,
    navigation.to_page,
    from_pages.page_name as from_page_name,
    to_pages.page_name as to_page_name,
    navigation.transition_count,
    navigation.from_page_transition_count,
    coalesce(
        navigation.transition_count::numeric
        / nullif(navigation.from_page_transition_count, 0),
        0
    ) as observed_transition_probability
from navigation
inner join website_pages as from_pages
    on navigation.from_page = from_pages.page_id
inner join website_pages as to_pages
    on navigation.to_page = to_pages.page_id
