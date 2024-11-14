{# Returns the description of the report type code #}

{% macro get_report_type_code(report_type_description) -%}

    CASE
        WHEN report_type_description = 'Initial' THEN 'II'
        WHEN report_type_description = 'Initial Supplement' THEN 'IS'
        WHEN report_type_description = 'Vehicle Supplement' THEN 'VS'
        WHEN report_type_description = 'Coplogic Initial' THEN 'CI'
        WHEN report_type_description = 'Coplogic Supplement' THEN 'CS'
        WHEN report_type_description = 'Vehicle Initial' THEN 'VI'
    ELSE NULL
    END

{%- endmacro %}