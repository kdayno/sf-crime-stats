{{ config(materialized="view") }}
with
    dim_incident_date as (
        select date_day as incident_date_id, * from {{ ref("dates") }}
    )

select *
from dim_incident_date
