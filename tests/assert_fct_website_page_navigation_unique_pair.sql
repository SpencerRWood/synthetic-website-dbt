select
    from_page,
    to_page,
    count(*) as row_count
from {{ ref('fct_website_page_navigation') }}
group by 1, 2
having count(*) > 1
