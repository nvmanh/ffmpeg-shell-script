#!/bin/sh

# Need at least an outfile and two images for this command to make sense.
if [ $# -lt 3 ]
then
	echo USAGE: "$0" OUTFILE IMAGES...
	echo Create simple slideshow video with blend effect between images.
	echo
	echo OUTFILE is video file to create, .mkv extension is recommended.
	echo IMAGES is a sequence of images for the slideshow.
	exit
fi

# 30 fps, so this means each original image corresponds to one second of video.
frames_per_image=60
fps=30

out="$1"
shift

# Create a temporary directory to store the frames in.
dir=$(mktemp -d)

# Iterate through the images keeping track of the previous one to be blended
#  with the current one.
num=0   # frame number
prev='' # previous image or empty string if none
for image in "$@"
# files=`ls *.jpg|awk -F"/" '{print $NF}'`
# for image in "$files"
do

	# If there is a previous image, blend with it.
	if [ -f "$prev" ]
	then
		for fade_amount in $(seq 1 $((frames_per_image - 1)))
		do
			# Use bc for math to get decimals.
			composite -blend "$(echo "$fade_amount/$frames_per_image*100" | bc -lq)" "$image" "$prev" "$dir/image$num"".png"
			num=$((num + 1))
		done
	fi
	# Always in include the actual image as one of the frames.
	# Use convert so any image format will work.
	convert "$image" "$dir/image${num}.png"
	num=$((num + 1))
	# Remember this image for the next iteration.
	prev="$image"
done

# Encode the video from the frames.
# -pix_fmt yuv420p is normal pixel format, but default is yuv444p which
#  ffmpeg warns might not be supported by all players.
ffmpeg -loop 1 -f image2 -i "$dir/image%d.png" -i "hello.mp3"  -safe 0 -c:v libx264 -pix_fmt yuv420p -c:a copy -shortest "$out"
# Delete the temporary directory with the frames.
rm -rf "$dir"

# ./blend.sh a.mkv 5.jpg 6.jpg 7.jpg 8.jpg 9.jpg 11.jpg 12.jpg 13.jpg 14.jpg 15.jpg 16.jpg 17.jpg 18.jpg 19.jpg 20.jpg