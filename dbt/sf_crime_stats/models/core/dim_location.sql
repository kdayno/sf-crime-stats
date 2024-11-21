{{ config(materialized="table") }}

with

    source as (select * from {{ ref('stg_sfpd_incidents_all') }}),

    dim_location as (
        select distinct
            location_id, cnn, intersection, police_district, analysis_neighborhood
        from source
    )

select *
from dim_location
