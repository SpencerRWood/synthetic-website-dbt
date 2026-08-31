select *
from {{ ref('stg_raw__campaigns') }}
where actual_adstock < 0
