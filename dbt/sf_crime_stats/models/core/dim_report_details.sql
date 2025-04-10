{{ config(materialized="table") }}

with

    source as (select * from {{ ref('stg_sfpd_incidents_all') }}),

    dim_report_details as (
        select distinct report_details_id, report_type_code, report_type_description
        from source
    )

select *
from dim_report_details
