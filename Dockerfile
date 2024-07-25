FROM python:3.9.19

WORKDIR /app
COPY ./src/* /app

RUN apt-get update \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& pip install --no-cache-dir -r requirements.txt

CMD [ "python3","main.py" ] 