with 

source as (

    select * from {{ source('staging', 'sfpd_incidents_all') }}

),

renamed as (

    select
        incident_datetime,
        incident_date,
        incident_time,
        incident_year,
        incident_day_of_week,
        report_datetime,
        row_id,
        incident_id,
        incident_number,
        cad_number,
        report_type_code,
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

select * from renamed
