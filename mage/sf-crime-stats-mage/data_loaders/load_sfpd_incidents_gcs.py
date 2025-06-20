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
import yaml

@data_loader
def load_from_google_cloud_storage(*args, **kwargs):
    """
    Extract SFDP incident data from GCS bucket
    """
    
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = kwargs['config_profile']

    with open(config_path, 'r') as f:
        io_config = yaml.safe_load(f)

    gcp_credentials_path = io_config.get(config_profile).get('GOOGLE_SERVICE_ACC_KEY_FILEPATH')

    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = gcp_credentials_path

    bucket_name = kwargs['gcs_bucket']
    source_path = kwargs['source_path']

    object_key = f'{bucket_name}/{source_path}'

    gcs = pa.fs.GcsFileSystem()

    df = pq.read_table(
        source=object_key,
        filesystem=gcs,
        )

    df = df.to_pandas()

    return df
