with campaigns as (

    select * from {{ ref('stg_raw__campaigns') }}

),

observed_campaign_traffic as (

    select
        date_day,
        campaign_id,
        count(distinct session_id) as observed_sessions,
        count(distinct visitor_id) as observed_visitors,
        coalesce(sum(event_count), 0) as observed_events,
        coalesce(sum(page_view_count), 0) as observed_pageviews
    from {{ ref('int_campaign_sessions__derived') }}
    where campaign_id is not null
    group by 1, 2

),

final as (

    select
        campaigns.date_day,
        campaigns.campaign_id,
        campaigns.channel,
        campaigns.utm_source,
        campaigns.utm_medium,
        campaigns.utm_campaign,
        campaigns.daily_spend,
        coalesce(observed_campaign_traffic.observed_sessions, 0)
            as observed_sessions,
        coalesce(observed_campaign_traffic.observed_visitors, 0)
            as observed_visitors,
        coalesce(observed_campaign_traffic.observed_events, 0)
            as observed_events,
        coalesce(observed_campaign_traffic.observed_pageviews, 0)
            as observed_pageviews
    from campaigns
    left join observed_campaign_traffic
        on
            campaigns.date_day = observed_campaign_traffic.date_day
            and campaigns.campaign_id = observed_campaign_traffic.campaign_id

)

select * from final
