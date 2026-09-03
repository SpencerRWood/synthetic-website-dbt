with expected as (

    select
        campaign_id,
        min(date_day) as campaign_start_date,
        max(date_day) as campaign_end_date
    from {{ ref('stg_raw__campaigns') }}
    where daily_spend > 0
    group by 1

),

actual as (

    select
        campaign_id,
        campaign_start_date,
        campaign_end_date
    from {{ ref('fct_campaign_overview') }}

)

select
    expected.campaign_id as expected_campaign_id,
    actual.campaign_id as actual_campaign_id,
    expected.campaign_start_date as expected_campaign_start_date,
    actual.campaign_start_date as actual_campaign_start_date,
    expected.campaign_end_date as expected_campaign_end_date,
    actual.campaign_end_date as actual_campaign_end_date
from expected
full outer join actual
    on expected.campaign_id = actual.campaign_id
where
    expected.campaign_start_date is distinct from actual.campaign_start_date
    or expected.campaign_end_date is distinct from actual.campaign_end_date
