import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $pubmode external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;
declare variable $lang-words := /*//word[@l=$id];
declare variable $groups := $lang-words[c:get-speech(.) = 'phonetic-group'];
declare variable $vowels := $lang-words[@v='vowels'];
declare variable $long-vowels := $lang-words[@v='long-vowels'];
declare variable $diphthongs := $lang-words[@v='diphthongs'];
declare variable $ed-diphthongs := $lang-words[@v='east-danian-diphthongs'];
declare variable $phonemes := $lang-words[c:get-speech(.) = 'phoneme'];
declare variable $other-phonetic := $lang-words
    [starts-with(c:get-speech(.), 'phone')]
    [not(c:get-speech(.) = 'phonetic-group')]
    [not(c:get-speech(.) = 'phoneme')]
    [not(c:get-speech(.) = 'phonetic-rule')]
;

declare function local:print-phoneme($word as element()?) as element() {
    <span>
        { c:print-word($word, $secondary-word) }
        { if ($word/@orthography) then concat(' ‹', $word/@orthography/string(), '›') else () }
    </span>
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldamo : {$lang-name} Phonetics</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
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
<h1>{$lang-name} Phonetics</h1>
{xdb:html($lang/phonetics/string())}

{if ($phonemes) then <h2>Phonemes</h2> else ()}
{
if (not($groups/@phone-row) or not($groups/@phone-col)) then () else
<table> {(
    <tr> {(
        <td>&#160;</td>, 
        for $col-group in $groups[@phone-col] order by $col-group/@phone-col return 
        <td>{c:print-word($col-group, $primary-word)}</td> 
    )} </tr>,
    for $row-group in $groups[@phone-row] order by $row-group/@phone-row return
    <tr> {(
        <td>{c:print-word($row-group, $primary-word)}</td>,
        for $col-group in $groups[@phone-col] order by $col-group/@phone-col return 
        <td> {
            for $phoneme in $phonemes[@v=$col-group/element/@v][@v=$row-group/element/@v] return 
            <span>{local:print-phoneme($phoneme)}{text {' '}}</span> 
        } </td> 
    )} </tr>
)} </table>
}
<br/>
<table> {(
    <tr> {(
        <td>{c:print-word($vowels, $primary-word)}</td>,
        for $vowel in $vowels/element
        let $phoneme := $phonemes[@v=$vowel/@v] return
        <td>{local:print-phoneme($phoneme)}</td>
    )} </tr>,
    if ($long-vowels) then <tr> {(
        <td>{c:print-word($long-vowels, $primary-word)}</td>,
        for $long-vowel in $long-vowels/element
        let $phoneme := $phonemes[@v=$long-vowel/@v] return
        <td>{local:print-phoneme($phoneme)}</td>
    )} </tr> else (),
    <tr> {(
        <td>{c:print-word($diphthongs, $primary-word)}</td>,
        for $diphthong in $diphthongs/element
        let $phoneme := $phonemes[@v=$diphthong/@v] return
        <td>{local:print-phoneme($phoneme)}</td>
    )} </tr>,
    if ($id = 'dan') then <tr> {(
        <td>{c:print-word($ed-diphthongs, $primary-word)}</td>,
        for $diphthong in $ed-diphthongs/element
        let $phoneme := $phonemes[@v=$diphthong/@v] return
        <td>{local:print-phoneme($phoneme)}</td>
    )} </tr> else (),
    <tr> {(
        <td><b>others</b></td>,
        for $phoneme in $phonemes[not($vowels/element/@v = @v) and not($diphthongs/element/@v = @v) and 
            not($long-vowels/element/@v = @v) and not($ed-diphthongs/element/@v = @v) and
            (not($groups[@phone-col]/element/@v = @v) or not($groups[@phone-row]/element/@v = @v))]
        order by c:normalize-for-sort($phoneme/@v)
        return
        <td>{local:print-phoneme($phoneme)}</td>
    )} </tr>
)}</table>

{c:show-hierarchy($groups, 'phonetic-group', 'Phonetic Groups')}

{if ($lang-words[c:get-speech(.) = 'phonetic-rule']) then <h2>Phonetic Rules</h2> else ()}
<table> {
for $word in $lang-words[c:get-speech(.) = 'phonetic-rule']
let $from := ($word/@from | $word/rule/@from)[1]
let $rule := ($word/@rule | $word/rule/@rule)[1]
order by $word/@order, c:normalize-for-sort($word/@v)
return
    <tr> { (
        <td>
            { if ($pubmode != 'true' and not($word/notes)) then '[NO NOTES] ' else () }
            { c:print-word($word, $primary-word) }
        </td>,
        <td style="border-right: none; text-align: right">[{$from/string()}]</td>,
        <td style="border-left: none; border-right: none">&gt;</td>,
        <td style="border-left: none">[{$rule/string()}]</td>,
        <td>{$word/@order/string()}</td>,
        if (not($word/@from) and count($word/rule) gt 1) then <td>ERROR:MULTI-RULE</td> else ()
    ) } </tr>
} </table>

{if ($other-phonetic) then <h2>Other</h2> else ()}
<dl> {
for $word in $other-phonetic
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { c:print-word($word, $primary-word) }
    </dt>
) } </dl>

<div> {
let $unex-derivs := $lang-words
    [not(starts-with(c:get-speech(.), 'phon'))]
    [ref/deriv[not(c:is-root(c:get-ref(.)) and false())][string(.) = ''] and not(ref/deriv/rule-start)]
    [$pubmode != 'true']
return if (count($unex-derivs) = 0) then () else (
<p><b>Unexamined Derivatives ({count($unex-derivs)})</b></p>,
<dl> {
for $word in $unex-derivs
let $deriv := $word/ref[deriv[not(c:is-root(c:get-ref(.)) and false())]][1]/deriv[1]
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { c:print-word($word, $primary-word) } &lt; 
        { if ($deriv/@i3) then (c:print-wordlet($deriv/@i3, ' &lt; ')) else () } 
        { if ($deriv/@i2) then (c:print-wordlet($deriv/@i2, ' &lt; ')) else () } 
        { if ($deriv/@i1) then (c:print-wordlet($deriv/@i1, ' &lt; ')) else () } 
        { c:print-word($deriv/c:get-ref(.), <control/>) }
    </dt>
) } </dl>
) } </div>

</body>
</html>
