#!/bin/bash

if [ -z ${SERVER_TYPE+x} ]; then
  echo "SERVER_TYPE is unset, please set it with a value among [fastapi, flask, sanic]."
  exit 1
fi

if [ -z ${FRAMEWORK_TYPE+x} ]; then
  echo "FRAMEWORK_TYPE is unset."
  exit 1
fi

if [ ${SERVER_TYPE} == "fastapi" ]; then
  uvicorn src.server_fastapi.app_${FRAMEWORK_TYPE}:app --workers ${NUM_WORKERS} --host 0.0.0.0 --port ${PORT}
elif [ ${SERVER_TYPE} == "flask" ]; then
  uwsgi -w src.server_flask.app_${FRAMEWORK_TYPE}:app -p ${NUM_WORKERS} --protocol http --socket 0.0.0.0:${PORT}
elif [ ${SERVER_TYPE} == "sanic" ]; then
  python -m src.server_sanic.app_${FRAMEWORK_TYPE} --workers ${NUM_WORKERS} --host 0.0.0.0 --port ${PORT}
else
  echo "Please choose SERVER_TYPE among [fastapi, flask, sanic]"
  exit 1
fi