{{ config(materialized="table") }}

with
    source as (select * from {{ source("staging", "sfpd_incidents_all") }}),

    subset as (
        select
            incident_id,
            incident_date as incident_date_fk,
            report_date as report_date_fk,
            incident_details_id as incident_details_fk,
            report_details_id as report_details_fk,
            location_id as location_fk,
            latitude,
            longitude
        from source
    ),

    dim_incident_details as (select * from {{ ref("dim_incident_details") }}),

    dim_report_details as (select * from {{ ref("dim_report_details") }}),

    dim_incident_date as (select * from {{ ref("dim_incident_date") }}),

    dim_report_date as (select * from {{ ref("dim_report_date") }}),

    dim_location as (select * from {{ ref("dim_location") }}),

    fact_incidents as (
        select fct_i.*
        from subset fct_i
        inner join dim_incident_details dim_id on  fct_i.incident_details_fk = dim_id.incident_details_id
        inner join dim_report_details dim_rd on  fct_i.report_details_fk = dim_rd.report_details_id
        inner join dim_incident_date dim_idate on  fct_i.incident_date = dim_idate.incident_date_fk
        inner join dim_report_date dim_rdate on  fct_i.report_date_fk = dim_rdate.report_date
        inner join dim_location dim_l on  fct_i.location_fk = dim_l.location_id
    )

    select * from fact_incidents

