#!/usr/bin/env bash

export PATH="$PATH:/usr/local/bin/"

if [[ $(( $RANDOM % 2 )) -eq 0 ]]; then
    TITLE=$(curl -i -sS https://en.wikipedia.org/wiki/Special:Random | ag Location | ag -o "[^/]+$")
    TITLE_WITHOUT_NEWLINE=$(echo -n $(echo -n $TITLE | sed -e 's/.\{1\}$//'))
    CONTENT=$(curl -sS "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=$TITLE_WITHOUT_NEWLINE" | jq -r '[.query.pages[].title, .query.pages[].extract] | join(": ") | @text')
    # CONTENT=$(curl -sS "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exsectionformat=plain&explaintext=&titles=$TITLE_WITHOUT_NEWLINE" | jq -r '[.query.pages[].title, .query.pages[].extract] | join(": ") | @text')
    echo "$CONTENT"
else
    # echo $(/usr/local/bin/gshuf /usr/share/dict/words | head -c1023) | hexdump -C
    echo $(gshuf /usr/share/dict/words | head -c255) | hexdump -C
fi

echo ""
echo ""