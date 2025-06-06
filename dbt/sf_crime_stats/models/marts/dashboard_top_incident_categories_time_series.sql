{{ config(materialized="table") }}

with incidents_agg as (
  select
    incident_date_fk as incident_date
    , coalesce(did.incident_category, 'None') as incident_category
    , coalesce(did.incident_subcategory, 'None') as incident_subcategory
    , coalesce(did.incident_description, 'None') as incident_description
    , count(fi.incident_id) as incident_count
  from {{ ref('fact_incidents') }} as fi
  left join {{ ref('dim_incident_details') }} as did
    on fi.incident_details_fk = did.incident_details_id
  group by incident_date_fk, incident_category, incident_subcategory, incident_description
  ),
  
  incidents_agg_totals as (
    select 
      *
      , sum(incident_count) over (partition by incident_category, incident_subcategory) as incident_subcategory_total
    from incidents_agg
  ),
  
  incidents_agg_totals_ranked as (
    select 
      *
      , dense_rank() over (order by incident_subcategory_total desc) as incident_category_rank
    from incidents_agg_totals
    order by incident_date, incident_category_rank
  )
  
  select * from incidents_agg_totals_ranked
