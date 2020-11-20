#!/bin/bash

DEST=/nas/Media/Youtube-Archive

URLS=$(cat <<-END
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KViMurYp1X27kofJFt7OiRm	HFLC
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KX4qVmJDK2id-N0MUKZ2HHG	Awesome Legacy matches
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KXEj_Rord79HqGrSueuDF0X	Miracles matches
	https://www.youtube.com/playlist?list=PL2000739371AF94AF			Int Dutch Music
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KUE01LI5fMuGYHBMJWTNNUZ	Cooking
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KXiffmcUICeCCUkEr-bos6I	General Interest
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KVGzFirJnBTdMyoLqBAPHjA	Skiing
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KVop81mnGULKY92v8Spkylc	My Vlogs
        https://www.youtube.com/playlist?list=PLVGhAh2ZX6KXWAjIwF3wfmNn2gE4yuUpR	Boating
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KVvL8umxAyu1aZ-gK9271ZG	Audio Video Editing
	https://www.youtube.com/playlist?list=FLonxQhPSJ9iwQ5AqFo1ZXyA			Favorites
END
)

for URL in $URLS
do
	if [[ $URL == https* ]]
	then
		./youtube-dl --download-archive "$DEST"/youtube.archive \
		 -f best \
		 --ignore-errors \
		 --no-call-home \
		 -q \
		 --restrict-filenames \
		 --cookies ./cookies.txt \
		 -o "$DEST"'/%(playlist_title)s/%(upload_date)s-%(id)s-%(title)s.%(ext)s' \
		 "$URL"
	fi
done

echo
echo '********************************************************************************'
echo Summary at `date`
echo Items in the archive: 		`wc -l "$DEST"/youtube.archive`
echo Items on disk: 			`ls -lR $DEST | grep "^-" | wc -l`
echo Size and last changed file:	`du -h  $DEST -s --time`
echo Last three:
find $DEST -type f -exec stat -c '%Y %n' {} \; | sort -nr | awk 'NR==1,NR==4 {print $2}' | tail -n 3
