import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;
declare variable $lang-words := /*//word[@l=$id];

declare function local:print-phrase($word as element()) as element() {
    let $v := $word/@v/string() 
    return
    <li>
        { if (count($lang-words[@v=$v]) gt 1) then '[ERROR:DUPLICATE] ' else () }
        { c:print-word($word, $primary-word) }
        { text {' '} }
        { c:print-gloss($word) }
        { if (not($word/word[@l=$id])) then () else
            <ul> {
            for $child in $word/word[@l=$id] return local:print-phrase($child)
            } </ul>
        }
    </li>
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
<title>Eldamo : {$lang-name} Phrases</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$id}.html">{$lang-name}</a>]
</p>
<hr/>
<h1>{$lang-name} Phrases</h1>
{xdb:html($lang/phrases/string())}
<hr/>
{if ($lang-words[c:get-speech(.) = 'text']) then <h2>Texts</h2> else ()}
<ul style="list-style-type: none; padding: 0; margin: 0;"> {
for $word in $lang-words[c:get-speech(.) = 'text'][not(parent::word[c:get-lang(.) = $id])]
order by c:normalize-for-sort($word/@v)
return local:print-phrase($word)
} </ul>
{if ($lang-words[c:get-speech(.) = 'text']) then <h2>Phrases</h2> else ()}
<ul style="list-style-type: none; padding: 0; margin: 0;"> {
let $lang-words := /*//word[@l=$id]
for $word in $lang-words[c:get-speech(.) = 'phrase'][not(parent::word[c:get-lang(.) = $id])]
order by c:normalize-for-sort($word/@v)
return local:print-phrase($word)
} </ul>
</body>
</html>
