import io
import polars as pl
import requests
import datetime as dt
import pytz

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test
    

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Ingest San Francisco Crime Incidents via a Public API endpoint
    """

    est = pytz.timezone('US/Eastern')
  
    previous_date = (dt.datetime.now(est) - dt.timedelta(kwargs['days_offset'])).strftime('%Y-%m-%dT00:00:00.000')
    print(previous_date)

    url = f"https://data.sfgov.org/resource/wg3w-h783.json?incident_date={previous_date}"

    r = requests.get(url)

    try:
        df = pl.read_json(io.StringIO(r.text))
        
    except Exception as e:
        print(e)

    return df


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'