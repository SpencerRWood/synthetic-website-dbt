select
    date_day,
    campaign_id,
    count(*) as row_count
from {{ ref('stg_raw__campaigns') }}
group by 1, 2
having count(*) > 1
