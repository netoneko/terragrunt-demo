FROM alpine:3.18

RUN apk add --no-cache python3 py3-pip

ADD ./requirements.txt /opt/app/

WORKDIR /opt/app

RUN pip3 install -r requirements.txt

ADD . .

CMD flask run --host 0.0.0.0