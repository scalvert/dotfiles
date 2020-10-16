function bro_decompress -a url
    curl $url --compressed | bro --decompress | wc -c
end
