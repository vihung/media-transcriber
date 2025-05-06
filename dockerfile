FROM ubuntu:22.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bc
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3.9
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-distutils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpeg

RUN pip install --upgrade pip openai-whisper

RUN mkdir /app && mkdir -p /root/media/inbox && mkdir -p /root/media/in-progress && mkdir -p /root/media/outbox

COPY ./generate-transcript.sh /app/generate-transcript.sh

WORKDIR /app
RUN chmod +x /app/generate-transcript.sh

CMD ["/app/generate-transcript.sh"]