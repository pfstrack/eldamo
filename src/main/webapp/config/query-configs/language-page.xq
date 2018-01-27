import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();

declare function local:get-speech($word as element()?) as xs:string? {
    $word/ancestor-or-self::*[@speech][1]/@speech/string()
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
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
{
let $all := c:lang-words(/*, $id)
let $is-neo-lang := $id = ('nq', 'ns', 'np')
let $roots := $all[local:get-speech(.)='root']
let $words := $all
    [not(ends-with(local:get-speech(.), '-name'))]
    [not(local:get-speech(.)='phrase' or local:get-speech(.)='text')]
    [not(starts-with(local:get-speech(.), 'phone'))]
    [not(local:get-speech(.)='grammar')]
    [not(local:get-speech(.)='root')]
let $names := $all[ends-with(local:get-speech(.), '-name')][not($is-neo-lang)]
let $phrases := $all[local:get-speech(.)='phrase' or local:get-speech(.)='text'][not($is-neo-lang)]
let $phonetics := $all[starts-with(local:get-speech(.), 'phone')][not($is-neo-lang)]
let $grammar := $all[local:get-speech(.)='grammar'][not($is-neo-lang)]
let $categories := ($words | $roots)[ancestor-or-self::*[@cat and not(@cat='?')]]
let $post-fix := if ($is-neo-lang) then '?neo' else '' 
return
<ul> { (
    if ($roots) then <li><a href="../root-indexes/roots-{$id}.html{$post-fix}">Roots</a> ({count($roots)})</li> else (),
    if ($words) then <li><a href="../word-indexes/words-{$id}.html{$post-fix}">Words</a> ({count($words)})</li> else (),
    if ($names) then <li><a href="../name-indexes/names-{$id}.html{$post-fix}">Names</a> ({count($names)})</li> else (),
    if ($phrases) then <li><a href="../phrase-indexes/phrases-{$id}.html{$post-fix}">Phrases</a> ({count($phrases)})</li> else (),
    if ($grammar) then <li><a href="../grammar-indexes/grammars-{$id}.html{$post-fix}">Grammar</a> ({count($grammar)})</li> else (),
    if ($phonetics) then <li><a href="../phonetic-indexes/phonetics-{$id}.html{$post-fix}">Phonetics</a> ({count($phonetics)})</li> else (),
    if ($categories) then <li><a href="../category-indexes/categories-{$id}.html{$post-fix}">Semantic Categories</a> ({count($categories)})</li> else ()
) }</ul>
}
{xdb:html($lang/notes/string())}
</body>
</html>
