{{
    config(
        materialized = "table"
    )
}}

{% set current_date = modules.datetime.datetime.now().strftime("%Y-%m-%d") %}

{{ dbt_date.get_date_dimension('2017-01-01', current_date) }}