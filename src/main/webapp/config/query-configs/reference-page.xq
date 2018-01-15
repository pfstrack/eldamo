import module namespace c = "common.xq" at "common.xq";

declare variable $prefix external;
declare variable $pubmode external;

declare function local:strip-exponent($value as xs:string) as xs:string {
    if (contains($value, '^'))
    then substring-before($value, '^')
    else translate($value, '¹²³⁴⁵⁶⁷⁸⁹', '')
};

declare function local:exponent($value as xs:string) as xs:string { (
    if (contains($value, '^')) then
        let $word := substring-before($value, '^')
        let $sup := substring-after($value, '^')
        let $exponent :=
            if ($sup='1') then '¹'
            else if ($sup='2') then '²'
            else if ($sup='3') then '³'
            else if ($sup='4') then '⁴'
            else if ($sup='5') then '⁵'
            else if ($sup='6') then '⁶'
            else if ($sup='7') then '⁷'
            else if ($sup='8') then '⁸'
            else if ($sup='9') then '⁹'
            else ''
        return concat($word, $exponent)
    else $value
) };

declare function local:is-different-page($a as xs:string?, $b as xs:string?) as xs:boolean {
    let $ref := substring-before($a, '/')
    return
       if ($ref = 'Nam') then false()
       else if ($ref = 'Markirya') then false()
       else substring-before($a, '.') != substring-before($b, '.')
};

declare function local:get-lang($ref as element()?) as attribute()? {
    if ($ref/@l) then $ref/@l else $ref/ancestor::*[@l][1]/@l
};

declare function local:is-different-source($a as xs:string?, $b as xs:string?) as xs:boolean {
    substring-before($a, '/') != substring-before($b, '/')
};

declare function local:wordlet($ref as attribute()?, $postfix as xs:string) as node()* {
    if ($ref) then
        let $has-brackets := starts-with($ref, '[') and ends-with($ref, ']')
        let $word-text := if ($has-brackets) then substring-before(substring-after($ref, '['), ']') else string($ref)
        let $start := if ($has-brackets) then text {'['} else ()
        let $end := if ($has-brackets) then text {']'} else ()
        return
            if (starts-with($ref/../../@mark, '-')) then
                (<strike>{($start, <i>{$word-text}</i>, $end)}</strike>, text{$postfix})
            else if (starts-with($ref/../../@mark, '|')) then
                (<u>{($start, <i>{$word-text}</i>, $end)}</u>, text{$postfix})
            else
                ($start, <i>{$word-text}</i>, $end, text{$postfix})
    else ()
};

declare function local:show-word(
        $ref as element()?,
        $show-lang as xs:boolean,
        $show-gloss as element()?,
        $show-base as xs:boolean,
        $show-source as xs:boolean)
        as node()* { (
    if (starts-with($ref/@mark/string(), '-'))
        (: then <strike style="text-decoration: none; background-color : pink">{local:show-word2($ref, $show-lang, $show-gloss, $show-base)}</strike> :)
        then <strike>{local:show-word2($ref, $show-lang, $show-gloss, $show-base)}</strike>
    else if (starts-with($ref/@mark/string(), '|'))
        (: then <u>× {local:show-word2($ref, $show-lang, $show-gloss, $show-base)} ×</u> :)
        then <u>{local:show-word2($ref, $show-lang, $show-gloss, $show-base)}</u>
    else local:show-word2($ref, $show-lang, $show-gloss, $show-base),

    if ($show-source) then text { concat(' (', substring-before(concat($ref/@source, '.'), '.'), ')') } else ()
) };

declare function local:show-word2(
        $ref as element()?,
        $show-lang as xs:boolean,
        $show-gloss as element()?,
        $show-base as xs:boolean)
        as node()* { (

    (: show the lang :)
    let $lang := local:get-lang($ref) return 
    if ($show-lang and not($lang='p' or $lang='mp' or $lang='ep' or $lang='np')) then
        if ($lang='on') then text {'ON. '}
        else if ($lang='ln') then text {'ᴸN. '}
        else if ($lang='lon') then text {'ᴸON. '}
        else if ($lang='en') then text {'ᴱN. '}
        else if ($lang='eon') then text {'ᴱON. '}
        else if ($lang='eoq') then text {'ᴱOQ. '}
        else if ($lang='eilk') then text {'ᴱIlk. '}
        else if ($lang='eq') then text {'ᴱQ. '}
        else if ($lang='mq') then text {'ᴹQ. '}
        else if ($lang='nq') then text {'ᴺQ. '}
        else if ($lang='et') then text {'ᴱT. '}
        else if ($lang='mt') then text {'ᴹT. '}
        else if ($lang='aq') then text {'AQ. '}
        else if ($lang='at') then text {'AT. '}
        else if ($lang='os') then text {'OS. '}
        else if ($lang='edan') then text {'ED. '}
        else if ($lang='norths') then text {'North S. '}
        else if ($lang='ns') then text {'ᴺS. '}
        else if ($lang='bs') then text {'BS. '}
        else if ($lang='pad') then text {'✶Ad. '}
        else text {concat(upper-case(substring($lang, 1, 1)), substring($lang, 2), '. ')}
    else (),

    (: show the mark :)
    text { $ref/translate(@mark, '-|', '') },
    if ($ref/archaic and not(contains($ref/@mark, '†'))) then text { '†' } else (),

    (: show the reference word :)
    (: let $word-text := translate(local:exponent($ref/@v), '`', 'ˈ') return :)
    (: if ($lang='q') then ($start, <b>{$word-text}</b>, $end) :)
    let $has-brackets := starts-with($ref/@v, '[') and ends-with($ref/@v, ']') and not(contains(substring-after($ref/@v, '['), '['))
    let $word-text := if ($has-brackets) then substring-before(substring-after($ref/@v, '['), ']') else string($ref/@v)
    let $start := if ($has-brackets) then text {'['} else ()
    let $end := if ($has-brackets) then text {']'} else ()
    let $speech := $ref/ancestor::*[@speech][1]/@speech
    let $lang := local:get-lang($ref) return (
        if ($lang='mp') then (text {'ᴹ'})
        else if ($lang='ep') then (text {'ᴱ'})
        else if ($lang='np') then (text {'ᴺ'}) else (),
        if ($speech='root') then (text {'√'}, $start, <i>{$word-text}</i>, $end)
        else if ($lang='p' or $lang='mp' or $lang='ep' or $lang='np') then (text {'✶'}, $start, <i>{$word-text}</i>, $end)
        else if ($speech='phrase' or $speech='text') then ($start, <b><i>{$word-text}</i></b>, $end)
        else ($start, <i>{$word-text}</i>, $end)
    ),
    
    (: show the base word :)
    if ($show-base and not($ref/inflect) and not($ref/ancestor::word[starts-with(@speech, 'phone')]) and not($ref/ancestor::word/@speech='phrase') and not($ref/ancestor::word/@speech='text')) then
        let $ref-word := concat('/', normalize-space(local:strip-exponent(translate(lower-case($ref/@v), 'äë-!,.[]', 'ae '))), '/')
        let $base-word := concat('/', normalize-space(local:strip-exponent(translate(lower-case($ref/../@v), 'äë-!,.[]', 'ae '))), '/')
        return
            if (not(contains($base-word, $ref-word)) and
                not(contains($ref-word, $base-word)))
            then 
                (text {' ['}, local:show-word($ref/.., false(), (), false(), false()), text {']'})
            else ()
    else (),
    (:
    if ($show-base and not($ref/inflect)) then
        let $ref-word := concat('/', normalize-space(local:strip-exponent(translate(lower-case($ref/@v), 'äë-!,.[]', 'ae '))), '/')
        let $base-word := concat('/', normalize-space(local:strip-exponent(translate(lower-case($ref/../@v), 'äë-!,.[]', 'ae '))), '/')
        return
            if (not(contains($base-word, $ref-word)) and
                not(contains($ref-word, $base-word)))
            then 
                if (starts-with($ref/../@v, '['))
                then 
                    (text {' ('}, local:show-word($ref/.., false(), (), false(), false()), text {')'})
                else
                    (text {' ['}, local:show-word($ref/.., false(), (), false(), false()), text {']'})
            else ()
    else (),
    :)
    
    (: show the gloss :)
    if ($show-gloss and $ref/@gloss and not($show-gloss/@gloss = $ref/@gloss)) then
        text {concat(' “', $ref/@gloss, '”')}
    else ()
) };

(: show the reference list :)
let $source := /*/source[@prefix=$prefix]
let $name := $source/@name/string()
return
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$name} ({$prefix}) References</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
   [<a href="../../index.html">Home</a>] »
   [<a href="index.html">Reference Index</a>]
</p>
<hr/>
<h1>{$name} ({$prefix})</h1>
{if ($source/cite/text()) then <blockquote>— {xdb:html($source/cite/text())}</blockquote> else ()}
<p>{xdb:html($source/notes/text())}</p>
<hr/>
{
for $ref in //ref[starts-with(@source, concat($prefix, '/'))][not($pubmode = 'true')] (: [starts-with(c:normalize-for-sort(substring-after(@source, '/')), 'l')] :)
let $ref-source := $ref/@source/string()
let $matching-refs := xdb:key($ref, 'ref', $ref-source)
let $word := $ref/ancestor::*[name()='word'][1]
order by c:normalize-for-sort(substring-after($ref-source, '/'))
return
<p>{ (
    <a name="{$ref-source}"></a>,
    text {$ref-source},
    text {' '},
    <a href="{if ($word) then c:to-word-link($word) else 'error.html'}">✧</a>,
    c:print-speech($word),
    text {' '},
    if (not(count($matching-refs)=1)) then '[ERROR:DUP-REF] ' else (),
    if (not(contains($ref-source, '.'))) then '[ERROR:UNPROCESSED] ' else (),
    local:show-word($ref, true(), $ref/ancestor::word-data, not($ref/change), false()),
 
    (: show inflection :)
    if (count($ref/inflect) gt 1) then '[ERROR:MULTI-INFLECT] ' else (),
    if ($ref/inflect[@source]) then
        let $inflect := $ref/inflect[1]
        let $inflect-v := $inflect/@v
        let $inflect-source := $inflect/@source/string()
        let $inflect-refs := xdb:key($ref, 'ref', $inflect-source)
        let $inflect-ref := $inflect-refs[@v=$inflect-v][1]
        let $show-ref := local:is-different-page($ref/@source, $inflect-ref/@source)
        let $is-different-source := local:is-different-source($ref/@source, $inflect-ref/@source)
        return (
            if ($is-different-source) then text {' [← '} else text {' ← '},
            if (not(count($inflect-refs) = 1) or not(count($inflect-ref) = 1)) then '[ERROR:MISLINK] ' else (),
            $inflect/@mark/string(),
            local:show-word($inflect-ref, false(), (), false(), $show-ref),
            if ($inflect != '' and not(starts-with($inflect, '[')))
                then ()
                else text {concat(' (', $inflect/@form/string())},
            if ($inflect != '' and starts-with($inflect, '['))
                then (text {'; '}, xdb:html($inflect/string()))
                else (),
            if ($inflect != '' and not(starts-with($inflect, '[')))
                then ()
                else text {')'},
            if ($is-different-source) then text {']'} else (),
            if ($inflect != '' and not(starts-with($inflect, '['))) then
                (text {'; '}, xdb:html($inflect/string()))
                else ()
        )
    else if ($ref/inflect) then (
        text {' [← '},
        $ref/inflect[1]/@mark/string(),
        local:show-word($ref/.., false(), (), false(), false()),
        text {concat(' (', $ref/inflect[1]/@form/string())},
        if ($ref/inflect[1] != '') then (text {'; '}, xdb:html($ref/inflect[1]/string())) else (),
        text {')]'}
    ) else (),
 
    (: show derivation :)
    if ($ref/deriv and $ref/inflect) then '; ' else (),
    if (count($ref/deriv) gt 1 and not($ref/deriv/@t='m')) then '[ERROR:MULTI-DERIV] ' else (),
    for $deriv in $ref/deriv
    let $deriv-v := $deriv/@v
    let $deriv-source := $deriv/@source/string()
    let $deriv-refs := xdb:key($ref, 'ref', $deriv-source)
    let $deriv-ref := $deriv-refs[@v=$deriv-v][1]
    let $show-language := not(local:get-lang($ref) = local:get-lang($deriv-ref))
    let $show-ref := local:is-different-page($ref/@source, $deriv-ref/@source)
    return (
        if ($deriv/@from) then <span> [&lt; <i>{$deriv/@from/string()}</i>]</span> else
        if ($deriv/preceding-sibling::deriv) then text {' / '} else text {' < '},
        if ((not(count($deriv-refs) = 1) or not(count($deriv-ref) = 1)) and not($deriv/@from)) then '[ERROR:MISLINK] ' else (),
        local:wordlet($deriv/@i3, ' < '),
        local:wordlet($deriv/@i2, ' < '),
        local:wordlet($deriv/@i1, ' < '),
        if ($deriv-ref) then local:show-word($deriv-ref, $show-language, (), false(), $show-ref) else (),
        if ($deriv != '') then xdb:html(concat(' (', $deriv/string(), ')')) else ()
    ),
 
    (: show rule :)
    if ($ref[@rule = 'ø' and not(@from)]) then '; [rule = ø]' else (),
    if ($ref[@rule != 'ø' or @from]) then concat('; [', $ref/@rule/string(), ' &lt; ', $ref/@from/string(), ']') else (),
 
    (: show elements :)
    if ($ref/element and ($ref/inflect or $ref/deriv)) then '; ⇐ ' else if ($ref/element) then ' ⇐ ' else (),
    for $element in $ref/element
    let $element-v := $element/@v
    let $element-source := $element/@source/string()
    let $element-refs := xdb:key($ref, 'ref', $element-source)
    let $element-ref := $element-refs[@v=$element-v][1]
    let $show-language := not(local:get-lang($ref) = local:get-lang($element-ref))
    let $show-ref := local:is-different-page($ref/@source, $element-ref/@source)
    return (
        if (not(count($element-refs) = 1) or not(count($element-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        if ($element/@mark != '') then text{$element/@mark} else (),
        if ($element-ref) then
            local:show-word($element-ref, $show-language, (), false(), $show-ref)
        else (),
        if ($element/@form != '') then concat(' (', $element/@form, ')') else (),
        if ($element != '') then xdb:html(concat(' (', $element/string(), ')')) else (),
        if ($element/following-sibling::element) then text { ' + ' } else ()
    ),
 
    (: show related :)
    if ($ref/related) then '; ' else (),
    for $related in $ref/related
    let $related-v := $related/@v
    let $related-source := $related/@source/string()
    let $related-refs := xdb:key($ref, 'ref', $related-source)
    let $related-ref := $related-refs[@v=$related-v][1]
    let $show-language := not(local:get-lang($ref) = local:get-lang($related-ref))
    let $show-ref := local:is-different-page($ref/@source, $related-ref/@source)
    return (
        if (not(count($related-refs) = 1) or not(count($related-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        if (ends-with($related, ']')) then xdb:html(concat(' ', substring($related, 0, $related/string-length()), ' '))
            else if ($related != '') then xdb:html(concat(' ', $related/string(), ' '))
            else ' related to ',
        if ($related-ref) then
            local:show-word($related-ref, $show-language, (), false(), $show-ref)
        else (),
        if (ends-with($related, ']')) then (']') else (),
        if ($related/following-sibling::related) then text {', '} else ()
    ),
 
    (: show archaic :)
    if ($ref/archaic) then '; (archaic) ' else (),
    for $archaic in $ref/archaic
    let $archaic-v := $archaic/@v
    let $archaic-source := $archaic/@source/string()
    let $archaic-refs := xdb:key($ref, 'ref', $archaic-source)
    let $archaic-ref := $archaic-refs[@v=$archaic-v][1]
    let $show-language := not(local:get-lang($ref) = local:get-lang($archaic-ref))
    let $show-ref := local:is-different-page($ref/@source, $archaic-ref/@source)
    return (
        if (not(count($archaic-refs) = 1) or not(count($archaic-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        text { ' replaced ' },
        if ($archaic != '') then xdb:html(concat(' (', $archaic/string(), ') ')) else (),
        text { 'by ' },
        if ($archaic-ref) then
            local:show-word($archaic-ref, $show-language, (), false(), $show-ref)
        else (),
        if ($archaic/following-sibling::archaic) then text {', '} else ()
    ),
 
    (: show cognates :)
    if (count($ref/cognate) gt 1) then '; cognates ' else if ($ref/cognate) then '; cognate ' else (),
    for $cognate in $ref/cognate
    let $cognate-v := $cognate/@v
    let $cognate-source := $cognate/@source/string()
    let $cognate-refs := xdb:key($ref, 'ref', $cognate-source)
    let $cognate-ref := $cognate-refs[@v=$cognate-v][1]
    let $show-ref := local:is-different-page($ref/@source, $cognate-ref/@source)
    return (
        if (not(count($cognate-refs) = 1) or not(count($cognate-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        if ($cognate-ref) then local:show-word($cognate-ref, true(), (), false(), $show-ref) else (),
        if ($cognate != '') then xdb:html(concat(' (', $cognate/string(), ')')) else (),
        if ($cognate/following-sibling::cognate) then text {', '} else ()
    ),
 
    (: show grammar info :)
    (:
    for $grammar in $ref/grammar
    let $grammar-v := $grammar/@v
    let $grammar-source := $grammar/@source/string()
    let $grammar-refs := xdb:key($ref, 'ref', $grammar-source)
    let $grammar-ref := $grammar-refs[@v=$grammar-v][1]
    let $show-ref := local:is-different-page($ref/@source, $grammar-ref/@source)
    return (
        text {'; § (('},
        if (not(count($grammar-refs) = 1) or not(count($grammar-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        local:show-word($grammar-ref, false(), (), false(), $show-ref),
        if ($grammar-ref/notes != '') then xdb:html(concat(' ', $grammar-ref/notes/string())) else (),
        text {'))'}
    ),
    :)
 
    (: show changes :)
    if (count($ref/change) gt 1) then '[ERROR:MULTI-CHANGE] ' else (),
    for $change in $ref/change
    let $change-v := $change/@v
    let $change-source := $change/@source/string()
    let $change-refs := xdb:key($ref, 'ref', $change-source)
    let $change-ref := $change-refs[@v=$change-v][1]
    let $show-language := not(local:get-lang($ref) = local:get-lang($change-ref))
    let $show-gloss := if ($ref/@gloss) then $ref else ()
    let $show-ref := local:is-different-page($ref/@source, $change-ref/@source)
    return (
        if ($ref/*[not(name()='change')][not(name()='notes')]) then text{';'} else (),
        text {' >> '},
        local:wordlet($change/@i3, ' >> '),
        local:wordlet($change/@i2, ' >> '),
        local:wordlet($change/@i1, ' >> '),
        if (not(count($change-refs) = 1) or not(count($change-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        if ($change-ref) then local:show-word($change-ref, $show-language, $show-gloss, false(), $show-ref) else (),
        if ($change != '') then xdb:html(concat(' (', $change/string(), ')')) else ()
    ),
 
    (: show corrections :)
    if (count($ref/correction) gt 1) then '[ERROR:MULTI-CORRECTION] ' else (),
    for $correction in $ref/correction
    let $correction-v := $correction/@v
    let $correction-source := $correction/@source/string()
    let $correction-refs := xdb:key($ref, 'ref', $correction-source)
    let $correction-ref := $correction-refs[@v=$correction-v][1]
    let $show-language := not(local:get-lang($ref) = local:get-lang($correction-ref))
    let $show-gloss := if ($ref/@gloss) then $ref else ()
    let $show-ref := local:is-different-page($ref/@source, $correction-ref/@source)
    return (
        if ($ref/*[not(name()='correction')][not(name()='notes')]) then text{';'} else (),
        text {' »» '},
        if (not(count($correction-refs) = 1) or not(count($correction-ref) = 1)) then '[ERROR:MISLINK] ' else (),
        if ($correction-ref) then local:show-word($correction-ref, $show-language, $show-gloss, false(), $show-ref) else (),
        if ($correction != '') then xdb:html(concat(' (', $correction/string(), ')')) else ()
    ),
 
    (: show corrections :)
    for $correction-ref in xdb:key($ref, 'correction', $ref/@source)
    let $correction-v := $correction-ref/@v
    let $show-gloss := if ($correction-ref/@gloss) then $ref else ()
    let $show-language := not(local:get-lang($ref) = local:get-lang($correction-ref))
    let $show-ref := local:is-different-page($ref/@source, $correction-ref/@source)
    return (
        text {'; [«« '},
        local:show-word($correction-ref, $show-language, $show-gloss, false(), $show-ref),
        if ($correction-ref != '') then xdb:html(concat(': ', $correction-ref/string())) else (),
        text {']'}
    ),
 
    (: show notes :)
    if (count($ref/notes) gt 1) then '[ERROR:MULTI-NOTES] ' else (),
    if (count($ref/notes) and not(xdb:html($ref/notes/string()))) then '[ERROR:BAD-NOTES] ' else (),
    for $notes in $ref/notes
    return (
        text {'; '},
        xdb:html($notes/string())
    ),
 
    (: show example :)
    if ($ref/example) then text{'; for example: '} else (),
    for $example in $ref/example
    let $example-ref := xdb:key($ref, 'ref', $example/@source)[1]
    let $example-v := $example-ref/@v
    let $show-gloss := if ($example-ref/@gloss and not($example/@t)) then $ref else ()
    let $show-language := not(local:get-lang($ref) = local:get-lang($example-ref))
    let $show-ref := local:is-different-page($ref/@source, $example-ref/@source)
    return (
        if ($example/preceding-sibling::example) then text {', '} else (),
        local:show-word($example-ref, $show-language, $show-gloss, false(), $show-ref),
        if (not($example/@t='transform')) then () else
            let $example-transform := $example-ref/transform
            let $example-transform-v := $example-transform/@v
            let $example-transform-source := $example-transform/@source/string()
            let $example-transform-refs := xdb:key($example-ref, 'ref', $example-transform-source)
            let $example-transform-ref := $example-transform-refs[@v=$example-transform-v][1]
            let $show-transform-language := not(local:get-lang($example-ref) = local:get-lang($example-transform-ref))
            let $show-transform-ref := local:is-different-page($example-ref/@source, $example-transform-ref/@source)
            return (
                text {' ⇐ '},
                local:show-word($example-transform-ref, $show-transform-language, (), false(), $show-transform-ref)
            ),
        if (not($example/@t='inflect')) then () else
            let $example-inflect := $example-ref/inflect
            let $example-inflect-v := $example-inflect/@v
            let $example-inflect-source := $example-inflect/@source/string()
            let $example-inflect-refs := xdb:key($example-ref, 'ref', $example-inflect-source)
            let $example-inflect-ref := $example-inflect-refs[@v=$example-inflect-v][1]
            let $show-inflect-language := not(local:get-lang($example-ref) = local:get-lang($example-inflect-ref))
            let $show-inflect-ref := local:is-different-page($example-ref/@source, $example-inflect-ref/@source)
            return (
                text {' ← '},
                local:show-word($example-inflect-ref, $show-inflect-language, (), false(), $show-inflect-ref)
            ),
        if (not($example/@t[starts-with(., 'deriv')])) then () else (
            if ($example-ref/deriv[@source]) then text {' < '} else (),
            for $example-deriv in $example-ref/deriv[@source]
                let $example-deriv-v := $example-deriv/@v
                let $example-deriv-source := $example-deriv/@source/string()
                let $example-deriv-refs := xdb:key($example-ref, 'ref', $example-deriv-source)
                let $example-deriv-ref := $example-deriv-refs[@v=$example-deriv-v][1]
                let $show-deriv-language := not(local:get-lang($example-ref) = local:get-lang($example-deriv-ref))
                let $show-deriv-ref := local:is-different-page($example-ref/@source, $example-deriv-ref/@source)
            return (
                local:show-word($example-deriv-ref, $show-deriv-language, (), false(), $show-deriv-ref),
                if ($example-deriv/following-sibling::deriv) then text {'/'} else ()
            ),
            for $example-deriv in $example-ref/deriv[@from]
            return (
                <span> [&lt; {c:print-word($example-ref/.., <print-word/>)}]</span>
            )
        )
    )
) }</p>
}</body>
</html>
