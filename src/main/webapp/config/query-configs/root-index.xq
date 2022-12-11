import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldamo : {$lang-name} Roots</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />

<script src="../../js/glaemscribe.min.js"></script>
<script src="../../js/tengwar_ds_eldamar.cst.js"></script>
<script src="../../js/quenya.glaem.js"></script>
<script src="../../js/sindarin-beleriand.glaem.js"></script>
<script src="../../js/sindarin-classical.glaem.js"></script>
<script src="../../js/transcribe.js"></script>

</head>
<body>
<div id="nav-block" class="nav-block">
    [<a href="../../index.html">Home</a>] »
<span class="breadcrumb-nav">
    <a href="../languages/index.html">Languages</a> »&#160;
</span>
    <a href="../language-pages/lang-{$id}.html">{$lang-name}</a>
</div>
<hr/>
<h1>{$lang-name} Roots</h1>
{xdb:html($lang/roots/string())}
<hr/>
<dl> {
let $words := c:lang-words(/*, $id)
let $neo-lang := if ($id = 'nq' or $id = 'ns' or $id = 'np') then true() else false()
for $word in $words[c:get-speech(.)='root']
let $deprecated :=
    if ($word/deprecated) then $word/deprecated
    else if ($word/see/c:get-word(.)/deprecated) then $word/see/c:get-word(.)/deprecated
    else ()
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { if (
            $neo-lang and (
                $deprecated or
                contains($word/@mark, '|') or
                contains($word/@mark, '-') or
                contains($word/@mark, '‽') or
                $word/@gloss='[unglossed]' or
                $word/@l = ('ep', 'en', 'eq', 'g')
            )
          ) then <span>⚠️</span> else () }
        { if (not($neo-lang)) then () else (
            let $lang-list := (c:print-lang2($word), for $w in $word/ancestor-or-self::word[last()]//word[combine[@l=$word/@l and @v=$word/@v]] return c:print-lang2($w))
            return string-join($lang-list, ', ')
        ) }
        { if (not($word/ref) and $word/word[1][@l]) then concat('[', translate(c:print-lang($word/word[1][@l]), ' ', ''), if (c:is-primitive($word)) then ']' else '] ') else () }
        { if ($word/see) then c:print-word($word, <control style="bold"/>) else c:print-word($word, $primary-word) }
        { c:print-speech($word) }
        { if ($neo-lang) then c:print-neo-gloss($word) else c:print-gloss($word) }
        { if ($word/see) then (' see ', c:print-word(c:get-word($word/see), $secondary-word))  else () } 
        { if ($neo-lang and $word/deprecated/@v) then ('; see instead:',
            for $deprecated in $word/deprecated return <dd class="see-instead"> {
                c:print-word(c:get-word($deprecated), <control show-link="y" show-lang="y" show-gloss="y" is-neo="y"/>)
            } </dd>
        )  else () } 
    </dt>
) } </dl>
</body>
</html>
