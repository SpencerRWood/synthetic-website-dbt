with page_links as (

    select * from {{ ref('stg_website_page_links') }}

),

website_pages as (

    select from_page as page_id
    from page_links

    union

    select to_page as page_id
    from page_links

)

select
    page_id::text as page_id,
    page_id::text as page_path,
    page_id::text as page_name,
    null::text as page_type,
    null::text as parent_page_id,
    null::boolean as is_active,
    null::timestamptz as published_at,
    null::timestamptz as updated_at
from website_pages
