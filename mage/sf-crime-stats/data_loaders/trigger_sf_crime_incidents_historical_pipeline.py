import requests
import ast
import math
import polars as pl
import io

from mage_ai.orchestration.triggers.api import trigger_pipeline
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader


@data_loader
def trigger(*args, **kwargs):
    """
    Initiates the loop that triggers the "ingest_sf_crime_incidents_historical" N times
    """

    url = f"https://data.sfgov.org/resource/wg3w-h783.json?$select=count(row_id)"

    r = requests.get(url)

    count_val = ast.literal_eval(r.text)[0]['count_row_id']
    count_val = int(count_val)
    print('Total record count: ', count_val)

    row_limit = kwargs['row_limit']
    row_offset = 0

    iteration_num = math.ceil(count_val / row_limit) # Calculates num of iterations to run 'ingest_sf_crime_incidents_historical' pipeline

    for iteration in range(1, iteration_num+1):
        print('Processing iteration: ', iteration) 
        print('Row offset for current run: ', row_offset)

        trigger_pipeline(
            'ingest_sf_crime_incidents_historical',        # Required: enter the UUID of the pipeline to trigger
            variables={'row_limit': row_limit, 'row_offset': row_offset, 'iteration_num': iteration},           # Optional: runtime variables for the pipeline
            check_status=True,     # Optional: poll and check the status of the triggered pipeline
            error_on_failure=True, # Optional: if triggered pipeline fails, raise an exception
            poll_interval=60,       # Optional: check the status of triggered pipeline every N seconds
            poll_timeout=None,      # Optional: raise an exception after N seconds
            verbose=True,           # Optional: print status of triggered pipeline run
            schedule_name="looped_block_api_trigger"
        )

        row_offset = row_offset + 100000
