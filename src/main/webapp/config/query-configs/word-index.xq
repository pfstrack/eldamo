import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $pubmode external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang-name} Words</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$id}.html">{$lang-name}</a>]
</p>
<hr/>
<h1>{$lang-name} Words</h1>
{xdb:html($lang/words/string())}
<hr/> { 
let $words := xdb:key(/*, 'language', $id)
let $word-list := $words
        [not(ends-with(c:get-speech(.), '-name'))]
        [not(c:get-speech(.)='text')]
        [not(c:get-speech(.)='phrase' or c:get-speech(.)='text')]
        [not(c:get-speech(.)='grammar')]
        [not(starts-with(c:get-speech(.), 'phone'))]
        [not(c:get-speech(.)='root')]
return (
<dl> {
for $word in $word-list
let $alt-lang := c:alt-lang($word)
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { if ($alt-lang) then concat('[', $alt-lang, if (c:is-primitive($word)) then ']' else '] ') else () }
        { if ($word/see) then c:print-word($word, <control style="bold"/>) else c:print-word($word, $primary-word) }
        { if ($word/@stem) then <span> (<b>{$word/@stem/string()}</b>)</span> else () }
        { if ($word/@tengwar) then <span> [<b>{$word/@tengwar/string()}</b>]</span> else () }
        { c:print-speech($word) }
        { c:print-gloss($word) }
        { if ($word/see) then (' see ', c:print-word(c:get-word($word/see),
            <control show-link="y"> {
              if (c:get-lang($word) != $word/see/@l) then attribute show-lang {'y'} else ()
            } </control>
        ))  else () } 
    </dt>
) } </dl>,
if ($pubmode != 'false') then () else (
let $unglossed := $word-list[not(c:get-gloss(.))]
return (
if (not($unglossed)) then () else (
<h3>Unglossed [{count($unglossed)}]</h3>,
<dl> {
for $word in $unglossed
order by c:normalize-for-sort($word/@v)
return <dt>{c:print-word($word, $primary-word) }</dt>
} </dl>
) ) 
) ) }
</body>
</html>
