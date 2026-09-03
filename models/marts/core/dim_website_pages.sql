with website_pages as (

    select * from {{ ref('stg_website') }}

),

page_links as (

    select * from {{ ref('stg_website_page_links') }}

),

incoming_pages as (

    select distinct to_page
    from page_links

),

outgoing_pages as (

    select distinct from_page
    from page_links

)

select
    website_pages.page_id,
    website_pages.page_path,
    website_pages.page_name,
    website_pages.page_type,
    website_pages.parent_page_id,
    website_pages.is_active,
    website_pages.published_at,
    website_pages.updated_at,
    incoming_pages.to_page is null as is_entry_page,
    outgoing_pages.from_page is null as is_terminal_page
from website_pages
left join incoming_pages
    on website_pages.page_id = incoming_pages.to_page
left join outgoing_pages
    on website_pages.page_id = outgoing_pages.from_page
