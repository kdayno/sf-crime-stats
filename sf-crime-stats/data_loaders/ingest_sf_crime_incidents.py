import io
import polars as pl
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Ingest San Francisco Police Department Incidents from API endpoint
    """

    url = "https://data.sfgov.org/resource/wg3w-h783.json"

    r = requests.get(url)

    df = pl.read_json(io.StringIO(r.text))

    return df


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'