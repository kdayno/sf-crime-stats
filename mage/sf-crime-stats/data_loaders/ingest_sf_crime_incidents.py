import io
import polars as pl
import requests
import datetime as dt

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test
    

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Ingest San Francisco Crime Incidents via a Public API endpoint
    """
  
    input_date = kwargs['input_date']
    days_offset = kwargs['days_offset']
    execution_date = kwargs['execution_date']

    # If no input_date is provided, set input_date as current date - 1 day
    # The data for the current date will only be available the next day. Data is always lagging by 1 day
    # It's also possible that yesterday's data is not immmediately available since the API is refreshed daily at 10 AM PST
    if input_date == 'YYYY-MM-DD':
        try:
            input_date = (execution_date - dt.timedelta(1))

        except ValueError as e:
            print("Input date INVALID. Provide date in the format 'YYYY-MM-DD'.", end='\n')
            raise e

    else:
        try:
            input_date = dt.datetime.strptime(input_date, '%Y-%m-%d')

        except ValueError as e:
                print("Input date INVALID. Provide date in the format 'YYYY-MM-DD'.", end='\n')
                raise e

    # Determine data from which DATE to load accounting for specified offset
    if days_offset > 0:
        date_of_data_to_load = (input_date - dt.timedelta(days_offset))
        date_of_data_to_load_formatted = date_of_data_to_load.strftime('%Y-%m-%dT00:00:00.000')

    else:
        date_of_data_to_load = input_date
        date_of_data_to_load_formatted = date_of_data_to_load.strftime('%Y-%m-%dT00:00:00.000')


    url = f"https://data.sfgov.org/resource/wg3w-h783.json?incident_date={date_of_data_to_load_formatted}"

    r = requests.get(url)

    try:
        df = pl.read_json(io.StringIO(r.text))
        
    except Exception as e:
        print(e)

    return (df, date_of_data_to_load)
