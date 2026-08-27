with source_events as (

    select * from {{ source('raw', 'events') }}

),

renamed as (

    select
        event_id,
        visitor_id,
        session_id,
        page as page_name,
        timestamp as event_timestamp
    from source_events

)

select * from renamed
