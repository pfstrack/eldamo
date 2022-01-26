import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $pubmode external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldamo : {$lang-name} Semantic Categories</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />

<script src="../../js/glaemscribe.min.js"></script>
<script src="../../js/tengwar_ds.cst.js"></script>
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
<h1>{$lang-name} Semantic&#160;Categories</h1>
<hr/>
<ul>
{
for $cat-group in /*/cats/cat-group
return (
    <li>
        <a href="#{$cat-group/@id}">
        { $cat-group/@num/string() }.
        { $cat-group/@label/string() }
        </a>
    </li>
) }
</ul>
<hr/>
{
let $lang-group := c:get-neo-lang-group($id)
let $is-neo-lang := count($lang-group) gt 1
for $cat-group in /*/cats/cat-group
let $cats := $cat-group/cat[xdb:key(., 'category', @id)[@l=$lang-group]
        [c:is-word(.)][not($is-neo-lang) or not(combine)]][not(see)]
        [not(@gloss='[unglossed]')][not(c:get-gloss(.) = '‽')]
return (
    <h2>
        <u>
        <a name="{$cat-group/@id}"/>
        { $cat-group/@num/string() }.
        { $cat-group/@label/string() }
        </u>
    </h2>,
    <ul> {
    for $cat in $cats
    return
        <li>
            <a href="#{$cat/@id/string()}">
            { $cat/@num/string() }{' '}
            { $cat/@label/string() }
            </a>
            { if ($pubmode != 'true') then concat(' [', $cat/@id/string(), ']') else ()}
        </li>
    } </ul>,
    for $cat in $cats
    return (
        <h3>
            <u>
            <a name="{$cat/@id}"/>
            { $cat/@num/string() }{' '}
            { $cat/@label/string() }
            { if ($pubmode != 'true') then concat(' [', $cat/@id/string(), ']') else ()}
            </u>
        </h3>,
        <dl> {
for $word in $cat/xdb:key(., 'category', @id)[@l=$lang-group]
    [c:is-word(.)][not($is-neo-lang) or not(combine)][not(see)]
let $alt-lang := c:alt-lang($word)
let $neo-lang := if ($id = 'nq' or $id = 'ns' or $id = 'np') then true() else false()
let $normalize := if ($id = 'nq') then true() else false()
let $deprecated :=
    if ($word/deprecated) then $word/deprecated
    else if ($word/see/c:get-word(.)/deprecated) then $word/see/c:get-word(.)/deprecated
    else ()
order by if ($neo-lang)
    then c:normalize-for-sort(c:normalize-spelling($word/@v))
    else c:normalize-for-sort($word/@v)
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
            let $lang-list := (
            concat(
                c:print-lang2($word),
                if ($alt-lang) then concat(' [', $alt-lang, ']') else ()
            ),
            for $w in $word/ancestor-or-self::word[last()]//word[combine[@l=$word/@l and @v=$word/@v]]
                    [not(c:print-lang2(.) = $alt-lang)] return 
                (c:print-lang2($w))
            )
            return concat(string-join(distinct-values($lang-list), ', '), if (c:is-primitive($word)) then '' else ' ')
        ) }
        { if ($word/see) then c:print-word($word, <control style="bold" normalize="{$normalize}"/>)
          else c:print-word($word, <control style="bold" show-link="y" normalize="{$normalize}"/>) }
        { if ($word/@stem) then <span> (<b>{if ($normalize) then c:normalize-spelling($word/@stem) else $word/@stem/string()}</b>)</span> else () }
        { if ($word/@tengwar) then <span> [<b>{$word/@tengwar/string()}</b>]</span> else () }
        { c:print-speech($word) }
        { if ($neo-lang) then c:print-neo-gloss($word) else c:print-gloss($word) }
        { if ($word/see and not($neo-lang and $word/deprecated/@v))
          then (' see ', c:print-word(c:get-word($word/see),
            <control show-link="y" normalize="{$normalize}"> {
              if ($neo-lang or c:get-lang($word) != $word/see/@l) then attribute show-lang {'y'} else ()
            } </control>
        )) else () } 
        { if ($neo-lang and $word/deprecated/@v) then ('; see instead:',
            for $deprecated in $word/deprecated return <dd class="see-instead"> {
                c:print-word(c:get-word($deprecated), <control show-link="y" normalize="{$normalize}" show-lang="y" show-gloss="y" is-neo="y"/>)
            } </dd>
        )  else () } 
    </dt>
        ) } </dl>
    )
) }
{
let $lang-group := c:get-neo-lang-group($id)
let $is-neo-lang := count($lang-group) gt 1
let $base-group := if ($pubmode = 'true') then ()
    else if ($is-neo-lang)
    then /*/word[@l=$lang-group]
    else xdb:key(/*, 'language', $id)
let $uncategorized := $base-group
    [$pubmode != 'true']
    [not(starts-with(c:get-speech(.), 'phon'))]
    [not(ends-with(c:get-speech(.), 'name'))]
    [not(c:get-speech(.) = 'grammar')]
    [not(c:get-speech(.) = 'phrase')]
    [not(c:get-speech(.) = 'text')]
    [not(contains(@mark, '-'))]
    [not(@cat = /*/cats/cat-group/cat/@id or @cat = '?')]
    [not(see)]
    [not(@gloss='[unglossed]')]
return if (count($uncategorized) = 0) then () else (
<p><b>Uncategorized Words</b></p>,
<dl> {
for $word in $uncategorized
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { c:print-word($word, <control style="bold" show-link="y"/>) } <u>{ $word/@cat/string() }</u>
    </dt>
) } </dl>
) }
</body>
</html>
