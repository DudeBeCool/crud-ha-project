FROM python:3.6-slim-buster

RUN groupadd --gid 8877 crud && useradd --uid 8877 --gid 8877 -m crud

WORKDIR /home/crud

ENV PATH="/home/crud/.local/bin:${PATH}"

COPY --chown=crud:crud requirements.txt .

USER crud

RUN pip install -r requirements.txt

COPY --chown=crud:crud . .

EXPOSE 80

CMD ["flask", "run", "--host=0.0.0.0", "--port=8081"]
