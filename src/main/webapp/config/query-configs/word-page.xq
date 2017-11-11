import module namespace c = "common.xq" at "common.xq";

declare function local:print-deriv($deriv as node()?) as element() {
    <span>
{c:print-word($deriv/c:get-ref(.), <print-word show-link="parent" show-lang="y"/>)}
&gt;
{c:print-wordlet($deriv/@i1, ' &gt; ')}
{c:print-wordlet($deriv/@i2, ' &gt; ')}
{c:print-wordlet($deriv/@i3, ' &gt; ')}
{c:print-word($deriv/parent::ref, <print-word show-link="parent" show-lang="y"/>)}
    </span>
};

declare function local:is-match($s1 as xs:string?, $s2 as xs:string?) as xs:boolean {
    not(c:normalize-for-match($s1) != c:normalize-for-match($s2))
};

declare function local:print-ref($ref as element(), $ref-set) as element()* {
    let $other-ref := $ref-set/@other-ref
    let $deref := if ($other-ref) then c:get-ref($ref) else $ref/ancestor-or-self::ref
    let $show-notes := $ref-set/@show-notes
    let $show-mark := $ref-set/@show-mark
    let $show-lang := $ref-set/@show-lang
    let $show-gloss := $ref-set/@gloss
    let $show-rule := $ref-set/@show-rule
    let $show-value := $ref-set/@v

    let $notes := $ref[$show-notes]/string()
    return
    if ($deref) then
    <span>{c:print-source-link($deref)}{
        let $do-print-lang := $show-lang != $deref/@l return
        if ($show-rule) then (
            text {' ('}, 
            let $deriv-ref := c:get-ref($deref/deriv[1])
            return c:print-word($deriv-ref, local:print-word-control($do-print-lang)), 
            text {' &gt; '},
            c:print-wordlet($deref/deriv[1]/@i1, ' &gt; '),
            c:print-wordlet($deref/deriv[1]/@i2, ' &gt; '),
            c:print-wordlet($deref/deriv[1]/@i3, ' &gt; '),
            c:print-word($deref, local:print-word-control($do-print-lang)), 
            if ($deref/deriv[1]/string()) then ('; ', xdb:html($deref/deriv[1])) else (), 
            text {')'}
        ) else 
        if (not($show-value) and not($show-mark != $deref/@mark) and not($show-lang != $deref/@l)) then () else 
        let $do-print-word :=
            (not(local:is-match($deref/@v, $show-value) and not($deref/@mark))) or
            ($show-mark and $deref/@mark)
        let $do-print-gloss := $deref/@gloss != $show-gloss
        let $do-print-notes := $notes != ''
        return if ($do-print-word or $do-print-gloss or $do-print-notes) then (
            text {' ('}, 
            if ($do-print-word) then c:print-word($deref, local:print-word-control($do-print-lang)) else (), 
            if ($do-print-word and $do-print-gloss) then text{' '} else (),
            if ($do-print-gloss) then text {c:print-gloss-no-space($deref)} else (), 
            if ($do-print-notes and ($do-print-gloss or $do-print-word)) then text{', '} else (),
            if ($do-print-notes) then xdb:html($notes) else (),
            text {')'}
        ) else ()
    }</span> else ()
};

declare function local:print-ref-set($refs as element()*, $ref-set as element()) as node()* { (
    if ($refs) then text{' ✧&#160;'} else (),
    let $group := <div>{for $ref in $refs return local:print-ref($ref, $ref-set)}</div>
    for $item in $group/*
    return ($item/node(), if ($item/following-sibling::*) then text {'; '} else ())
) };

declare function local:print-word-control($show-lang as xs:boolean, $show-link as xs:string?) as element() {
    <print-word> { (
        if ($show-lang) then attribute show-lang {'y'} else (),
        if ($show-link) then attribute show-link {$show-link} else ()
    ) } </print-word>
};

declare function local:print-word-control($show-lang as xs:boolean) as element() {
    local:print-word-control($show-lang, ())
};

declare function local:ref-sig($ref as element()*, $ref-name) as xs:string {
    let $att-values :=
        <element>{$ref/@*[not(name()='source')][$ref-name != 'element' or not(name()='gloss')]/string()}:{
            $ref/*[name()=$ref-name]/@*[not(name()='source') and not(name()='v')]/string()}:{
            $ref/*[name()=$ref-name]/string()}</element>
    return $att-values/string()
};

declare function local:change-sig($ref as element()*, $ref-name) as xs:string {
    let $change-element := $ref/*[name()=$ref-name]
    let $change := $change-element
    let $att-values :=
        <element>{$ref-name}:{$ref/@v/string()}:{$ref/@gloss/string()}:{
        $change-element/text()
        }:{$change/@v/string()}:{$ref/@change/string()}</element>
    return $att-values/string()
};

declare function local:element-sig($ref as element()*) as xs:string {
    let $element := $ref/c:get-ref($ref)/..
    let $att-values :=
        <element>
            {$element/@*/string()}:{name($ref)}:{
            $ref/@*[not(name()='source') and not(name()='v')]/string()}:{
            $ref/string()}</element>
    return $att-values/string()
};

declare function local:print-element-in($word as element()?) as node()* {
    let $element-in-refs := $word/ref[c:get-ref(.)]/xdb:key($word, 'element-in-ref', @source)[c:get-ref(.)]
    let $element-ins := xdb:key($word, 'element-in', $word/@v)[element[@v = $word/@v]/@l = c:get-lang($word) or c:get-lang(.) = c:get-lang($word)]
    let $unmatched := $element-in-refs/..[not(@v = $element-ins/@v)]
    return (
        <ul> { (
        for $element-in in $element-ins
        let $control := <ref-set>{if (c:get-speech($element-in) = 'phrase' or c:get-speech($element-in) = 'text') then () else $element-in/@v}</ref-set>
        order by $element-in/@l, c:normalize-for-sort($element-in/@v)
        return
            <li class="c-bullet">
                ⇒ {c:print-word($element-in, <print-word show-lang="y" show-link="y"/>)}
                {c:print-gloss($element-in)}
                {local:print-ref-set($element-in-refs[c:get-ref(.)[../@v = $element-in/@v]], $control)}
            </li>,
        for $element-in in $unmatched
        let $control := <ref-set>{if (c:get-speech($element-in) = 'phrase' or c:get-speech($element-in) = 'text') then () else $element-in/@v}</ref-set>
        order by $element-in/@l, c:normalize-for-sort($element-in/@v)
        return
            <li class="c-bullet">
                ⇒ {c:print-word($element-in, <print-word show-lang="y" show-link="y"/>)}
                {c:print-gloss($element-in)}
                {local:print-ref-set($element-in-refs[c:get-ref(.)[../@v = $element-in/@v]], $control)}
            </li>
        ) } </ul>
    )
};

declare function local:print-derivations($word as element()?, $priors as element()*) as node()* {
    let $deriv-refs := $word/ref[c:get-ref(.)]/deriv[c:get-ref(.)]
    let $derivs := $deriv-refs/c:get-ref(.)/.. | $word/deriv/c:get-word(.)
    return (
        for $deriv in $derivs[not(xdb:hashcode(.) = $priors/xdb:hashcode(.))]
        let $deriv-link := $word/deriv[xdb:hashcode(c:get-word(.)) = xdb:hashcode($deriv)]
        let $deriv-mark := $deriv-link/@mark/string()
        let $refs := $deriv-refs[xdb:key($word, 'ref', @source)[../@v = $deriv/@v]]
        let $value := $deriv/@v/string()
        return
            <li class="c-bullet"> &lt; 
                {c:print-word($deriv, <print-word show-lang="y" show-link="y"/>)}
                {$deriv-mark}
                {c:print-gloss($deriv)}
                {local:print-ref-set($refs, <ref-set v="{$value}" other-ref="y"/>)}
                <ul>{(
                    for $ref in $refs[@i1 or . != ''] return
                    <li style="list-style-type:none; text-indent: -1em;">{(
                        ' &lt; ',
                        c:print-wordlet($ref/@i3, ' &lt; '),
                        c:print-wordlet($ref/@i2, ' &lt; '),
                        c:print-wordlet($ref/@i1, ' &lt; '),
                        <i>{$ref/@v/string()}</i>,
                        if ($ref != '') then (', ', xdb:html($ref/string())) else (),
                        local:print-ref-set($ref, <ref-set other-ref="y"/>)
                    )}</li>,
                    if (xdb:hashcode($word) = xdb:hashcode($deriv)) then () else local:print-derivations($deriv, ($priors, $word)))
                }</ul>
            </li>
    )
};

declare function local:print-derivatives($word as element()?) as node()* {
    if (c:get-speech($word) = 'phoneme') then () else
    local:print-derivatives($word, true(), ())
};

declare function local:print-derivatives($word as element()?, $top-level as xs:boolean, $priors as element()*) as node()* {
    let $is-root := c:is-root($word)
    let $deriv-only := ($top-level and not($is-root)) or c:get-speech($word) = 'phoneme'
    let $deriv-to-refs := $word/ref[c:get-ref(.)]/xdb:key($word, 'deriv-to-ref', @source)[c:get-ref(.)]
    let $word-derivs := xdb:key($word, 'deriv-to', $word/@v)[deriv/c:get-word(.)/xdb:hashcode(.) = $word/xdb:hashcode(.)]
    let $deriv-tos := $deriv-to-refs/.. | $word-derivs
    let $element-in-refs := $word/ref[c:get-ref(.)]/xdb:key($word, 'element-in-ref', @source)[c:get-ref(.)]
    let $word-elements := xdb:key($word, 'element-in', $word/@v)
        [element/c:get-word(.)/xdb:hashcode(.) = $word/xdb:hashcode(.)]
    let $element-ins := if ($deriv-only) then () else $element-in-refs/.. | $word-elements
    return (
        if ($top-level and ($deriv-tos or $element-ins)) then <p><u>Derivatives</u></p> else (),
        <ul> { (
        if (not($top-level) and not($deriv-tos) and (count($element-ins) gt 3)) then
            <li>⇒ {count($element-ins)} compounds</li>
        else
        let $child-derivs := $deriv-tos[not(c:get-speech(.) = 'phrase' or c:get-speech(.) = 'text')] |
            $element-ins[not(c:get-speech(.) = 'phrase' or c:get-speech(.) = 'text')][not(xdb:hashcode(.) = $deriv-tos/xdb:hashcode(.))]
        for $deriv-to in $child-derivs
        order by c:get-lang($deriv-to), c:normalize-for-sort($deriv-to/@v)
        return
            <li class="c-bullet">
                {$word/derivatives/@no-roots}
                {if (xdb:hashcode($deriv-to) = $deriv-tos/xdb:hashcode(.)) then '&gt; ' else '⇒ '}
                {c:print-word($deriv-to, <print-word show-lang="y" show-link="y"/>)}
                {c:print-gloss($deriv-to)}
                {local:print-ref-set(($deriv-to-refs|$element-in-refs)[c:get-ref(.)[xdb:hashcode(..) = xdb:hashcode($deriv-to)]], <ref-set/>)}
                {if (xdb:hashcode($word) = xdb:hashcode($deriv-to)) then ()
                else if ($word/derivatives/@no-roots and c:is-root($deriv-to)) then ()
                else
                let $print-derivatives := local:print-derivatives($deriv-to, false(), ($priors, $child-derivs)) return
                if (string($print-derivatives) != '' and not(contains(string($print-derivatives), ' compounds')) and $priors[xdb:hashcode(.) = xdb:hashcode($deriv-to)]) then 
                    <ul><li>⇒ [see above]</li></ul>
                else
                $print-derivatives
            } </li>
        ) } </ul>
    )
};

declare function local:print-inflections($ref as element()?, $inflections as xs:string) as node()* {
    let $inflect-list := tokenize($inflections, ' ')
    let $word := $ref/ancestor-or-self::word[1]
    for $inflection at $pos in $inflect-list
    let $inflect-word := xdb:key($word, 'inflect-table', $inflection)
        [not(@speech) or @speech=c:get-speech($word)]/
        ..[c:get-lang(.) = c:get-lang($word)]
    let $link := if ($inflect-word) then concat('../words/word-', xdb:hashcode($inflect-word), '.html') else () 
    return
    if ($inflect-word)
    then (<a href="{$link}">{$inflection}</a>, if ($pos = count($inflect-list)) then () else text {' '})
    else text { ($inflection), if ($pos = count($inflect-list)) then () else ' ' }
};

declare function local:print-examples($ref as element()?) as node()* {(
    if ($ref/example) then text{' for example: '} else (),
    for $example in $ref/example
    let $example-refs := xdb:key($ref, 'ref', $example/@source)
    let $example-ref := $example-refs[1]
    let $show-lang := c:other-lang($ref, $example-ref)
    return (
        if ($example/preceding-sibling::example) then text {', '} else (),
        c:print-word($example-ref, local:print-word-control($show-lang, 'parent')),
        if (not(count($example-refs)=1)) then text {' [ERROR:MISMATCH] '} else (),
        if (not($example/@t)) then c:print-gloss($example-ref) else (),
        if (not($example/@t='transform')) then () else
            let $example-transform-refs := xdb:key($example-ref, 'ref', $example-ref/transform/@source)
            let $example-transform-ref := $example-transform-refs[1]
            let $show-transform-lang := c:other-lang($example-ref, $example-transform-ref)
            return (
                text {' ← '},
                if (not(count($example-transform-refs)=1)) then text {' [ERROR:MISMATCH] '} else (),
                c:print-word($example-transform-ref, local:print-word-control($show-transform-lang))
            ),
        if (not($example/@t='inflect')) then () else
            let $example-inflect-refs := xdb:key($example-ref, 'ref', $example-ref/inflect/@source)
            let $example-inflect-ref := $example-inflect-refs[1]
            let $show-inflect-lang := c:other-lang($example-ref, $example-inflect-ref)
            return (
                text {' ← '},
                if (not(count($example-inflect-refs)=1)) then text {' [ERROR:MISMATCH] '} else (),
                c:print-word($example-inflect-ref, local:print-word-control($show-inflect-lang))
            ),
        if (not($example/@t[starts-with(., 'deriv')])) then () else (
            if ($example-ref/deriv[@source]) then text {' < '} else (),
            c:print-wordlet($example-ref/deriv[1]/@i3, ' &lt; '),
            c:print-wordlet($example-ref/deriv[1]/@i2, ' &lt; '),
            c:print-wordlet($example-ref/deriv[1]/@i1, ' &lt; '),
            for $example-deriv in $example-ref/deriv[@source]
                let $example-deriv-v := $example-deriv/@v
                let $example-deriv-source := $example-deriv/@source/string()
                let $example-deriv-refs := xdb:key($example-ref, 'ref', $example-deriv-source)
                let $example-deriv-ref := $example-deriv-refs[@v=$example-deriv-v][1]
                let $show-deriv-lang := c:other-lang($example-ref, $example-deriv-ref)
            return (
                c:print-word($example-deriv-ref, local:print-word-control($show-deriv-lang, 'parent')),
                if ($example-deriv/following-sibling::deriv) then text {'/'} else ()
            ),
            for $example-deriv in $example-ref/deriv[@from]
            return (
                <span> [&lt; {c:print-word($example-ref/.., <print-word show-link='y'/>)}]</span>
            )
        )
    )
)};

declare function local:print-matching-refs($value as xs:string, $variation-refs as element()*) as element() {
    let $matching-refs := for $i in $variation-refs[c:normalize-for-match(@v)=$value] order by translate($i/@mark, '-', '→') return $i
    return
    <li>{c:print-word($matching-refs[1], <print-word style="bold"/>)}
    {local:print-ref-set($matching-refs,
        <ref-set show-mark="{$matching-refs[1]/@mark}" show-lang="{c:get-lang($matching-refs[1]/..)}"/>)}</li>
};

declare variable $pubmode external;
declare variable $code external;
declare variable $words := xdb:key(/*, 'word-code', $code);
declare variable $l := c:get-lang($words[1]);
declare variable $lang := //language[@id=$l]/@name/string();

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang} : {$words[1]/@v/string()}</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />

<script src="../../js/glaemscribe.min.js"></script>
<script src="../../js/tengwar_ds.cst.js"></script>
<script src="../../js/tengwar_ds_eldamar.cst.js"></script>
<script src="../../js/quenya.glaem.js"></script>
<script src="../../js/sindarin-beleriand.glaem.js"></script>
<script src="../../js/sindarin-classical.glaem.js"></script>
<script src="../../js/transcribe.js"></script>

<style>
li ul li {{list-style-type:none}}
</style>
</head>
<body>
<table class="nav-table">
<tr>
<td>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$l}.html">{$lang}</a>] »
[{
if (ends-with(c:get-speech($words[1]), '-name')) then    
    <a href="../name-indexes/names-{$l}.html">{$lang} Names</a>
else if (c:get-speech($words[1]) = 'phrase' or c:get-speech($words[1]) = 'text') then    
    <a href="../phrase-indexes/phrases-{$l}.html">{$lang} Phrases</a>
else if (c:get-speech($words[1]) = 'grammar') then    
    <a href="../grammar-indexes/grammars-{$l}.html">{$lang} Grammar</a>
else if (c:get-speech($words[1]) = 'root') then    
    <a href="../root-indexes/roots-{$l}.html">{$lang} Roots</a>
else if (starts-with(c:get-speech($words[1]), 'phone')) then    
    <a href="../phonetic-indexes/phonetics-{$l}.html">{$lang} Phonetics</a>
else
    <a href="../word-indexes/words-{$l}.html">{$lang} Words</a>
}]
</td>
<td align="right"> {
let $lang := $words[1]/ancestor-or-self::*[@l][1]/@l/string()
let $base-word := $words[1]/ancestor-or-self::*[@l=$lang][last()]
let $base-word-speech := c:get-speech($base-word)
let $base-word-set := xdb:key($words[1], 'language', $lang)
let $word-set := 
    if (ends-with($base-word-speech, '-name')) then    
        $base-word-set[ends-with(c:get-speech(.), '-name')]
    else if ($base-word-speech = 'phrase' or $base-word-speech = 'text') then    
        $base-word-set[c:get-speech(.)='phrase' or c:get-speech(.)='text']
    else if ($base-word-speech = 'grammar') then    
        $base-word-set[c:get-speech(.)='grammar']
    else if ($base-word-speech = 'phonetic-group') then    
        $base-word-set[c:get-speech(.)='phonetic-group']
    else if ($base-word-speech = 'phonetic-rule') then    
        $base-word-set[c:get-speech(.)='phonetic-rule']
    else if ($base-word-speech = 'phoneme') then    
        $base-word-set[c:get-speech(.)='phoneme']
    else if ($base-word-speech = 'root') then    
        $base-word-set[c:get-speech(.)='root']
    else
        $base-word-set
            [not(ends-with(c:get-speech(.), '-name'))]
            [not(c:get-speech(.)='phrase' or c:get-speech(.)='text')]
            [not(starts-with(c:get-speech(.), 'phone'))]
            [not(c:get-speech(.)='grammar')]
            [not(c:get-speech(.)='root')]
let $sorted-word-set :=
    <group> {
        for $item in $word-set
        order by $item/@order, c:normalize-for-sort($item/@v)
        return
        <word l="{c:get-lang($item)}" v="{$item/@v}"> {
            if (xdb:hashcode($item) = xdb:hashcode($words[1])) then 'match' else ()
        } </word>
    } </group>
let $match-in-word-set := $sorted-word-set/*[text()='match'][1]
let $preceding-word := $match-in-word-set/preceding-sibling::*[1]
let $following-word := $match-in-word-set/following-sibling::*[1]
let $parent := $words[1]/ancestor::word[not(see)][1]
return (
    if (not($parent)) then '' else (' [↑', c:print-word($parent, <print-word show-lang="y" show-link="y"/>), ']'),
    if ($preceding-word) then (' [', <a href="{concat('../words/word-', xdb:hashcode($preceding-word), '.html')}">&lt; Previous</a>, ']') else (),
    if ($following-word) then (' [', <a href="{concat('../words/word-', xdb:hashcode($following-word), '.html')}">Next &gt;</a>, ']') else (),
    ('[', <a href="../search/search.html">Search</a>, ']')
) } </td>
</tr>
</table>
{
for $word in $words | (if ($words/see) then () else $words//word[not(see)])
let $valid-refs := $word/ref[c:get-ref(.)]
let $alt-lang := c:alt-lang($word)
return (
<hr/>,
<div style="margin-left: {3 * (if ($word/see) then 0 else
                               count($word/ancestor::*[name()='word' and not(see)]) -
                               count($words[name()='word' and not(see)][1]/ancestor::*[name()='word' and not(see)]))}em"> { (
<p>
    { if ($alt-lang and c:is-primitive($word)) then concat('[', substring($alt-lang, 1, 1), ']') else () }
    { if (c:is-primitive($word)) then () else c:print-lang($word) }
    { if ($alt-lang and not(c:is-primitive($word))) then concat('[', $alt-lang, '] ') else () }
    {if (xdb:hashcode($word) = xdb:hashcode($words[1]))
        then c:print-word($word, <print-word style="bold"> {
                                     if (c:is-primitive($word)) then attribute show-lang {'y'} else ()
                                 } </print-word>)
        else c:print-word($word, <print-word style="bold" show-link="y"> {
                                     if (c:is-primitive($word)) then attribute show-lang {'y'} else ()
                                 } </print-word>)}
    {if ($word/@orthography) then concat(' ‹', $word/@orthography/string(), '›') else ()}
    {if ($word/@tengwa) then concat(' (tengwa ', $word/@tengwa/string(), ')') else ()}
    {if ($word/@stem) then <span> (<b>{$word/@stem/string()}</b>)</span> else ()}
    {if ($word/@tengwar) then <span> [<b>{$word/@tengwar/string()}</b>]</span> else ()}
    { if (($word/@l = 's' or $word/@l = 'q') and
         not($word/@speech = 'grammar' or $word/@speech = 'text' or contains($word/@speech, 'phone')) and
         not($word/@l='q' and starts-with($word/@v, '-d'))
        )
        then (', ',
            <span class="transcribe"
                data-value="{
                    if ($word/@tengwar='ñ') then
                        translate($word/@v/lower-case(.), 'n', 'ñ') 
                    else if ($word/@tengwar='þ') then
                        translate($word/@v/lower-case(.), 's', 'þ') 
                    else $word/@v/lower-case(.)
                }" data-lang="{$word/@l}"></span>
        , ' ') else ()}
    {c:print-speech($word)}
    {if ($word/class/@form) then (' (', local:print-inflections($word, normalize-space(concat($word/class/@form, ' ', $word/class/@variant))), ') ') else ()}
    {c:print-gloss($word)}
    {let $rule := if ($word/@rule) then $word else $word/rule return
    if ($rule) then concat('; [', $rule/@from, '] &gt; [', $rule/@rule, ']') else ()}
    {if ($word/see)
        then (' see ', c:print-word(c:get-word($word/see), <print-word style="bold" show-lang="y" show-link="y"/>))
        else ()}
</p>,

let $texts-in := xdb:key($word, 'element-in', $word/@v)[@speech='text'][@l=$word/@l]
return if (not($texts-in)) then () else
    <blockquote> { if (not($texts-in)) then () else (
            for $text-in in $texts-in
            let $text-element := $text-in/element[@v=$word/@v]
            let $previous-phrase := $text-element/preceding-sibling::element[1]
            let $next-phrase := $text-element/following-sibling::element[1]
            return
            <p>
                {if (not($previous-phrase)) then () else ('[&lt; ', 
                    <a href='word-{xdb:hashcode(c:get-word($previous-phrase))}.html'>Previous Phrase</a>,
                '] ')}
                {c:print-word($text-in, <print-word style="italic" show-link="y"/>)}
                {if (not($next-phrase)) then () else (' [', 
                    <a href='word-{xdb:hashcode(c:get-word($next-phrase))}.html'>Next Phrase</a>,
                ' &gt;]')}
            </p>,
            <hr/>
        ) }
    </blockquote>,

if ($word/see-notes) then 
   <blockquote>
       See {c:print-word(c:get-word($word/see-notes), 
       <print-word style="italic" show-lang="y" show-link="y"/>)} for discussion.
   </blockquote>
else (),

for $note in $word/notes | $word/inflect-table[not(@hide)]
let $see-further := $note/following-sibling::*[1][name()='see-further']
let $see-also := $note/following-sibling::*[1][name()='see-also']/c:get-word(.)
return if ($note/self::notes)
then
    <blockquote>
        {xdb:html($note/node())}
        {if ($see-further) then (
            <p>See {c:print-word(c:get-word($see-further), 
            <print-word style="italic" show-lang="y" show-link="y"/>)} for further discussion.</p>
        ) else ()}
        {if ($see-also) then (
            <p>See also {c:print-word($see-also, 
            <print-word style="italic" show-lang="y" show-link="y"/>)} {c:print-gloss($see-also)}.</p>
        ) else ()}
    </blockquote>
else <center><table> {
let $inflect-display :=
    if ($note/@l/string())
    then <print-word show-link="parent" show-lang='y'/>
    else <print-word show-link="parent"/>
for $form in if ($note/form) then $note/form/@form else $note/@form
return (
<tr><th colspan="10">Examples ({string($form)})</th></tr>,
let $key := $note/@key/string()
let $speech := $note/@speech/string()
let $exclude := $form/../@exclude
let $exclude2 := $form/../@exclude2
let $from := $note/@from
let $refs := xdb:matchAllKeys($word, $key, $form)
    [c:get-lang(.)=c:get-langs($note)]
    [not($speech) or c:get-speech(.) = $speech]
    [not($exclude) or not(contains(*[name()=$from]/@form, $exclude) or contains(*[name()=$from]/@variant, $exclude))]
    [not($exclude2) or not(contains(*[name()=$from]/@form, $exclude2) or contains(*[name()=$from]/@variant, $exclude2))]
let $has-glosses := ($note/@show-glosses | $refs[c:get-gloss(.)]) and not($note/@show-glosses = 'false')
let $omit := if ($note/@omit) then $note/@omit else if ($note/@form) then $note/@form else $form
let $has-variants := $note/@show-variants | $refs/*[name()=$from][1][normalize-space(replace(replace(concat(' ', @form, ' ', @variant, ' '), ' ', '  '), concat(' ', replace($omit, ' ', '  '), ' '), '')) != '']
let $has-sources := $refs/@source
let $show-form := $note/@show-form
for $ref in $refs
let $variants := $ref/*[name()=$from]/normalize-space(replace(replace(concat(' ', @form, ' ', @variant, ' '), ' ', '  '), concat(' ', replace($omit, ' ', '  '), ' '), ''))
let $from-source := $ref/*[name()=$from][1]
let $ref-form := if ($show-form) then $ref/ancestor-or-self::word[1]/*[name()=$show-form]/@form/string() else ()
order by $ref-form, $variants
return
<tr> {(
    <td>{c:print-word($ref, $inflect-display)}</td>,
    if (not($has-glosses)) then () else 
    <td>{c:print-gloss($ref)}</td>,
    if (not($note/@from)) then () else
    <td>{
    let $from-ref := if ($from-source/@source) then c:get-ref($from-source) else $ref/..
    return
    if ($from-source/@source) then
        <span>
            ←&#160;{c:print-word($from-ref, <print-word/>)}
            {if ($from-ref/inflect/@form) then concat(' (', $from-ref/inflect/@form, ')') else () }
        </span>
    else
        <span>[←&#160;{c:print-word($from-ref, <print-word/>)}]</span>
    }</td>,
    if ($show-form) then <td>{$ref-form}</td> else (),
    if (not($has-variants)) then () else 
    <td> { local:print-inflections($ref, $variants) } </td>,
    if (not($note/@show-element-of)) then () else 
    let $element-ins := xdb:key($ref, 'element-in-ref', $ref/@source) return
    <td> { (
        if ($element-ins) then '⇒ ' else (),
        for $element-in at $pos in $element-ins return (
            c:print-word($element-in, <print-word show-link="parent"/>), 
            if ($pos lt count($element-ins)) then ', ' else ()
        )
    ) } </td>,
    if (not($has-sources) or not($ref/@source)) then () else 
    <td>{local:print-ref-set($ref, <ref-set/>)}</td>
)} </tr>
) } </table></center>,

if (count($valid-refs) = 1 and count($valid-refs[not(inflect) or c:is-root($word)]) = 1) then (
let $ref := $valid-refs[1] return
<p>
    <u>Reference</u>
    {if ($pubmode = 'true') then
        (' ✧ ', $ref/@source/replace(replace(substring-before(concat(., '.'), '.'), '/0', '/'), '/0', '/'))
        else local:print-ref-set($ref, <ref-set/>)}
    {if ($ref/@v != $word/@v or $ref/@l != $word/@l or ($ref/notes and $pubmode != 'true') or $ref/example or $ref/@gloss) then ' ✧ ' else ()}
    {
        if ($ref/@l != $word/@l) then c:print-word($ref, <print-word style="bold" show-lang="y"/>) 
        else if ($ref/@v != $word/@v) then c:print-word($ref, <print-word style="bold"/>) 
        else ()
    }
    {c:print-gloss($ref)}
    {if ((c:get-gloss($ref) != '' or $ref/@v != $word/@v) and (($ref/notes or $ref/example) and $pubmode != 'true')) then ': ' else () }
    {if ($pubmode != 'true') then xdb:html($ref/notes/node()) else ()}
    {if ($ref/notes and $ref/example and $pubmode != 'true') then text{'; '} else () }
    {local:print-examples($ref)}
</p>
) else (
(: References :)
let $base-refs := $valid-refs
let $short-refs := distinct-values($base-refs/@source/replace(replace(substring-before(concat(., '.'), '.'), '/0', '/'), '/0', '/'))
return
if ($base-refs) then (
<p>
    <u>References</u>
    {if ($pubmode = 'true' or count($short-refs) lt count($base-refs))
     then (' ✧ ', 
        let $normalized-short-refs := <div> {
            for $short-ref in $short-refs return
            <ref src="{substring-before($short-ref, '/')}" page="{replace(substring-after($short-ref, '/'), ' ', '&#160;')}"/>
        } </div>
        let $short-ref-sources := distinct-values($normalized-short-refs/ref/@src/string())
        let $short-ref-by-sources := for $short-ref-source in $short-ref-sources
            return <ref src="{$short-ref-source}" pages="{
                for $ref in $normalized-short-refs/ref[@src = $short-ref-source]
                return
                    if($ref/@page/number() and
                        ($ref/@page = $ref/following-sibling::ref[@src = $short-ref-source][1]/@page - 1) and 
                        ($ref/@page = $ref/preceding-sibling::ref[@src = $short-ref-source][1]/@page + 1))
                    then ()
                    else if($ref/@page/number() and 
                        ($ref/@page = $ref/following-sibling::ref[@src = $short-ref-source][1]/@page - 1))
                    then concat($ref/@page, '-')
                    else $ref/@page
            }"/>
        let $ref-list := replace(concat(string-join($short-ref-by-sources/concat(./@src, '/', 
            replace(replace(@pages, '- ', '-'), ' ', ', ')
        ), '; '), ';'), concat('I/', $word/@v, ';'), 'I;')
        return substring($ref-list, 1, string-length($ref-list) - 1)
     )
     else local:print-ref-set($base-refs, <ref-set/>)}
</p>
) else (),

(: Glosses :)
let $gloss-refs := $valid-refs[not(inflect) or c:is-root($word)][not(correction)][@gloss] return
if ($gloss-refs) then (
    (: [@gloss != c:get-gloss($word)]; TODO - Mark deletions :)
    <p><u>Glosses</u></p>,
    <ul> {
    let $glosses := distinct-values($gloss-refs/@gloss/lower-case(.))
    for $gloss in $glosses
    let $refs := for $i in $gloss-refs[lower-case(@gloss)=$gloss] order by translate($i/@mark, '-', '→') return $i
    let $value := $word/@v/string()
    let $gloss-css := c:derive-css($refs[1])
    order by $gloss
    return
        <li>
           { if ($gloss-css) then <span class="{$gloss-css}">{c:print-gloss($refs[1])}</span> else c:print-gloss($refs[1])}
           {local:print-ref-set($refs, <ref-set v="{$value}"/>)}
        </li>
    } </ul>
) else (),

(: Variations :)
let $base-variation-refs := $valid-refs[not(inflect) or c:is-root($word)][not(correction)][not(c:is-rule(.))]
let $variation-refs := $base-variation-refs[not(local:is-match(@v, $word/@v))]
let $non-variation-refs := $base-variation-refs[local:is-match(@v, $word/@v)]
return
if ($variation-refs or $non-variation-refs[@l] or ($base-variation-refs and $valid-refs[inflect])) then (
<p><u>Variations</u></p>,
<ul> { (
    if (not($non-variation-refs)) then () else
    for $value in distinct-values($non-variation-refs/@v/c:normalize-for-match(.))
    return local:print-matching-refs($value, $non-variation-refs),
    for $value in distinct-values($variation-refs/@v/c:normalize-for-match(.))
    return local:print-matching-refs($value, $variation-refs)
) } </ul>
) else (),

(: Notes :)
let $note-refs := $valid-refs[notes or example] return
if ($note-refs and $pubmode != 'true') then (
    <p><u>Notes</u></p>,
    <ul> {
    for $ref in $note-refs return
    <li>
        {if (c:get-speech($word) = 'phonetic-rule') then () else c:print-word($ref, <print-word style="bold"/>)}
        {if (c:get-speech($word) = 'phonetic-rule') then () else if (c:print-gloss($ref)) then (' ', c:print-gloss-no-space($ref), ': ') else ': ' }
        {xdb:html($ref/notes/node())}
        {if ($ref/notes and $ref/example) then text{'; '} else () }
        {local:print-examples($ref)}
        {local:print-ref-set($ref, <ref-set/>)}
    </li>
    } </ul>
) else ()
) (: count($valid-refs) = 1 :),

(: Order :)
let $before-to := $word[before]
let $before-from :=
    $word/xdb:key(., 'before-to', @v)[before/c:get-word(.)/@l = $word/@l]
let $before-print := (
    <table> { (
    for $ref in $before-from
    let $ref-before := $ref/before[@v = $word/@v]
    let $show-link := 'y'
    let $show-lang := c:get-lang($ref) != c:get-lang($word)
    let $control := local:print-word-control($show-lang, $show-link)
    order by c:normalize-for-sort($ref/@order)
    return
        <tr>
            <td> { if ($ref/@order gt $word/@order) then '[ERROR] ' else () } After</td>
            <td> { $ref/@order/string() } </td>
            <td> { c:print-word($ref, $control) } </td>
            <td align="center"><nobr> { 
                if ($ref-before/order-example) then () else xdb:html($ref-before/node()[1]/string()),
                for $order-example in $ref-before/order-example
                return (
                    if ($order-example/c:get-ref(.)/deriv) then (
                        local:print-deriv($order-example/c:get-ref(.)/deriv),
                        if ($order-example/node()[1]/string()) then '; ' else (),
                        xdb:html($order-example/node()[1]/string()),
                        if ($order-example/following-sibling::order-example) then <br/> else ()
                    ) else (
                        c:print-word($order-example/c:get-ref(.), <print-word show-link="parent" show-lang="y"/>)
                    )
                ) 
            } </nobr></td>
            <td> { 
                for $order-example in $ref-before/order-example
                return (
                    c:print-source($order-example),
                    if ($order-example/following-sibling::order-example) then <br/> else ()
                ) 
            } </td>
        </tr>,
    for $ref-before in $before-to/before
    let $ref := $ref-before/..
    let $all-before := $ref-before/c:get-word(.)
    let $before := $all-before[1]
    let $show-link := 'y'
    let $show-lang := c:get-lang($ref) != c:get-lang($before)
    let $control := local:print-word-control($show-lang, $show-link)
    order by c:normalize-for-sort($before/@order)
    return
        <tr>
            <td> { if ($before/@order lt $word/@order) then '[ERROR] ' else if (count($all-before) != 1) then '[ERROR:MISLINK] ' else () } Before</td>
            <td> { $before/@order/string() } </td>
            <td> { c:print-word($before, $control) } </td>
            <td align="center"><nobr> { 
                if ($ref-before/order-example) then () else xdb:html($ref-before/node()[1]/string()),
                for $order-example in $ref-before/order-example
                return (
                    local:print-deriv($order-example/c:get-ref(.)/deriv),
                    if ($order-example/node()[1]/string()) then '; ' else (),
                    xdb:html($order-example/node()[1]/string()),
                    if ($order-example/following-sibling::order-example) then <br/> else ()
                ) 
            } </nobr></td>
            <td> { 
                for $order-example in $ref-before/order-example
                return (
                    c:print-source($order-example),
                    if ($order-example/following-sibling::order-example) then <br/> else ()
                ) 
            } </td>
        </tr>
    ) } </table>
)
return
if ($before-print/string() != '') then (
    <p><u>Order ({$word/@order/string()})</u></p>,
    $before-print
) else (),

(: Related :)
let $related-to :=
    $valid-refs[related] | $word[related]
let $related-from :=
    ($valid-refs/xdb:key(., 'related-to-ref', @source) |
     $word/xdb:key(., 'related-to', @v)[related/c:get-word(.) = $word])
    [not(xdb:hashcode(ancestor-or-self::word[1]) = xdb:hashcode($word))]
let $related-print := (
    <ul> { (
    for $ref-related in $related-to/related
    let $ref := $ref-related/..
    let $is-ref := ($ref/name()='ref')
    let $all-related := if ($is-ref) then $ref-related/c:get-ref(.) else $ref-related/c:get-word(.)
    let $related := $all-related[1]
    let $show-link := if ($is-ref) then 'parent' else 'y'
    let $show-lang := c:get-lang($ref) != c:get-lang($related)
    let $control := local:print-word-control($show-lang, $show-link)
    order by if ($is-ref) then c:normalize-for-sort($related/../@v) else c:normalize-for-sort($related/@v)
    return
        <li> { (
            if (count($all-related) != 1) then '[ERROR:MISLINK] ' else (),
            if (not($ref-related/node()))
            then (
                c:print-word($related, $control),
                c:print-gloss($related)
            ) else (
                c:print-word($ref, <print-word style="bold"/>),
                c:print-gloss($ref-related/..),
                ' ',
                xdb:html($ref-related/node()/string()),
                ' ',
                c:print-word($related, $control),
                c:print-gloss($related)
            ),
            if ($is-ref) then local:print-ref-set($ref, <ref-set/>) else ()
        ) } </li>,
    for $ref-related in $related-from/related[
        if (../name() = 'ref')
        then c:get-ref(.)/../xdb:hashcode(.) = xdb:hashcode($word) 
        else c:get-word(.)/xdb:hashcode(.) = xdb:hashcode($word)
    ]
    let $ref := $ref-related/..
    let $is-ref := ($ref/name()='ref')
    let $related := if ($is-ref) then $ref-related/c:get-ref(.) else $ref-related/c:get-word(.)
    let $show-link := if ($is-ref and xdb:hashcode($ref/..) = xdb:hashcode($word)) then () else if ($is-ref) then 'parent' else 'y'
    let $show-lang := c:get-lang($ref) != c:get-lang($related)
    let $control := local:print-word-control($show-lang, $show-link)
    order by if ($is-ref) then c:normalize-for-sort($related/../@v) else c:normalize-for-sort($related/@v)
    return
        <li> { (
            c:print-word($ref, $control),
            if (not($ref-related/node()))
            then c:print-gloss($ref)
            else (
                c:print-gloss($ref),
                ' ',
                xdb:html($ref-related/node()/string()),
                ' ',
                c:print-word($related, <print-word style="bold"/>),
                c:print-gloss($related)
            ),
            if ($is-ref) then local:print-ref-set($ref, <ref-set/>) else ()
        ) } </li>
    ) } </ul>
)
return
if ($related-print/string() != '') then (
    <p><u>Related</u></p>,
    $related-print
) else (),

(: Changes :)
let $change-refs := $valid-refs[
                        change/c:get-ref(.) or 
                        correction/c:get-ref(.)
                    ]
return
if ($change-refs) then (
    <p><u>Changes</u></p>,
    <ul> {
    let $change-sigs := distinct-values($change-refs[change]/local:change-sig(., 'change'))
    let $correction-sigs := distinct-values($change-refs[correction]/local:change-sig(., 'correction'))
    for $change-sig in ($change-sigs, $correction-sigs)
    let $refs := $change-refs[
        local:change-sig(., 'change') = $change-sig or 
        local:change-sig(., 'correction') = $change-sig
    ]
    let $ref := $refs[1]
    for $change-item in $ref/change[c:get-ref(.)] | $ref/correction[c:get-ref(.)]
    let $change := $change-item/c:get-ref(.)
    let $show-lang := c:get-lang($ref) != c:get-lang($change)
    let $show-gloss := (not($ref/@gloss = $change/@gloss) or not($change))
    let $is-other-word := if (xdb:isSame($change/.., $word)) then () else 'parent'
    let $indicator := if (name($change-item) = 'change') then ' &gt;&gt; ' else 
         if (name($change-item) = 'correction') then ' »» ' else ()
    return
    <li>
        {c:print-word($ref, local:print-word-control($show-lang))}
        {if ($show-gloss) then c:print-gloss($ref) else ()}
        {$indicator}
        {c:print-wordlet($change-item/@i1, $indicator)}
        {c:print-word($change, local:print-word-control($show-lang, $is-other-word))}
        {if ($show-gloss) then c:print-gloss($change) else ()}
        {if ($ref/correction | $ref/change != '') then '; ' else ()}
        {xdb:html($ref/correction/node() | $ref/change/node())}
        {local:print-ref-set($refs, <ref-set/>)}
    </li>
    } </ul>
) else (),

(: Inflections :)
let $inflect-refs := $valid-refs[inflect[not(@source) or c:get-ref(.)]] return
if ($inflect-refs) then (
    <p><u>Inflections</u></p>,
    <table> {
    let $has-glosses := $inflect-refs/@gloss
    let $has-variants := $inflect-refs/inflect/@variant
    let $inflect-sigs := distinct-values($inflect-refs/local:ref-sig(., 'inflect'))
    for $inflect-sig in $inflect-sigs
    let $refs := $inflect-refs[local:ref-sig(., 'inflect') = $inflect-sig]
    let $ref := $refs[1]
    let $form := $ref/inflect/@form/string()
    let $print-word := if ($ref/@l) then <print-word show-lang="y"/> else <print-word/>
    order by $form, $ref/@v
    return
        <tr>{ (
            <td><i>{c:print-word($ref, $print-word)}</i></td>,
            <td>{ local:print-inflections($word, $form) }</td>,
            if (not($has-variants)) then () else
            <td>{ local:print-inflections($word, string($ref/inflect/@variant)) }</td>,
            if (not($has-glosses)) then () else
            <td>{if ($ref/@gloss) then c:print-gloss($ref) else '&#160;'}</td>,
            <td>{ (
                local:print-ref-set($refs, <ref-set/>),
                if ($ref/inflect/text() != '') then (': ', xdb:html($ref/inflect/text()))
                else ()
            ) }</td>
        )}</tr>
    } </table>
) else (),

(: Elements :)
if (not($word/element) and count($word/ref[element]) = 1) then (
<p><u>Elements</u></p>,
<table> {
let $has-forms := $word/ref/element[@form] | $word/ref/element/c:get-ref(.)/inflect/@form
for $element-ref in $word/ref/element
let $element-deref := c:get-ref($element-ref)
let $element := $element-deref/..
let $form := if ($element-ref/@form) then $element-ref/@form else $element-deref/inflect/@form
let $show-lang := c:get-lang($word) != c:get-lang($element)
let $print-word := local:print-word-control($show-lang, 'y')
let $ref-set :=
    <ref-set>{$element/@v}</ref-set>
return
    <tr> {(
        <td>{c:print-word($element, $print-word)}</td>,
        <td>{c:print-gloss($element)}</td>,
        if ($has-forms) then <td>{local:print-inflections($element, string($form))}</td> else (),
        <td>{(
            local:print-ref-set($element-deref, $ref-set)
        )}</td>
   )} </tr>
} </table>
) else (
let $elements := $word/element
let $element-words := $elements/c:get-word(.)
let $element-refs := $valid-refs/element
let $unmatched-refs := $element-refs[c:get-ref(.)/not(xdb:contains($element-words, ..))]
let $glosses := ($elements/c:get-word(.)/c:get-gloss(.), $unmatched-refs/c:get-ref(.)/c:get-gloss(.))
let $has-forms := $word/element[@form] | $unmatched-refs/c:get-ref(.)/inflect/@form
return (
    if ($elements or $unmatched-refs) then <p><u>Elements</u></p> else (),
    if (not($elements or $unmatched-refs)) then () else
    <table> {(
        let $has-references := $element-refs/c:get-ref(.)
        for $element in $elements
        let $form := $element/@form
        let $element-word := $element/c:get-word(.)
        let $matching-refs := $element-refs[if ($element/@v='?') then () else c:get-ref(.)/xdb:isSame($element-word, ..)]
        let $show-lang := c:get-lang($word) != c:get-lang($element-word)
        let $print-word := local:print-word-control($show-lang, 'y')
        let $ref-set :=
            <ref-set other-ref="y">{$element-word/@v}</ref-set>
        order by $element-word/@order
        return
        <tr> {(
            <td>
                {if ($element/@v='?') then <i>?</i> else c:print-word($element-word, $print-word)}
                {$element/@mark/string()}
            </td>,
            if (count($glosses) gt 0) then <td>{c:print-gloss($element-word)}</td> else (),
            if ($has-forms) then <td>{local:print-inflections($element-word, string($form))}</td> else (),
            if ($has-references) then <td>{(
                local:print-ref-set($matching-refs, $ref-set)
            )}</td> else ()
        )} </tr>,
        if ($elements and $unmatched-refs) then <tr><td colspan="4" align="center"/></tr> else (),
        let $element-sigs := distinct-values($unmatched-refs/local:element-sig(.))
        for $element-sig in $element-sigs
        let $refs := $unmatched-refs[local:element-sig(.) = $element-sig]
        let $element-ref := $refs[1]
        let $element-deref := c:get-ref($element-ref)
        let $element := $element-deref/..
        let $form := if ($element-ref/@form) then $element-ref/@form else $element-deref/inflect/@form
        let $show-lang := c:get-lang($word) != c:get-lang($element)
        let $print-word := local:print-word-control($show-lang, 'y')
        let $ref-set :=
            <ref-set other-ref="y" show-notes="y">{$element/@v}</ref-set>
        return
        <tr> {(
            <td>{c:print-word($element, $print-word)}</td>,
            if (count($glosses) gt 0) then <td>{c:print-gloss($element)}</td> else (),
            if ($has-forms) then <td>{local:print-inflections($element, string($form))}</td> else (),
            <td>{(
                local:print-ref-set($refs, $ref-set)
            )}</td>
        )} </tr>
    )} </table>
)
),

(: Element In :)
let $print-element-in := local:print-element-in($word) return
if ($print-element-in != '' and not(c:is-root($word))) then (
    <p><u>Element In</u></p>,
    local:print-element-in($word)
) else (),

(: Cognates :)
let $cognate-refs := $valid-refs/xdb:allReferenceCognates(.)
let $cognates := $cognate-refs/.. | $word/xdb:allWordCognates(.)
return if (not($cognates)) then () else (
    <p><u>Cognates</u></p>,
    <ul> {
        for $cognate in $cognates
        let $this-cognate-refs := $cognate-refs[xdb:isSame(.., $cognate)]
        let $ref-set := <ref-set>{$cognate/@v}</ref-set>
        order by $cognate/@l
        return if ($cognate/@l = $word/@l) then () else
        <li>
           {c:print-word($cognate, local:print-word-control(true(), 'y'))}
           {c:print-gloss($cognate)}
           {local:print-ref-set($this-cognate-refs, $ref-set)}
        </li> 
    } </ul>
),

(: Derivations :)
let $deriv-refs := if (c:get-speech($word) != 'phoneme') then $valid-refs/deriv[c:get-ref(.)] else ()
let $derivs := $deriv-refs/c:get-ref(.)/.. | $word/deriv/c:get-word(.)
return if ($derivs) then <p><u>Derivations</u></p> else (),
<ul>{if (c:get-speech($word) != 'phoneme') then local:print-derivations($word, ()) else ()}</ul>,

(: Derivatives :)
local:print-derivatives($word),

(: Phonetic Rule Developments :)
let $phonetic-rule-refs := $valid-refs[deriv/rule-example | deriv/rule-start] return
if ($phonetic-rule-refs) then (
    <p><u>Phonetic Developments</u></p>,
    <table> {
    for $phonetic-rule-ref in $phonetic-rule-refs
    let $ref := $phonetic-rule-ref/c:get-ref(.)
    return
        <tr>
            <td>{ (
                c:print-word($ref/deriv[1]/c:get-ref(.), <print-word show-lang="y"/>),
                ' &gt; ',
                c:print-wordlet($ref/deriv[1]/@i1, ' &gt; '),
                c:print-wordlet($ref/deriv[1]/@i2, ' &gt; '),
                c:print-wordlet($ref/deriv[1]/@i3, ' &gt; '),
                c:print-word($phonetic-rule-ref, <print-word/>) 
            ) }</td>
            <td>{ (
                if ($phonetic-rule-ref/deriv[1]/rule-start)
                then concat('[', $phonetic-rule-ref/deriv[1]/rule-start/@stage, ']')
                else concat('[', $phonetic-rule-ref/deriv[1]/rule-example[1]/@from, ']'),
                for $rule in $phonetic-rule-ref/deriv[1]/rule-example
                let $general-rule := 
                    xdb:key(/, 'rule-to', concat($rule/@l, ':', $rule/@rule, ':', $rule/@from))/parent::word
                return (
                    c:print-link-to-word(if ($general-rule) then $general-rule else $rule, ' &gt; '),
                    concat('[', $rule/@stage, ']')
                )
            ) }</td>
            <td>{ local:print-ref-set($phonetic-rule-ref, <ref-set/>) }</td>
        </tr>
    } </table>
) else (),

(: Rules :)
let $from-rule-refs := $valid-refs[@rule]
let $to-rule-refs := $valid-refs/xdb:key(., 'rule-to-ref', @source)
let $rule-refs := $from-rule-refs | $to-rule-refs
return
if ($rule-refs) then (
    <p><u>Phonetic Development</u></p>,
    <table> { (
    for $rule in distinct-values($from-rule-refs[not(@from)]/@rule/string())
    let $refs := $from-rule-refs[not(@from)][@rule = $rule]
    return
        <tr> { (
            <td>{c:print-lang($refs[1]/..)} <i>[no change]</i></td>,
            <td style="border-right: none; text-align: right"><nobr><i>{translate($refs[1]/../@v, '[]', '')}</i></nobr></td>,
            <td style="border-left: none; border-right: none">&lt;</td>,
            <td style="border-left: none"><nobr><i>{translate($refs[1]/../@v, '[]', '')}</i></nobr></td>,
            <td>{ local:print-ref-set($refs, <ref-set show-rule="y"/>) }</td>
        ) } </tr>,
    for $rule-string in distinct-values($from-rule-refs[@from]/concat(@rl, ':', @rule, ':', @from))
    let $refs := $from-rule-refs[concat(@rl, ':', @rule, ':', @from) = $rule-string]
    let $from := $refs[1]/@from
    let $rule := $refs[1]/@rule
    let $general-rule := xdb:key(/, 'rule-to', $rule-string)/parent::word
    order by $general-rule/@order
    return
        <tr> { (
            <td><nobr>{ 
                c:print-word($general-rule[1], <print-word show-lang="y" show-link="y"/>)
            }</nobr></td>,
            <td style="border-right: none; text-align: right"><nobr>{c:print-wordlet($rule, '')}</nobr></td>,
            <td style="border-left: none; border-right: none">{'&lt;'}</td>,
            <td style="border-left: none"><nobr>{c:print-wordlet($from, '')}</nobr></td>,
            <td>{ local:print-ref-set($refs, <ref-set show-rule="y"/>) }</td>
        ) } </tr>,
    for $rule-string in distinct-values($to-rule-refs[@from]/concat(@rl, ':', @rule, ':', @from))
    let $refs := $to-rule-refs[concat(@rl, ':', @rule, ':', @from) = $rule-string]
    let $from := $refs[1]/@from
    let $rule := $refs[1]/@rule
    let $general-rule := xdb:key(/, 'rule-to', $rule-string)/parent::word
    order by c:get-lang($general-rule), $general-rule/@order
    return
        <tr> { (
            <td><nobr>{ 
                c:print-word($general-rule[1], <print-word show-lang="y" show-link="y"/>)
            }</nobr></td>,
            <td style="border-right: none; text-align: right"><nobr>{c:print-wordlet($from, '')}</nobr></td>,
            <td style="border-left: none; border-right: none">&gt;</td>,
            <td style="border-left: none"><nobr>{c:print-wordlet($rule, '')}</nobr></td>,
            <td>{ local:print-ref-set($refs, <ref-set show-rule="y"/>) }</td>
        ) } </tr>
    ) } </table>
) else (),

(: Rule Elements :)
let $rule-element-refs := $word/rule return
if ($rule-element-refs) then (
    <p><u>Phonetic Rule Elements</u></p>,
    <table> {
    for $rule-element in $word/rule
    let $from := $rule-element/@from
    let $rule := $rule-element/@rule
    let $refs := xdb:key($word, 'rule-element-ref', concat(c:get-lang($word), ':', $rule, ':', $from))
    let $deriv-refs := $refs/deriv/c:get-ref(.)
    return
        <tr> { (
            <td style="border-right: none; text-align: right"><nobr>[{$from/string()}]</nobr></td>,
            <td style="border-left: none; border-right: none">{'&gt;'}</td>,
            <td style="border-left: none"><nobr>[{$rule/string()}]</nobr></td>,
            <td>{ local:print-ref-set($refs, <ref-set show-rule="y"/>) }</td>,
            if ($pubmode = 'true') then () else
            <td><nobr>&lt;rule-example l="{$rule-element/@l/string()}"
                rule="{$rule-element/@rule/string()}"
                from="{$rule-element/@from/string()}"
                to="???" /&gt;</nobr></td>
        ) } </tr>
    } </table>
) else (),

(: Phonetic Rule Examples :)
let $rule-example-refs := xdb:key($word, 'rule-example-ref', concat(c:get-lang($word), ':', $word/@v)) |
    $word/rule/xdb:key($word, 'rule-example-ref2', concat(@l, ':', @rule, ':', @from))
return
if ($rule-example-refs) then (
<p><u>Phonetic Rule Examples</u></p>,
<table> {
for $ref in $rule-example-refs
let $deriv := $ref/parent::deriv
let $rule-to := 
    xdb:key(/, 'rule-to', concat($ref/@l, ':', $ref/@rule, ':', $ref/@from))
let $p-delta := xdb:delta($ref/preceding-sibling::*[1]/@stage/string(), $ref/@stage/string())
let $delta :=
    if ($ref/@rule)
    then concat(if ($rule-to/@delta2) then concat('[', $p-delta, '] ') else (), $ref/@from, ' &gt; ', $ref/@rule)
    else concat(xdb:delta($ref/@from/string(), $ref/@stage/string()), ' &gt; ', xdb:delta($ref/@stage/string(), $ref/@from/string()))
order by $delta, c:normalize-for-sort($ref/@stage/string())
return
<tr>
<td style="text-align: center">{
    if ($ref/@rule)
    then $ref/preceding-sibling::*[1]/@stage/string() 
    else $ref/@from/string()
} &gt; {$ref/@stage/string()}</td>
<td style="text-align: center">{$delta}</td>
<td style="text-align: center">{local:print-deriv($deriv)}</td>
<td>{local:print-ref-set($deriv/parent::ref, <ref-set/>)}</td>
</tr>
} </table>
) else ()

(:
,
let $applied-phonetic-rules := $word/ref/deriv/rule-example[xdb:key(., 'lang-word', concat(@l, ':', @v))] return
if ($applied-phonetic-rules) then (
<p><u>Applied Derivational Rules</u></p>,
<ul> {
for $ref in $applied-phonetic-rules return
<li>
{c:print-word($ref/xdb:key(., 'lang-word', concat(@l, ':', @v)), <print-word show-link="y"/>)}
</li>
} </ul>
) else ()
:)

) }
</div>
) }

</body>
</html>
