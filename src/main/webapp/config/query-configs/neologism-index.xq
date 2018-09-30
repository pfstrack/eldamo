import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $pubmode external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldamo : {$lang-name} Neologisms</title>
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
<h1>{$lang-name} Neologisms</h1>
{xdb:html($lang/neologisms/string())}
<hr/> 
<ul> {
let $versions := distinct-values(xdb:key(/*, 'language', $id)/@neo-version)
for $version in $versions
order by $version descending
return
    <li><a href="#{$version}">Version {$version}</a></li>
} </ul>
<hr/> { 
let $versions := distinct-values(xdb:key(/*, 'language', $id)/@neo-version)
for $version in $versions
order by $version descending
return
let $words := xdb:key(/*, 'language', $id)
let $word-list := $words
        [@neo-version = $version]
        [not(ends-with(c:get-speech(.), '-name'))]
        [not(c:get-speech(.)='text')]
        [not(c:get-speech(.)='phrase' or c:get-speech(.)='text')]
        [not(c:get-speech(.)='grammar')]
        [not(starts-with(c:get-speech(.), 'phone'))]
return (
<h2><a name="{$version}"></a>Version {$version}</h2>,
<dl> {
for $word in $word-list
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
            c:print-lang($word),
            if ($alt-lang and not(contains($word/@mark, '!'))) then concat(' [', $alt-lang, '] ') else ()
        ) }
        { if ($word/see) then c:print-word($word, <control style="bold" normalize="{$normalize}"/>)
          else c:print-word($word, <control style="bold" show-link="y" normalize="{$normalize}"/>) }
        { if ($word/@stem) then <span> (<b>{if ($normalize) then c:normalize-spelling($word/@stem) else $word/@stem/string()}</b>)</span> else () }
        { if ($word/@tengwar) then <span> [<b>{$word/@tengwar/string()}</b>]</span> else () }
        { if (($id = 'ns' or $id = 'nq') and
             not($word/@speech = 'grammar' or $word/@speech = 'text' or contains($word/@speech, 'phone')) and
             not($word/@l='q' and starts-with($word/@v, '-d'))
            )
            then ( (: ', DISABLED TENGWAR ',
                <span class="transcribe"
                    data-value="{
                        if ($word/@tengwar='ñ') then
                            translate($word/@v/lower-case(.), 'n', 'ñ') 
                        else if ($word/@tengwar='þ') then
                            translate($word/@v/lower-case(.), 's', 'þ') 
                        else $word/@v/lower-case(.)
                    }" data-lang="{$word/@l}"></span>
            , ' ' :) ) else ()}
        { c:print-speech($word) }
        { if ($neo-lang) then c:print-neo-gloss($word) else c:print-gloss($word) }
        { if ($word/see and not($neo-lang and $deprecated))
          then (' see ', c:print-word(c:get-word($word/see),
            <control show-link="y" normalize="{$normalize}"> {
              if ($neo-lang or c:get-lang($word) != $word/see/@l) then attribute show-lang {'y'} else ()
            } </control>
        )) else () }
        { if ($word/element) then 
        <span> ⇐ {c:print-word-elements($word/element, $word, <control show-link="y"/>)}</span>
        else() }
        { if ($word/deriv) then 
        <span> &lt; {c:print-word($word/deriv[1]/c:get-word(.), <control show-lang="y" show-link="y"/>)}</span>
        else() }
        { if (contains($word/@mark, "^")) then 
        <span> « {
            let $precursor := $word/word[deprecated/@l = $word/@l and deprecated/@v = $word/@v]/c:get-word(.) return
            if (not($precursor)) then ''
            else c:print-word($precursor[1], <control show-lang="y" show-link="y"/>)
        }</span>
        else() }
        { if (not($word/@created or $word/@vetted)) then () else
          (' [',
            <span> { concat(
            if ($word/@created) then concat('created by ', $word/@created/string()) else '',
            if ($word/@created and $word/@vetted) then ', ' else '',
            if ($word/@vetted) then concat('vetted by ', $word/@vetted/string()) else '')
            } </span>
          , ']') }
        { if (contains($word/@mark, "^")) then
             let $precursor := $word//word[deprecated/@l = $word/@l and deprecated/@v = $word/@v]/c:get-word(.) return
             if (not($precursor) and not($word/deprecated)) then ' ERROR:NO_PRECURSOR' else ()
          else if (not($word/@mark)) then
             let $combines := $word//word[combine/@l = $word/@l and combine/@v = $word/@v]/c:get-word(.) return
             if (not($combines)) then ' ERROR:NO_COMBINES' else ()
          else if (not(contains($word/@mark, "!")) and not(contains($word/@mark, "?")) and
            not(contains($word/@mark, "*") and $word/@l='np')) then ' ERROR:NO_NEO_MARKER'
          else () }
        {   if ($neo-lang and $deprecated/@v) then (
            for $x in $deprecated return <dd class="see-instead"> {
                c:print-word(c:get-word($x), <control show-link="y" normalize="{$normalize}" show-lang="y" show-gloss="y" is-neo="y"/>)
            } </dd>
        )  else () } 
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
return <dt>{c:print-word($word, <control style="bold" show-link="y"/>) }</dt>
} </dl>
) ) 
) ) }
</body>
</html>
