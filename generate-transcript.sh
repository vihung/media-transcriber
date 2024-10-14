#!/bin/bash

LANGUAGE=English
INPUT_DIR=/root/media/inbox
OUTPUT_DIR=/root/media/outbox
WORK_DIR=/root/media/in-progress

round() {
    printf "%.0f\n" ${1}
}

format-time() {
    num=$(round ${1})
    ((h=${num}/3600))
    ((m=(${num}%3600)/60))
    ((s=${num}%60))
    printf "%02d:%02d:%02d\n" $h $m $s
}

# If ${INPUT_DIR} has files
numFiles=$(ls -1q "${INPUT_DIR}/" | wc -l)
echo "Number of Files to Process: ${numFiles}"

if [ ${numFiles} -gt 0 ]; then
    # Iterate through all media files in ${INPUT_DIR}
    for sourceMediaFile in "${INPUT_DIR}"/*; do
        # For each source media file ${sourceMediaFile}
        # Copy source media file to working directory ${mediaFile}
        mediaFilename="$(basename "${sourceMediaFile}")"

        duration="$(round "$(ffprobe -show_entries format=duration -v quiet -of csv="p=0" -i "${sourceMediaFile}")")"
        echo "########################################"
        echo "# Processing ${mediaFilename}"
        echo "# Duration $(format-time ${duration})"
        echo "########################################"
        
        mediaFile="${WORK_DIR}/${mediaFilename}"
        cp -nv "${sourceMediaFile}" "${mediaFile}"

        # Run Whisper on the file ${mediaFile}
        time whisper --language ${LANGUAGE} --model medium --output_dir "${OUTPUT_DIR}" "${mediaFile}"

        echo "########################################"
        echo "# Finished processing ${mediaFilename}"
        echo "########################################"

        # Delete the txt, tsv, and vtt, files in ${OUTPUT_DIR}
        rm -v "${OUTPUT_DIR}"/*.{txt,vtt,tsv}

        # Delete the working file ${mediaFile}
        echo "Deleting working file"
        rm -v "${mediaFile}"

        # Delete the source media file ${sourceMediaFile}
        echo "Deleting source media file"
        rm -v "${sourceMediaFile}"
    done
else
    echo "No files to process"
    exit 
fi
