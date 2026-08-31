select *
from {{ ref('stg_raw__campaigns') }}
where
    actual_saturated_demand < 0
    or actual_saturated_demand > 1
