# Media Transcriber
Docker (Ubuntu + Shell Scripts) to transcribe media files

When running, the docker image will take any media files placed in `~/media/inbox` and using OpenAI Whisper will generate English transcripts and place them in `~/media/outbox`

To build and run the Docker image, run the `run.sh` shell script.

The logs are very chatty - not least because Whisper logs the transcript as it generatews. 

The script logs the total duration (length in time) of the media file before transcribing, and the time elapsed after the transcript has been generated.