{{ config(materialized="table") }}

with
    incidents as (select * from {{ ref('fact_incidents') }}),

    incident_details as (select * from {{ ref('dim_incident_details') }}),

    incidents_subset as (
        select 
            inc.*
            , incd.incident_code
            , incd.incident_category
            , incd.incident_subcategory
            , incd.incident_description 
        from incidents inc
        join incident_details incd
        on inc.incident_details_fk = incd.incident_details_id
        where inc.latitude is not null 
            and inc.longitude is not null
            and incd.incident_category is not null
            and incd.incident_subcategory is not null
    )

    select * from incidents_subset
