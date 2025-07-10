FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y asciidoctor bash nodejs npm pandoc tree
RUN gem install asciidoctor-pdf asciidoctor-epub3 asciidoctor-reducer asciimath kramdown-asciidoc
RUN npm i --global downdoc

COPY generate.sh /generate.sh

ENTRYPOINT [ "/generate.sh" ]