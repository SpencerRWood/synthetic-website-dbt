with ordered_events as (

    select * from {{ ref('int_events__ordered') }}

),

visitor_profiles as (

    select
        visitor_id,
        (
            array_agg(
                first_name
                order by event_timestamp desc, event_id desc
            ) filter (where first_name is not null)
        )[1] as first_name,
        (
            array_agg(
                last_name
                order by event_timestamp desc, event_id desc
            ) filter (where last_name is not null)
        )[1] as last_name,
        (
            array_agg(
                email
                order by event_timestamp desc, event_id desc
            ) filter (where email is not null)
        )[1] as email,
        (
            array_agg(
                phone
                order by event_timestamp desc, event_id desc
            ) filter (where phone is not null)
        )[1] as phone,
        (
            array_agg(
                shipping_state
                order by event_timestamp desc, event_id desc
            ) filter (where shipping_state is not null)
        )[1] as shipping_state,
        (
            array_agg(
                shipping_postal_code
                order by event_timestamp desc, event_id desc
            ) filter (where shipping_postal_code is not null)
        )[1] as shipping_postal_code,
        min(event_timestamp) filter (
            where coalesce(
                first_name,
                last_name,
                email,
                phone,
                shipping_state,
                shipping_postal_code
            ) is not null
        ) as profile_first_observed_at,
        max(event_timestamp) filter (
            where coalesce(
                first_name,
                last_name,
                email,
                phone,
                shipping_state,
                shipping_postal_code
            ) is not null
        ) as profile_last_observed_at
    from ordered_events
    group by 1

)

select * from visitor_profiles
