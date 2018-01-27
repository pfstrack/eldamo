import module namespace c = "common.xq" at "common.xq";

declare function local:order-of($rule as element()?) as xs:string? {
    if ($rule) then
    xdb:key($rule, 'rule-to', concat($rule/@l, ':', $rule/@rule, ':', $rule/@from))/../@order/string()
    else ()
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
<title>Misordered Rules</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>[<a href="../../index.html">Home</a>]</p>
<hr/>
<h1>Misordered Rules</h1>
{
let $rules := //word[@speech='phonetic-rule'][before]
let $bad-rules :=
    $rules[before[c:get-word(.)/@order lt ../@order]]
return (
<p><b>Bad Rules: </b> {count($bad-rules)}</p>,
<dl> {
    for $word in $bad-rules
    order by $word/c:get-lang(.), c:normalize-for-sort($word/@v)
    return (
    <dt>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</dt>
) } </dl>
) }
{
let $rule-words := //word[ref/deriv/rule-example]
let $bad-words :=
    $rule-words[ref/deriv/rule-example[
        local:order-of(.) lt local:order-of(preceding-sibling::rule-example[1]) and
        @l = preceding-sibling::rule-example[1]/@l
    ]] 
return (
<p><b>Bad Words: </b> {count($bad-words)}</p>,
<dl> {
    for $word in $bad-words
    order by $word/c:get-lang(.), c:normalize-for-sort($word/@v)
    return (
    <dt>{name($word)} l="{$word/@l/string()}" v="{c:print-word($word, <control show-link="y" hide-mark="y"/>)}"</dt>
) } </dl>
) }
<!--
let $bad-words :=
    $rule-words[ref/deriv/rule-example[xdb:key(., 'rule-to', concat(@l, ':', @rule, ':', @from))/@order gt preceding-sibling::rule-example[1]/xdb:key(., 'rule-to', concat(@l, ':', @rule, ':', @from))/@order]] 
-->
</body>
</html>
