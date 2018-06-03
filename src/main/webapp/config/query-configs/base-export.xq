import module namespace c = "common.xq" at "common.xq";

concat('"Page ID","Lang","Word","Speech","English","Translation"&#10;',
string-join(for $word in //word
    [not(starts-with(c:get-speech(.), 'phon'))]
    [not(ends-with(c:get-speech(.), 'name'))]
    [not(c:get-speech(.) = 'phrase')]
    [not(c:get-speech(.) = 'text')]
    [not(c:get-speech(.) = 'grammar')]
order by $word/@l, $word/@v
return
    concat('"',
        xdb:hashcode($word), '","',
        c:get-lang($word), '","', 
        $word/@v, '","', 
        c:get-speech($word), '","', 
        c:get-gloss($word), '"'
    ),
"&#10;"))