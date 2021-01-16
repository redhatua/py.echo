FROM python:3.8-alpine

WORKDIR /app
COPY main.py .

EXPOSE 8080

CMD ["python", "main.py"]
