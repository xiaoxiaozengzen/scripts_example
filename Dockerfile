FROM python:3.8

RUN mkdir -p /app
WORKDIR /app
RUN pip install flask
ADD app.py .
