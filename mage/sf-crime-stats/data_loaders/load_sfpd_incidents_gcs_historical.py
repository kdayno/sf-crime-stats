from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from os import path
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

import pyarrow as pa
import pyarrow.parquet as pq
import os

@data_loader
def load_from_google_cloud_storage(*args, **kwargs):
    """
    Template for loading data from a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = kwargs['config_profile']

    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/home/src/secrets/gcp_credentials.json'

    bucket_name = kwargs['gcs_bucket']


    object_key = f'{bucket_name}/raw/historical_load/'

    gcs = pa.fs.GcsFileSystem()

    df = pq.read_table(
        source=object_key,
        filesystem=gcs,
        )

    df = df.to_pandas()

    return df
