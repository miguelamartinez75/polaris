FROM python:3.9.5-alpine3.13
LABEL maintainer="tierradelfuego.gob.ar"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app
COPY ./scripts /scripts

WORKDIR /app
EXPOSE 8000

RUN python3 -m venv /py
RUN /py/bin/pip install --upgrade pip
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-deps build-base postgresql-dev musl-dev linux-headers
RUN /py/bin/pip install -r /requirements.txt
RUN apk del .tmp-deps
RUN adduser --disabled-password --no-create-home app
RUN mkdir -p /vol/web/static
RUN mkdir -p /vol/web/media
RUN chown -R app:app /vol
RUN chmod -R 755 /vol
RUN chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER app

CMD [ "run.sh" ]