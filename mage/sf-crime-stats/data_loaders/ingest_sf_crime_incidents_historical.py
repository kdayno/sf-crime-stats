import io
import polars as pl
import requests
import ast

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test
    

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Ingest San Francisco Police Department Incidents from API endpoint
    """

    row_limit = kwargs['row_limit']
    row_offset = kwargs['row_offset']

    url = f"https://data.sfgov.org/resource/wg3w-h783.json?$limit={row_limit}&$offset={row_offset}"

    r = requests.get(url)

    try:
        df = pl.read_json(io.StringIO(r.text))
        
    except Exception as e:
        print(e)

    return (df, row_limit, row_offset)


# @test
# def test_output(output, *args) -> None:
#     """
#     Template code for testing the output of the block.
#     """
#     assert output is not None, 'The output is undefined'