{{
    config(
        materialized='view'
    )
}}

with

    source as (select * from {{ source("staging", "sfpd_incidents_all") }}),

    renamed as (

        select
            -- identifiers
            {{ dbt_utils.generate_surrogate_key(['row_id', 'incident_id']) }} as globally_unique_id,
            {{ dbt.safe_cast("row_id", api.Column.translate_type("integer")) }} as row_id,
            {{ dbt.safe_cast("incident_id", api.Column.translate_type("integer")) }} as incident_id,
            {{ dbt.safe_cast("incident_number", api.Column.translate_type("integer")) }} as incident_number,
            {{ dbt.safe_cast("cad_number", api.Column.translate_type("integer")) }} as cad_number, 

            -- date & timestamps
            {{ dbt.safe_cast("incident_datetime", api.Column.translate_type("datetime")) }} as incident_datetime,
            {{ dbt.safe_cast("incident_date", api.Column.translate_type("date")) }} as incident_date,
            incident_time,
            {{ dbt.safe_cast("incident_year", api.Column.translate_type("integer")) }} as incident_year,
            incident_day_of_week,
            {{ dbt.safe_cast("report_datetime", api.Column.translate_type("datetime")) }} as report_datetime,

            -- incident details
            incident_code,
            report_type_code,
            {{ get_report_type_code('report_type_description') }} as report_type_code_modified,
            report_type_description,
            incident_category,
            incident_subcategory,
            incident_description,
            resolution,
            intersection,
            cnn,
            police_district,
            analysis_neighborhood,
            supervisor_district,
            supervisor_district_2012,
            latitude,
            longitude

        from source

    )

select *
from renamed
 
-- dbt build --select <model_name> --vars '{'is_test_run':'false'}''
-- {% if var('is_test_run', default=true) %}

--     limit 100

-- {% endif %}