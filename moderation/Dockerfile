FROM python:3.11-slim-buster

WORKDIR /app

COPY moderation/requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY moderation/app.py app.py

CMD ["python", "app.py"]