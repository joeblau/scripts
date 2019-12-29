#!/bin/bash

USAGE_ERROR="Usage: ${0##*/} -i <input-folder> -o <output-folder> -e {video-extension}"
FFMPEG_ERROR="Error: ffmpeg is not installed. Fix: \033[1mbrew install ffmpeg\033[0m"

# Check dependencies
if ! [ -x "$(command -v ffmpeg)" ]; then
  echo -e $FFMPEG_ERROR >&2
  exit 1
fi

# Parse arguments
while getopts ":i:o:e:" arg; do
  case $arg in
    i) input=$OPTARG;;
    o) output=$OPTARG;;
    e) extension=$OPTARG;;
  esac
done

# Validate input
input_directory=""
output_directory=""
case $input in
  "")
    echo $USAGE_ERROR
    exit 1
    ;;
  *)
    input_directory="$(pwd)/${input}"
    if [ ! -d "${input_directory}" ] 
    then
        echo "Directory DOES NOT exist: ${input_directory}" 
        exit 1 
    fi    
    ;;
esac

case $output in
  "")
    echo $USAGE_ERROR
    exit 1
    ;;
  *)
    output_directory="$(pwd)/${output}"
    if [ ! -d "${output_directory}" ] 
    then
        echo "Directory DOES NOT exist:  ${output_directory}" 
        exit 1 
    fi    
    ;;
esac

case $extension in
  "")
    echo $USAGE_ERROR
    exit 1
    ;;
esac

# Convert video in input directory to jpg in output directory
for file in ${input_directory}/*.${extension}; do
    input_directory_length=`expr ${#input_directory} + 1`
    file_name_length=`expr ${#file} - ${input_directory_length} - ${#extension} - 1`
    video_root="${file:${input_directory_length}:${file_name_length}}"
    ffmpeg -i "$file" "${output_directory}/${video_root}-image-%d.jpg"
done
