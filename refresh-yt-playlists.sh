#!/bin/bash

URLS=$(cat <<-END
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KUE01LI5fMuGYHBMJWTNNUZ	Cooking
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KXiffmcUICeCCUkEr-bos6I	General Interest
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KVGzFirJnBTdMyoLqBAPHjA	Skiing
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KVop81mnGULKY92v8Spkylc	My Vlogs
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KXWAjIwF3wfmNn2gE4yuUpR	Boating
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KVvL8umxAyu1aZ-gK9271ZG	Audio Video Editing
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KViMurYp1X27kofJFt7OiRm	HFLC
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KX4qVmJDK2id-N0MUKZ2HHG	Awesome Legacy matches
	https://www.youtube.com/playlist?list=PLVGhAh2ZX6KXEj_Rord79HqGrSueuDF0X	Miracles matches
	https://www.youtube.com/playlist?list=PL2000739371AF94AF			Int Dutch Music
	https://www.youtube.com/playlist?list=FLonxQhPSJ9iwQ5AqFo1ZXyA			Favorites
END
)

for URL in $URLS
do
	if [[ $URL == https* ]]
	then
		echo $URL
		youtube-dl --download-archive /home/ojilles/youtube-dl/youtube.archive \
		 -f best \
		 --write-info-json --write-thumbnail --ignore-errors \
		 -o '%(playlist_title)s/%(title)s.%(ext)s' \
		 "$URL"
	fi
done
