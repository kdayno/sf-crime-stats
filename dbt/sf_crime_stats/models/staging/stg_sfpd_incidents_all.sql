{{
    config(
        materialized='view'
    )
}}

with

    source as (select * from {{ source("staging", "sfpd_incidents_all") }}),

    renamed as (

        select
            {{ dbt_utils.generate_surrogate_key(['row_id', 'incident_id']) }} as globally_unique_id,
            row_id,
            incident_id,
            incident_datetime,
            incident_date,
            incident_time,
            incident_year,
            incident_day_of_week,
            report_datetime,
            incident_number,
            cad_number,
            report_type_code,
            {{ get_report_type_code('report_type_description') }} as report_type_code_modified,
            report_type_description,
            incident_code,
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