{{ config(materialized="table") }}

with

    source as (select * from {{ ref('stg_sfpd_incidents_all') }}),

    dim_incident_details as (
        select distinct
            incident_details_id,
            incident_code,
            incident_category,
            incident_subcategory,
            incident_description
        from source
    )

select *
from dim_incident_details
order by incident_category, incident_category, incident_description