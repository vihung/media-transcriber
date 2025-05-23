#!/bin/bash

LANGUAGE=English
INPUT_DIR=/root/media/inbox
OUTPUT_DIR=/root/media/outbox
WORK_DIR=/root/media/in-progress

PERFORMANCE_LOG=${OUTPUT_DIR}/performance.csv

# Function to round the given number
round() {
    printf "%.0f\n" ${1}
}

# Function to format a number (in seconds) as 'HH:mm:ss'
format-time() {
    local seconds=$(round ${1})
    ((h=${seconds}/3600))
    ((m=(${seconds}%3600)/60))
    ((s=${seconds}%60))
    printf "%02d:%02d:%02d\n" $h $m $s
}

# If ${INPUT_DIR} has files
numFiles=$(ls -1q "${INPUT_DIR}/" | wc -l)
echo "Number of Files to Process: ${numFiles}"

if [ ${numFiles} -eq 0 ]; then
    echo "No files to process"
    exit 
fi

if [[ ! -f "${PERFORMANCE_LOG}" ]]; then
    echo "Start, End, Duration, Elapsed Seconds, Efficiency Factor" >> "${PERFORMANCE_LOG}"
fi

# Iterate through all media files in ${INPUT_DIR}
for sourceMediaFile in "${INPUT_DIR}"/*; do
    # For each source media file ${sourceMediaFile}
    # Copy source media file to working directory ${mediaFile}
    mediaFilename="$(basename "${sourceMediaFile}")"

    # Get the duration in seconds of the media file using ffprobe
    duration="$(round "$(ffprobe -show_entries format=duration -v quiet -of csv="p=0" -i "${sourceMediaFile}")")"
    echo
    echo "########################################"
    echo "# Processing ${mediaFilename}"
    echo "#"
    echo "# Duration: $(format-time ${duration})"
    echo "########################################"
    echo
    
    mediaFile="${WORK_DIR}/${mediaFilename}"
    cp -nv "${sourceMediaFile}" "${mediaFile}"

    # Run Whisper on the file ${mediaFile}
    startTime=$(date +%s.%N) # Start timestamp
    whisper --language ${LANGUAGE} --model medium --output_dir "${OUTPUT_DIR}" "${mediaFile}"
    endTime=$(date +%s.%N) # End timestamp

    # Calculate elapsed time in seconds
    elapsedSeconds=$(echo "$endTime - $startTime" | bc)
    
    efficiencyFactor=$(echo "scale=2; ${elapsedSeconds} / ${duration}" | bc)

    echo
    echo "########################################"
    echo "# Finished processing ${mediaFilename}"
    echo "#"
    echo "# Duration : $(format-time ${duration})"
    echo "# Elapsed  : $(format-time ${elapsedSeconds})" 
    echo "#"
    echo "# Efficiency Factor: ${efficiencyFactor}"
    echo "########################################"
    echo

    # Log stats to performance log
    echo "${startTime}, ${endTime}, ${duration}, ${elapsedSeconds}, ${efficiencyFactor}" >> "${PERFORMANCE_LOG}"

    # Delete the txt, tsv, and vtt, files in ${OUTPUT_DIR}
    rm -v "${OUTPUT_DIR}"/*.{txt,vtt,tsv}

    # Delete the working file ${mediaFile}
    rm -v "${mediaFile}"

    # Delete the source media file ${sourceMediaFile}
    rm -v "${sourceMediaFile}"
done
