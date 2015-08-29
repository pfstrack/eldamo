import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang-name} : Names</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$id}.html">{$lang-name}</a>]
</p>
<hr/>
<h1>{$lang-name} Names</h1>
{xdb:html($lang/names/string())}
<hr/>
<dl> {
let $words := /*//word[@l=$id]
for $word in $words
        [ends-with(c:get-speech(.), '-name')]
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { if ($word/see) then c:print-word($word, <control style="bold"/>) else c:print-word($word, $primary-word) }
        { if ($word/@tengwar) then <span> [<b>{$word/@tengwar/string()}</b>]</span> else () }
        { c:print-speech($word) }
        { c:print-gloss($word) }
        { if ($word/see) then (' see ', c:print-word(c:get-word($word/see), <control show-lang="y" show-link="y"/>))  else () } 
        { if ($word/element) then 
        <span> ⇐ {c:print-word-elements($word/element, $word, $secondary-word)}</span>
        else() }
    </dt>
) } </dl>
</body>
</html>
