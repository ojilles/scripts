#! /bin/bash
# requires ffmpeg and ffmpeg-normalize, will create normalized versions of the input file,  plus graphical
# pictures of the input and output
# Example:
# $ ./normalize-audio.sh keyboard-recording
# (above assumes there is a keyboard-recording.wav input file)

#for i in *.wav; do ffmpeg -i "$i" -f mp3 "${i%}.mp3"; done

echo "Input file [$1.wav] || date `date`" > "$1".ffmpeg.txt
ffmpeg -hide_banner -i "$1".wav >> "$1".ffmpeg.txt 2>&1

# loudness should be -23, per https://www.auphonic.com/blog/2013/01/07/loudness-targets-mobile-audio-podcasts-radio-tv/
# -f force overwrite
# -nt normalization scheme with -t level
# -p print stats
# --dual-mono obviously will sound different than actually one speaker
# -ar audio sample rate in Hz
# -e extra options for output, using this to set "audio channels" (ac) to 1 (e.g. mono)
ffmpeg-normalize -v -f -p --dual-mono -ar 96000 -nt ebu -t -19 -e '-ac 1' "$1".wav -o "$1".ffmpeg.wav >> "$1".ffmpeg.txt 2>&1
echo "Output file [$1.wav] || date `date`" >> "$1".ffmpeg.txt
ffmpeg -hide_banner -i "$1".ffmpeg.wav >> "$1".ffmpeg.txt  2>&1
ffmpeg -hide_banner -y -i "$1".ffmpeg.wav -lavfi showspectrumpic=s=960x540 "$1".ffmpeg.png
