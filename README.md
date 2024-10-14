# Media Transcriber
## Docker (Ubuntu + Shell Scripts) to transcribe media files

When running, the docker image will take any media files placed in `~/media/inbox` (on the host) and using OpenAI Whisper will generate English transcripts and place them in `~/media/outbox` (on the host)

To build and run the Docker image, run the `[run.sh]` shell script.

The logs are very chatty - not least because Whisper logs the transcript as it generates. 

The script logs the total duration (length in time) of the media file before transcribing, and the time elapsed after the transcript has been generated.

In my experience, the image uses about 6GB of RAM when running

Files:
- [dockerfile](./dockerfile) defines the Docker image.
- [docker-compose.yml](./docker-compose.yml) uses the docker image and maps local directories (inbox and outbox) to directories in the image.
- [generate-transcript.sh](./generate-transcript.sh) does the media processing.
