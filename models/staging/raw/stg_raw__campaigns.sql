with source_campaigns as (

    select * from {{ source('raw', 'campaigns') }}

),

renamed as (

    select
        date_day::date as date_day,
        campaign_id,
        channel,
        utm_source,
        utm_medium,
        utm_campaign,
        daily_spend,
        actual_adstock,
        actual_saturated_demand
    from source_campaigns

)

select * from renamed
