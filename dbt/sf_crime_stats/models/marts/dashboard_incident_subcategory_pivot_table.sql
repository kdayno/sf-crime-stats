{{ config(materialized="table") }}

with dim_incident_date as (
    select 
        *
        , concat(month_name_short, ' ', year_number) AS month_year
    from {{ ref('dim_incident_date') }}
    ),

    incidents_monthly_agg as (
        select
            didate.month_start_date
            , didate.month_year
            , coalesce(did.incident_category, 'None') as incident_category
            , coalesce(did.incident_subcategory, 'None') as incident_subcategory
            , coalesce(did.incident_description, 'None') as incident_description
            , count(fi.incident_id) as incident_count
        from {{ ref('fact_incidents') }} as fi
        left join {{ ref('dim_incident_details') }} as did
            on fi.incident_details_fk = did.incident_details_id
        left join dim_incident_date as didate
            on fi.incident_date_fk = didate.incident_date_id
        group by 
                didate.month_start_date
                , didate.month_year
                , did.incident_category
                , did.incident_subcategory
                , did.incident_description
    )
    
    select * from incidents_monthly_agg