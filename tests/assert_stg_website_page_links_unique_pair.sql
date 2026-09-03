select
    from_page,
    to_page,
    count(*) as row_count
from {{ ref('stg_website_page_links') }}
group by 1, 2
having count(*) > 1
