if [[ $3 == '' ]]; then
	#BKPSFLDR="/run/media/ilya/MalinuxBack/backup/ilya"
	BKPSFLDR="/run/media/ilya/MalinuxBack/backup_mac"
else
	BKPSFLDR=$3
fi
LIST=$(ls $BKPSFLDR)
for i in $LIST; do
	ag -i -a --search-binary "$2" "$BKPSFLDR/$i/$1"
done
