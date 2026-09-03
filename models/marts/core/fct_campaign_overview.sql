with campaigns as (

    select * from {{ ref('stg_raw__campaigns') }}

),

active_campaign_days as (

    select *
    from campaigns
    where daily_spend > 0

),

campaign_overview as (

    select
        campaign_id,
        min(date_day) as campaign_start_date,
        max(date_day) as campaign_end_date,
        sum(daily_spend) as total_spend,
        min(channel) as channel,
        min(utm_source) as utm_source,
        min(utm_medium) as utm_medium
    from active_campaign_days
    group by 1

)

select * from campaign_overview
