{{ config(materialized="view") }}

with

    source as (select * from {{ source("staging", "sfpd_incidents_all") }}),

    subset as (
        select distinct report_type_code, report_type_description from source
    ),

    dim_report_details as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    ["report_type_code", "report_type_description"]
                )
            }} as report_details_id, *
        from subset
    )

select *
from dim_report_details
