# Start from the mageai base image
FROM mageai/mageai:latest

# Set build-time arguments
ARG PROJECT_NAME=mage/sf-crime-stats-mage
ARG MAGE_CODE_PATH=/home
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

WORKDIR ${MAGE_CODE_PATH}

# Copy Mage project
COPY ${PROJECT_NAME} ${PROJECT_NAME}
# Copy dbt project
COPY ./dbt/sf_crime_stats ${MAGE_CODE_PATH}

RUN mkdir -p ${USER_CODE_PATH}/secrets

ENV USER_CODE_PATH=${USER_CODE_PATH}

CMD ["/bin/sh", "-c", "/app/run_app.sh"]