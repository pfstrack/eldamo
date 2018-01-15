import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang-name} Roots</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$id}.html">{$lang-name}</a>]
</p>
<hr/>
<h1>{$lang-name} Roots</h1>
{xdb:html($lang/roots/string())}
<hr/>
<dl> {
let $words := c:lang-words(/*, $id)
let $neo-lang := if ($id = 'nq' or $id = 'ns' or $id = 'np') then true() else false()
for $word in $words[c:get-speech(.)='root']
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { if ($neo-lang and $word/deprecated) then '⚠️ ' else () }
        { if (not($neo-lang)) then () else (
            let $lang-list := (c:print-lang2($word), for $w in $word//word[@combine][ancestor::word[not(@combine)][1]/@l = $word/@l] return c:print-lang2($w))
            return string-join($lang-list, ', ')
        ) }
        { if (not($word/ref) and $word/word[1][@l]) then concat('[', translate(c:print-lang($word/word[1][@l]), ' ', ''), if (c:is-primitive($word)) then ']' else '] ') else () }
        { if ($word/see) then c:print-word($word, <control style="bold"/>) else c:print-word($word, $primary-word) }
        { c:print-speech($word) }
        { c:print-gloss($word) }
        { if ($word/see) then (' see ', c:print-word(c:get-word($word/see), $secondary-word))  else () } 
        { if ($neo-lang and $word/deprecated/@v) then ('; see instead: ',
            if (count($word/deprecated/@v) = 1)
            then c:print-word(c:get-word($word/deprecated), <control show-link="y" show-lang="y" show-gloss="y"/>)
            else <ul> {
                for $deprecated in $word/deprecated return <li> {
                    c:print-word(c:get-word($deprecated), <control show-link="y" show-lang="y" show-gloss="y"/>)
                } </li>
            } </ul>
        )  else () } 
    </dt>
) } </dl>
</body>
</html>
