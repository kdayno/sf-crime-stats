import datetime as dt

from mage_ai.orchestration.triggers.api import trigger_pipeline
if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

@data_exporter
def trigger(params, *args, **kwargs):
    """
    Trigger the "etl_gcs_to_bigquery" pipeline to extract, transform, and load the ingested data from a GCS Bucket to Big Query
    """

    trigger_pipeline(
        'etl_gcs_to_bigquery', # Required: enter the UUID of the pipeline to trigger
        variables={'source_path':params[0], # Optional: runtime variables for the pipeline
                    'input_date':params[1].strftime('%Y-%m-%d')},
        check_status=True,     # Optional: poll and check the status of the triggered pipeline
        error_on_failure=True, # Optional: if triggered pipeline fails, raise an exception
        poll_interval=60,      # Optional: check the status of triggered pipeline every N seconds
        poll_timeout=None,     # Optional: raise an exception after N seconds
        verbose=True,          # Optional: print status of triggered pipeline run
        schedule_name="etl_gcs_to_bigquery_block_api_trigger"
    )
