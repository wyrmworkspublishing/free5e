FROM blalasaadri/free5e-conversion-base:latest

WORKDIR /free5e

COPY convert.sh convert.sh
COPY conversion-scripts conversion-scripts

WORKDIR /free5e/data

ENTRYPOINT [ "/free5e/convert.sh" ]
