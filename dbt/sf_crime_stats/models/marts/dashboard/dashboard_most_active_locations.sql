{{ config(materialized="table") }}

with most_active_analysis_neighborhood as (
    select
      'Neighborhood' as `Location Type`
      , dl.analysis_neighborhood as `Name`
      , count(*) as incident_count
    from {{ ref('fact_incidents') }} as fi
    left join {{ ref('dim_location') }} as dl
      on fi.location_fk = dl.location_id
    where dl.analysis_neighborhood is not null
    group by dl.analysis_neighborhood
    order by count(*) DESC
    limit 1
    ),
    
    most_active_police_district as (
      select
        'Police District' as `Location Type`
        , dl.police_district as `Name`
        , count(*) as incident_count
      from {{ ref('fact_incidents') }} as fi
      left join {{ ref('dim_location') }} as dl
        on fi.location_fk = dl.location_id
      where dl.police_district is not null
      group by dl.police_district
      order by count(*) DESC
      limit 1
      ),

  most_active_intersection as (
    select
      'Intersection' as `Location Type`
      , dl.intersection as `Name`
      , count(*) as incident_count
    from {{ ref('fact_incidents') }} as fi
    left join {{ ref('dim_location') }} as dl
      on fi.location_fk = dl.location_id
    where dl.intersection is not null
    group by dl.intersection
    order by count(*) DESC
    limit 1
    )
    
select * from most_active_analysis_neighborhood
union all
select * from most_active_police_district
union all
select * from most_active_intersection