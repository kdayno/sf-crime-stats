from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(df: DataFrame, **kwargs) -> None:
    """
    Load transformed SFPD incident data into BigQuery
    """

    bq_dataset_name = kwargs['bq_dataset']
    gcp_project_id = kwargs['gcp_project_id']

    table_id = f'{gcp_project_id}.{bq_dataset_name}.sfpd_incidents_all'
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = kwargs['config_profile']


    BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        table_id,
        if_exists='append',  # Specify resolution policy if table name already exists
    )
