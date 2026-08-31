with sessions as (

    select * from {{ ref('int_sessions__derived') }}

),

campaigns as (

    select * from {{ ref('stg_raw__campaigns') }}

),

session_campaigns as (

    select
        sessions.session_id,
        sessions.visitor_id,
        sessions.session_started_at,
        sessions.campaign_id,
        sessions.is_campaign_driven,
        campaigns.daily_spend,
        sessions.event_count,
        sessions.page_view_count,
        sessions.session_started_at::date as date_day,
        coalesce(sessions.channel, campaigns.channel) as channel,
        coalesce(sessions.utm_source, campaigns.utm_source) as utm_source,
        coalesce(sessions.utm_medium, campaigns.utm_medium) as utm_medium,
        coalesce(sessions.utm_campaign, campaigns.utm_campaign) as utm_campaign
    from sessions
    left join campaigns
        on
            sessions.campaign_id = campaigns.campaign_id
            and sessions.session_started_at::date = campaigns.date_day

),

final as (

    select
        session_id,
        visitor_id,
        session_started_at,
        date_day,
        campaign_id,
        channel,
        utm_source,
        utm_medium,
        utm_campaign,
        is_campaign_driven,
        daily_spend,
        event_count,
        page_view_count
    from session_campaigns

)

select * from final
