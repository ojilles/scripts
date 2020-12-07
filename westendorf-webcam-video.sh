#! /bin/bash

PIC_DIR=/home/ojilles/westendorf-webcam/pics
NAS_DIR=/nas/Media/Youtube-Archive/Westendorf-Webcams/

for CAM in $(cd $PIC_DIR && ls -d */ | cut -f1 -d'/')
do
	echo $CAM
	cd "$PIC_DIR/$CAM"
	ffmpeg -framerate 4/1 -y -f image2 -pattern_type glob -i '*.jpg' -r 25 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" $PIC_DIR/video-$CAM.mp4
	## -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"   --> deals with odd number of source pixels, per:
	## https://stackoverflow.com/questions/20847674/ffmpeg-libx264-height-not-divisible-by-2/20848224#20848224
done

if [ -d "$NAS_DIR" ]
then
	echo `date` copying files over to nas
	cp -f $PIC_DIR/*.mp4 $NAS_DIR
else
	echo "Error: Directory $NAS_DIR does not exists."
fi
