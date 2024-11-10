import polars as pl
import datetime as dt
import pytz

from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_google_cloud_storage(df, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = kwargs['config_profile']

    est = pytz.timezone('US/Eastern')

    previous_date = dt.datetime.now(est) - dt.timedelta(kwargs['days_offset'])

    previous_date_formatted = previous_date.strftime('%Y-%m-%d')
    previous_date_year = previous_date.strftime('%Y')
    previous_date_month = previous_date.strftime('%m')

    bucket_name = kwargs['gcs_bucket']
    object_key = f'raw/daily_load/{previous_date_year}/{previous_date_month}/{previous_date_formatted}.parquet'
    

    GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        bucket_name,
        object_key,
        format='parquet',
    )
