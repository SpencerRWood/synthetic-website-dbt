select
    date_day,
    channel,
    count(*) as row_count
from {{ ref('fct_website_daily_channel_metrics') }}
group by 1, 2
having count(*) > 1
