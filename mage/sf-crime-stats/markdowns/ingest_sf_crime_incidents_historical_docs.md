This pipeline ingests and loads historical San Francisco Crime Incidents reported by the San Francisco Police Department via the Public API. 
<br>

It should be triggered via the "loop_ingest_sf_crime_incidents_historical" pipeline to ingest and load ALL historical data currently available. 
<br><br>

**INPUT:**
- config_profile
- days_offset
- gcs_bucket
- iteration_num
- row_limit
- row_offset
<br><br>

**OUTPUT:**
- Loads specified number of rows with given row offset into a GCS Bucket
<br><br>