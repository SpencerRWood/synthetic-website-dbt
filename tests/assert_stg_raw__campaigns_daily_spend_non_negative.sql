select *
from {{ ref('stg_raw__campaigns') }}
where daily_spend < 0
