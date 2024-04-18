FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --upgrade pip

RUN pip install --no-cache-dir Flask gunicorn

EXPOSE 5000

CMD ["sh", "-c", "cd app && gunicorn --log-level debug api:app"]