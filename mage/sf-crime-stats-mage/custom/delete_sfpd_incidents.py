from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from os import path

@custom
def delete_data_from_bigquery(df, **kwargs):
    """
    Delete SFPD incident data for given input_date from BigQuery to ensure idempotency
    """

    config_profile = kwargs['config_profile']
    bq_dataset_name = kwargs['bq_dataset']
    gcp_project_id = kwargs['gcp_project_id']
    bq_dataset = kwargs['bq_dataset']
    input_date = kwargs['input_date']

    query = f"""DELETE FROM `{gcp_project_id}.{bq_dataset}.sfpd_incidents_all` WHERE incident_date = '{input_date}'"""

    config_path = path.join(get_repo_path(), 'io_config.yaml')

    BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).execute(query)

    return df