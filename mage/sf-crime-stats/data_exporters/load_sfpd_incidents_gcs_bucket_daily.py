import polars as pl
import datetime as dt

from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_google_cloud_storage(params, **kwargs) -> None:
    """
    Load extracted SFPD incident data into a GCS bucket
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = kwargs['config_profile']

    df = params[0]
    date_of_data_to_load = params[1]

    date_formatted = date_of_data_to_load.strftime('%Y-%m-%d ')
    date_year = date_of_data_to_load.strftime('%Y')
    date_month = date_of_data_to_load.strftime('%m')

    bucket_name = kwargs['gcs_bucket']
    object_key = f'raw/daily_load/{date_year}/{date_month}/{date_formatted}.parquet'
    
    GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        bucket_name,
        object_key,
        format='parquet',
    )

    bq_if_table_exists = 'append'

    return (object_key, bq_if_table_exists)