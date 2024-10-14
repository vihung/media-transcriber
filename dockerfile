FROM ubuntu:22.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3.9
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-distutils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpeg
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ffprobe

RUN pip install --upgrade pip
RUN pip install -U openai-whisper

RUN mkdir /app
RUN mkdir -p /root/media/inbox
RUN mkdir -p /root/media/in-progress
RUN mkdir -p /root/media/outbox

COPY ./generate-transcript.sh /app/generate-transcript.sh

WORKDIR /app
RUN chmod +x /app/generate-transcript.sh

CMD ["/app/generate-transcript.sh"]