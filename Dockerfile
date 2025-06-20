FROM mageai/mageai:0.9.76

# Set build-time arguments
ARG PROJECT_NAME=mage/sf-crime-stats-mage
ARG MAGE_CODE_PATH=/home
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

WORKDIR ${MAGE_CODE_PATH}

# Copy Mage project
COPY ${PROJECT_NAME} ${PROJECT_NAME}
# Copy dbt project - required at both locations below
COPY ./dbt ${PROJECT_NAME}/dbt/sf-crime-stats-dbt 
COPY ./dbt/sf_crime_stats ${MAGE_CODE_PATH}

ENV USER_CODE_PATH=${USER_CODE_PATH}

CMD ["/bin/sh", "-c", "/app/run_app.sh"]