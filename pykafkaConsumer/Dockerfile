FROM python:3

WORKDIR /usr/src/app
COPY . .
RUN pip install -r requirements.txt

USER 1002:1002

CMD ["consumer.py"]
ENTRYPOINT ["python3"]

