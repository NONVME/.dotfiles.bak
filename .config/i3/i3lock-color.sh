#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#8fbcbbbb'  # default
T='#8fbcbbbb'  # text
W='#bf616aaa'  # wrong
V='#a3be8ccc'  # verifying

i3lock \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T       \
--wrongcolor=$W       \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$D       \
--bshlcolor=$W        \
\
--screen 1            \
--blur 5              \
--clock               \
--indicator           \
--timestr="%H:%M"  \
--datestr="%A, %m %Y" \
--ignore-empty-password \
--bar-indicator       \
--timesize=45 \
--datesize=35 \
--verifsize=80 \
--wrongsize=80 \
--bar-direction=0 \
--bar-color=$B    \
# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --timefont=comic-sans
# --datefont=monofur
# etc
