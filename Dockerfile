FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir Flask gunicorn

RUN pip install -r ./app/requirements.txt

ENV GUNICORN_CMD_ARGS="--bind=0.0.0.0:8000"

EXPOSE 8000

CMD ["sh", "-c", "cd app && gunicorn --log-level debug api:app"]