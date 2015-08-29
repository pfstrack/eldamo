import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id]/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang} Roots</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$id}.html">{$lang}</a>]
</p>
<hr/>
<h1>{$lang} Roots</h1>
<hr/>
<dl> {
let $words := xdb:key(/*, 'language', $id)
for $word in $words[c:get-speech(.)='root']
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { if (not($word/ref) and $word/word[1][@l]) then concat('[', translate(c:print-lang($word/word[1][@l]), ' ', ''), if (c:is-primitive($word)) then ']' else '] ') else () }
        { if ($word/see) then c:print-word($word, <control style="bold"/>) else c:print-word($word, $primary-word) }
        { c:print-speech($word) }
        { c:print-gloss($word) }
        { if ($word/see) then (' see ', c:print-word(c:get-word($word/see), $secondary-word))  else () } 
    </dt>
) } </dl>
</body>
</html>
