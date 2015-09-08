import module namespace c = "common.xq" at "common.xq";

declare function local:lang-order($lang as xs:string) as xs:string {
    if ($lang = 'q') then (
       '0'
    ) else if ($lang = 's') then (
       '1'
    ) else if ($lang = 'mq') then (
       '2'
    ) else if ($lang = 'n') then (
       '3'
    ) else if ($lang = 'eq') then (
       '4'
    ) else if ($lang = 'en') then (
       '5'
    ) else if ($lang = 'g') then (
       '6'
    ) else if ($lang = 'p') then (
       '7'
    ) else if ($lang = 'mp') then (
       '8'
    ) else if ($lang = 'ep') then (
       '9'
    ) else (
       $lang
    )
    
};

concat(
'index=[&#10;',
    string-join(
        for $word in //word
            [not(starts-with(c:get-speech(.), 'phon'))]
            [not(c:get-speech(.) = 'phrase')]
            [not(c:get-speech(.) = 'text')]
            [not(c:get-speech(.) = 'grammar')]
        order by local:lang-order(c:get-lang($word)), c:normalize-for-sort($word/@v)
        return
        concat(
            '"',
            c:get-lang($word), '%',
            $word/@v, '%',
            c:get-speech($word),  '%',
            c:get-gloss($word),  '%',
            $word/@mark,  '%',
            if (c:get-word($word/see)) then xdb:hashcode(c:get-word($word/see)) else xdb:hashcode($word), '%',
            c:alt-lang($word), '%',
            if ($word/see) then $word/see/@v else '', '%',
            if ($word/see and $word/see/@l != c:get-lang($word)) then c:print-lang($word/see) else '',
            '",'
        ),
    '&#10;'),
'&#10;""];&#10;',
'langs=[&#10;',
    string-join(
        for $lang in //language[@id]
        order by local:lang-order($lang/@id)
        return
        concat(
            '"',
            $lang/@id, '%',
            $lang/@name,
            '",'
        ),
    '&#10;'),
'&#10;""];&#10;'
)
