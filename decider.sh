#!/bin/bash

REGION=$1
ROUND=$2
LIST=$3

function winner {
  WINNER=`echo $1 | cut -d"#" -f 1`
  GAME=`echo $1 | cut -d"#" -f 2`
  case "$ROUND" in
  F4)
    RANK=`echo $WINNER | cut -d"," -f 2`
    TEAM=`echo $WINNER | cut -d"," -f 1`
    echo F4$RANK
    echo $TEAM
    perl -p -i -e "s/F4${RANK}/${TEAM}/" $REGION/64.lst
  ;;
  64)
    perl -p -i -e "s/GAME${GAME}#/$WINNER/" $REGION/32.lst
  ;;
  32)
    perl -p -i -e "s/GAME${GAME}#/$WINNER/" $REGION/16.lst
  ;;
  16)
    perl -p -i -e "s/GAME${GAME}#/$WINNER/" $REGION/8.lst
  ;;
  8)
    perl -p -i -e "s/#${REGION}#/$WINNER/" working/4.lst
  ;;
  4)
    perl -p -i -e "s/GAME${GAME}#/$WINNER/" working/2.lst
  ;;
  2)
    S1=`shuf -i 50-90 -r -n 1`
    S2=`shuf -i 50-90 -r -n 1`
    perl -p -i -e "s/CHAMPION/$WINNER/" working/1.lst
    if [ "$S1" -gt "$S2" ]
    then
      perl -p -i -e "s/SCORE1/$S1/" working/1.lst
      perl -p -i -e "s/SCORE2/$S2/" working/1.lst
    else
      perl -p -i -e "s/SCORE1/$S2/" working/1.lst
      perl -p -i -e "s/SCORE2/$S1/" working/1.lst
    fi
  ;;
  esac
}

if [ "$ROUND" == "F4" ]
then
  cp $REGION/64.lst.orig $REGION/64.lst
fi

G=1

while read line
do
  T1=`echo $line | cut -d":" -f 1`
  T1N=`echo $T1 | cut -d"," -f 1`
  T1R=`echo $T1 | cut -d"," -f 2`
  T2=`echo $line | cut -d":" -f 2`
  T2N=`echo $T2 | cut -d"," -f 1`
  T2R=`echo $T2 | cut -d"," -f 2`
  T1O=$(((`shuf -i 1-$T1R -r -n 1` * ($T1R / $T2R)) + `shuf -i 1-80 -r -n1`))
  T2O=$(((`shuf -i 1-$T2R -r -n 1` * ($T2R / $T1R)) + `shuf -i 1-80 -r -n1`))
  #echo $T1O vs $T2O
  if [ "$T1O" -le "$T2O" ]
  then
    winner "$T1#$G"
  else
    winner "$T2#$G"
  fi
  G=$((G+1))
done < $LIST
