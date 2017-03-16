sbj="long subject"


read -d '' body << MSG
Madame, Monsieur, Bonjour,

body!

Cordialement,

Ilya Prokin
MSG


read -d '' list_to << LIST
test@test2.fr
test@test3.fr
LIST


# send messages

for to in $list_to; do
    echo "$body" | mutt -s "$sbj" "$to"
done
