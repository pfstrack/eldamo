import module namespace c = "common.xq" at "common.xq";

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Unmatched Links</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>[<a href="../../index.html">Home</a>]</p>
<hr/>
<h1>Unmatched Links</h1>
{
let $words := //word[not(starts-with(c:get-speech(.), 'phone'))]
let $bad-words :=
    $words[*[not(name()='ref')][@v != '?'][count(c:get-word(.)) ne 1]] |
    $words[cognate[not(@l)]] |
    $words[count(c:get-word(.)) ne 1] 
return (
<p>count: {count($bad-words)}</p>,
<dl> {
    for $word in $bad-words
    order by $word/c:get-lang(.), c:normalize-for-sort($word/@v)
    return (
    <dt>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</dt>,
    for $bad-link in $word/*[not(name()='ref') and @v != '?'][count(c:get-word(.)) ne 1] | $word/cognate[not(@l)] return
    <dd>{name($bad-link)} v="{$bad-link/@v/string()}"</dd>
) } </dl>
) }
<h1>Unprocessed References</h1>
{
(:
let $refs := //ref[not(c:get-ref(.)) or not(contains(@source, '.')) or ends-with(@source, '.00000')
                       or *[@source][not(c:get-ref(.))]]
:)
let $refs := //ref[not(c:get-ref(.)) or not(contains(@source, '.')) or ends-with(@source, '.00000')
                       or *[@source][not(c:get-ref(.))]]
let $sources := distinct-values($refs/substring-before(concat(@source, '/'), '/'))
return (
<p>count: {count($refs)}</p>,
<ul> {
    for $source in $sources
    let $count := count($refs[@source = $source or starts-with(@source, concat($source, '/'))])
    order by -1 * $count return
    <li><a href="../references/ref-{$source}.html">{$source}</a>: {$count}</li>
} </ul>,
for $ref in $refs
order by c:normalize-for-sort($ref/@source)
return <p>v="{$ref/@v/string()}" source="{$ref/@source/string()}"</p>
) }
<h1>Duplicate Page Ids</h1>
{
let $bad-words :=
    //word[@page-id][count(xdb:key(., 'page-id', @page-id)) gt 1] 
return (
<p>count: {count($bad-words)}</p>,
<dl> {
    for $word in $bad-words
    order by $word/c:get-lang(.), c:normalize-for-sort($word/@v)
    return (
    <dt>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</dt>
) } </dl>
) }
<!--
<h1>Extraneous Elements</h1> { (:
for $word in //word[count(combine) > 1] return
<p>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</p>
 :) }
<h1>Extraneous Elements</h1>
{ (:
let $words := //word
let $extra-link-words := $words[not(ref) and not(other-ok) and *[not(name()='ref' or name()='word' or name()='notes')] 
    and not(starts-with(c:get-speech(.), 'phon') or c:get-speech(.) = 'grammar')]
return (
<p>count: {count($extra-link-words)}</p>,
<dl> {
    for $word in $extra-link-words
    order by $word/c:get-lang(.), c:normalize-for-sort($word/@v)
    return (
    <dt>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</dt>
) } </dl>
) :) }
<h1>Cross-Word Inflections</h1>
{ (:
let $words := //word
let $cross-inflect-words := $words[ref/inflect/c:get-ref(.)/.. != .]
return (
<p>count: {count($cross-inflect-words)}</p>,
<dl> {
    for $word in $cross-inflect-words
    order by $word/c:get-lang(.), c:normalize-for-sort($word/@v)
    return (
    <dt>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</dt>,
    for $inflect in $word/ref/inflect[c:get-ref(.)/.. != ../..]
    return
    <dd>v="{$inflect/@v/string()}" source="{$inflect/@source/string()}"</dd>
) } </dl>
) :) }
-->
</body>
</html>
