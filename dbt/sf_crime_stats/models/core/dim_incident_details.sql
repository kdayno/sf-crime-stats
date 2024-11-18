{{ config(materialized="view") }}

with

    source as (select * from {{ source("staging", "sfpd_incidents_all") }}),

    subset as (
        select distinct
            incident_code, incident_category, incident_subcategory, incident_description
        from source
    ),

    dim_incident_details as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "incident_code",
                        "incident_category",
                        "incident_subcategory",
                        "incident_description",
                    ]
                )
            }} as incident_details_id, *
        from subset
    )

select *
from dim_incident_details
