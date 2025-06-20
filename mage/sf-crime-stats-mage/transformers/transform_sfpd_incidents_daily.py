import polars as pl
from polars import col
from datetime import datetime

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(params, *args, **kwargs):
    """
    Select relevant cols and parse datetime columns
    """

    df = params[0].select(col('incident_date').str.to_date(format="%Y-%m-%dT%H:%M:%S%.3f")
                        , col('incident_datetime').str.strptime(pl.Datetime)
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
                        , pl.lit(datetime.now()).alias('load_date_ts')
                    )
    
    input_date = params[1]

    return (df, input_date)
