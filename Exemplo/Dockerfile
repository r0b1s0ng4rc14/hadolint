FROM python

WORKDIR /app
COPY ./src/* /app

RUN apt-get update
RUN pip install -r requirements.txt

CMD python3 main.py