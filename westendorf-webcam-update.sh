#! /bin/bash

CAMS=$(cat <<-END
	Talkaser|https://www.bergfex.com/westendorf/webcams/c110/?archive=1
	Choralpe|https://www.bergfex.com/westendorf/webcams/c5204/?archive=1
	Fleiding|https://www.bergfex.com/westendorf/webcams/c17978/?archive=1
	Panorama|https://www.bergfex.com/westendorf/webcams/c14529/?archive=1
	AptAnita|https://www.bergfex.com/westendorf/webcams/c15479/?archive=1
END
)

CURRENTDAY="date=`date +%F`"

URLTPL='https://images.bergfex.at/ajax/webcamsarchive/?id=YYY123YYY&XXX123XXX&size=6'
ARCHIVEURL='https://www.bergfex.com/westendorf/webcams/c15479/?archive=1'
PIC_DIR=pics
DAYS=

for CAM in $CAMS
do
	## thank goodness for stackoverflow.
	## https://stackoverflow.com/questions/10520623/how-to-split-one-string-into-multiple-variables-in-bash-shell/10520718#10520718
	NAME=${CAM%|*}
	ARCHIVEURL=${CAM#*|}
	CAMID=$(echo "$ARCHIVEURL" | grep -o 'c[0-9]\+' | sed 's/c//g')
	if [ $# -eq 0 ]
	  then
	    DAYS=$CURRENTDAY
	  else
	    DAYS=$(curl -s "$ARCHIVEURL" | grep Tagesa | grep date | grep -o 'date=[0-9\-]*')
	fi

	for DAY in $DAYS
	do
		TMP=${URLTPL//XXX123XXX/$DAY}
		DAYURL=${TMP//YYY123YYY/$CAMID}
		PIC_URL=$(curl -s $DAYURL| jq -r '.[] | select(.hour==12) .src' | head -n 1)
		if [ ${#PIC_URL} -gt 1 ]
		then
			echo "CamId: $CAMID	Camera: $NAME Days: $DAY PicUrl: $PIC_URL DayUrl: $DAYURL Url: $ARCHIVEURL"
			$(cd $PIC_DIR/$NAME && wget -nv -nc $PIC_URL)
		else
			echo "CamId: $CAMID	Camera: $NAME Days: $DAY SKIPPING (runnning before noon)"
		fi
	done
done

## Make video with:
## ffmpeg -framerate 4/1 -f image2 -pattern_type glob -i '*.jpg' -r 25 video.mp4
