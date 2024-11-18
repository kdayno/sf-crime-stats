{{ config(materialized="view") }}
with dim_report_date as (select date_day as report_date_id, * from {{ ref("dates") }})

select *
from dim_report_date
