#!/bin/bash
for format in "pdf" "eps"
do
  for i in $(ls *.svg); do inkscape $i --export-$format=`echo $i | sed -e "s/svg/$format/"`; done
done

for i in "pdf" "eps" "svg"
do
  mkdir $i
  mv ./*.$i ./$i/
done

cd ./pdf/
rm ./combo.pdf
pdfunite *.pdf combo.pdf
