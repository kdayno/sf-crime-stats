{{ config(materialized="table") }}

with

    source as (select * from {{ source("staging", "sfpd_incidents_all") }}),

    dim_report_details as (
        select distinct report_details_id, eport_type_code, report_type_description
        from source
    )

select *
from dim_report_details
