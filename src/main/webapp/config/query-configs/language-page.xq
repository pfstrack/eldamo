declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();

declare function local:get-speech($word as element()?) as xs:string? {
    $word/ancestor-or-self::*[@speech][1]/@speech/string()
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang-name}</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>]
</p>
<hr/>
<h1>{$lang-name}</h1>
{xdb:html($lang/notes/string())}
{
let $all := xdb:key(/*, 'language', $id)
let $roots := $all[local:get-speech(.)='root']
let $words := $all
    [not(ends-with(local:get-speech(.), '-name'))]
    [not(local:get-speech(.)='phrase' or local:get-speech(.)='text')]
    [not(starts-with(local:get-speech(.), 'phone'))]
    [not(local:get-speech(.)='grammar')]
    [not(local:get-speech(.)='root')]
let $names := $all[ends-with(local:get-speech(.), '-name')]
let $phrases := $all[local:get-speech(.)='phrase' or local:get-speech(.)='text']
let $phonetics := $all[starts-with(local:get-speech(.), 'phone')]
let $grammar := $all[local:get-speech(.)='grammar']
let $categories := ($words | $roots)[ancestor-or-self::*[@cat and not(@cat='?')]]
return
<ul> { (
    if ($roots) then <li><a href="../root-indexes/roots-{$id}.html">Roots</a> ({count($roots)})</li> else (),
    if ($words) then <li><a href="../word-indexes/words-{$id}.html">Words</a> ({count($words)})</li> else (),
    if ($names) then <li><a href="../name-indexes/names-{$id}.html">Names</a> ({count($names)})</li> else (),
    if ($phrases) then <li><a href="../phrase-indexes/phrases-{$id}.html">Phrases</a> ({count($phrases)})</li> else (),
    if ($grammar) then <li><a href="../grammar-indexes/grammars-{$id}.html">Grammar</a> ({count($grammar)})</li> else (),
    if ($phonetics) then <li><a href="../phonetic-indexes/phonetics-{$id}.html">Phonetics</a> ({count($phonetics)})</li> else (),
    if ($categories) then <li><a href="../category-indexes/categories-{$id}.html">Semantic Categories</a> ({count($categories)})</li> else ()
) }</ul>
}
</body>
</html>
