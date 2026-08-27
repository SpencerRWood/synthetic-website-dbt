with modeled_columns as (

    select
        '{{ ref("stg_raw__events").schema }}' as table_schema,
        '{{ ref("stg_raw__events").identifier }}' as table_name
    union all
    select
        '{{ ref("int_events__ordered").schema }}' as table_schema,
        '{{ ref("int_events__ordered").identifier }}' as table_name
    union all
    select
        '{{ ref("int_visitor_profiles__latest").schema }}' as table_schema,
        '{{ ref("int_visitor_profiles__latest").identifier }}' as table_name
    union all
    select
        '{{ ref("fct_events").schema }}' as table_schema,
        '{{ ref("fct_events").identifier }}' as table_name
    union all
    select
        '{{ ref("dim_visitors").schema }}' as table_schema,
        '{{ ref("dim_visitors").identifier }}' as table_name

),

demographic_columns as (

    select
        information_schema.columns.table_schema,
        information_schema.columns.table_name,
        information_schema.columns.column_name
    from information_schema.columns
    inner join modeled_columns
        on
            information_schema.columns.table_schema
            = modeled_columns.table_schema
            and information_schema.columns.table_name
            = modeled_columns.table_name
    where information_schema.columns.column_name in (
        'age',
        'income',
        'gender',
        'household_size',
        'education',
        'occupation',
        'marital_status',
        'ethnicity',
        'political_affiliation'
    )

)

select * from demographic_columns
