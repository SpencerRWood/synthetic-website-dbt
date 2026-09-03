with source_website as (

    select * from {{ source('raw', 'website') }}

),

valid_page_links as (

    select
        nullif(trim(from_page::text), '') as from_page,
        nullif(trim(to_page::text), '') as to_page
    from source_website

),

deduplicated as (

    select distinct
        from_page,
        to_page
    from valid_page_links
    where
        from_page is not null
        and to_page is not null

)

select * from deduplicated
