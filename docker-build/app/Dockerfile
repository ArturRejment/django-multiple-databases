FROM python:3.9

ENV PYTHONUNBUFFERED=1

WORKDIR /app/src
COPY requirements.txt ./
RUN pip install -r requirements.txt

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]