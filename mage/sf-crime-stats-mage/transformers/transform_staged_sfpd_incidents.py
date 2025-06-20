if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(df, *args, **kwargs):
    """
    Standardize column names
    """
    
    df.columns = (df.columns
                        .str.replace(' ', '_')
                        .str.lower()
    )

    return df
