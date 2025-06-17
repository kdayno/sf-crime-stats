import polars as pl
from polars import col

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@transformer
def transform(df, *args, **kwargs):
    """
    Select relevant cols and parse datetime columns
    """

    df = df.select(col('incident_datetime').str.strptime(pl.Datetime)
                        , col('incident_date').str.strptime(pl.Datetime)
                        , 'incident_time'
                        , col('incident_year').cast(pl.Int64)
                        , 'incident_day_of_week'
                        , col('report_datetime').str.strptime(pl.Datetime)
                        , 'row_id'
                        , 'incident_id'
                        , 'incident_number'
                        , 'cad_number'
                        , 'report_type_code'
                        , 'report_type_description'
                        , 'incident_code'
                        , 'incident_category'
                        , 'incident_subcategory'
                        , 'incident_description'
                        , 'resolution'
                        , 'intersection'
                        , 'cnn'
                        , 'police_district'
                        , 'analysis_neighborhood'
                        , 'supervisor_district'
                        , 'supervisor_district_2012'
                        , 'latitude'
                        , 'longitude'
                    )

    return df
