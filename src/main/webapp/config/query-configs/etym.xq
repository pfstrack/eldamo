import module namespace c = "common.xq" at "common.xq";

declare function local:derive-css($word as element()?) as xs:string {
    if (contains($word/@mark, '-')) then 'deleted'
    else if (contains($word/@mark, '|')) then 'deleted'
    else ''
};

declare function local:find-derivatives($refs as element()*) as element()* {
    let $deriv-to-refs := $refs/xdb:key($refs[1], 'deriv-to-ref', @source)
    let $element-in-refs := $refs/xdb:key($refs[1], 'element-in-ref', @source)
    return ($deriv-to-refs | $element-in-refs)
        [not(contains(c:get-speech(.), 'name'))][not(c:get-speech(.)='root')][not(c:get-speech(.)='phrase')]
};

declare function local:skip-deriv($ref as element()?, $cognate-refs as element()*) {
    let $lang := c:get-lang($ref)
    return
    if (contains($ref/@mark, '*')) then true()
    else if ($lang = 'mp' or $lang = 'on') then
        if ($ref/xdb:key($ref[1], 'deriv-to-ref', @source)) then true() else false()
    else if ($lang = 'mq') then
        if ($cognate-refs[not(c:get-lang(.) = ('mq'))]) then true() else false()
    else if ($lang = 'n') then
        if ($cognate-refs[not(c:get-lang(.) = ('mq', 'n'))]) then true() else false()
    else if ($lang = 'mt') then
        if ($cognate-refs[not(c:get-lang(.) = ('mq', 'n', 'mt'))]) then true() else false()
    else if ($lang = ('ilk', 'dor')) then
        if ($cognate-refs[not(c:get-lang(.) = ('mq', 'n', 'mt', 'ilk', 'dor'))]) then true() else false()
    else false()
};

declare function local:show-speech($ref as element()?) {
    let $speech := $ref/c:get-speech($ref)
    return 
    if ($speech='vb')
        then 'v.'
    else if ($speech='collective-noun')
        then 'coll.'
    else if ($speech='cardinal')
        then 'card.'
    else if ($speech='ordinal')
        then 'ord.'
    else if ($speech='adv adj')
        then 'adv. adj.'
    else if ($speech='adj adv')
        then 'adj. adv.'
    else if ($speech='adj n')
        then 'adj. n.'
    else if ($speech='adv n')
        then 'adv. n.'
    else if ($speech='n adj')
        then 'n. adj.'
    else if ($speech='prep adv')
        then 'prep. adv.'
    else if ($speech='conj adv')
        then 'conj. adv.'
    else if (contains($speech, ' '))
        then concat($speech, '. ???')
    else concat($speech, '.')
};

declare function local:show-infect($ref as element()?) {
    let $form := $ref/inflect/@form
    return 
    if ($form='vowel-suppression')
        then ''
    else if ($form='plural')
        then 'pl. '
    else if ($form='class-plural')
        then 'cl.pl. '
    else if ($form='dual')
        then 'du. '
    else if ($form='infinitive')
        then 'inf. '
    else if ($form='present')
        then 'pres. '
    else if ($form='aorist')
        then 'aor. '
    else if ($form='aorist 1st-sg')
        then 'aor. 1st.sg. '
    else if ($form='present 1st-sg')
        then 'pres. 1st.sg. '
    else if ($form='present 3rd-sg')
        then 'pres. 3rd.sg. '
    else if ($form='past 1st-sg')
        then 'pa.t. 1st.sg. '
    else if ($form='imperative')
        then 'imp. '
    else if ($form='soft-mutation')
        then 'soft mut. '
    else if ($form='soft-mutation plural')
        then 'soft mut. pl. '
    else if ($form='soft-mutation class-plural')
        then 'soft mut. cl.pl. '
    else if ($form='soft-mutation present plural')
        then 'soft mut. pres. pl. '
    else if ($form='soft-mutation gerund')
        then 'soft mut. pres. ger. '
    else if ($form='nasal-mutation plural')
        then 'nasal mut. pl. '
    else if ($form='past')
        then 'pa.t. '
    else if ($form='strong-past') (: FIXME - Make strong-past a variant :)
        then 'pa.t. '
    else if ($form='genitive')
        then 'g.sg. '
    else if ($form='genitive plural')
        then 'g.pl. '
    else if ($form='genitive dual')
        then 'g.du. '
    else if ($form='prefix')
        then 'pref. '
    else if ($form='suffix')
        then 'suf. '
    else if ($form='stem')
        then 'stem '
    else if ($form='possessive')
        then 'poss. '
    else if ($form='gerund')
        then 'ger. '
    else if ($form='intensive')
        then ''
    else if ($form='ablative')
        then 'abl. '
    else if ($form='locative')
        then 'loc. '
    else if ($form='passive-participle')
        then 'pass.part. '
    else concat($form, ' ??? ')
};

declare function local:is-root($word as element()) {
    if (c:get-speech($word)='root') then true()
    else if ($word/ref/@v='AIWĒ') then true()
    else false()
};


declare function local:show-refs($lang as xs:string*, $refs as element()*) {
    let $ref := $refs[c:get-lang(.)=$lang]
    return
    if (local:derive-css($ref[1]) = 'deleted') then
    <strike> {
        local:show-ref($lang, $refs)
    } </strike>
    else <span>{local:show-ref($lang, $refs)}</span>
};

declare function local:show-ref($lang as xs:string*, $refs as element()*) {
    let $ref := $refs[c:get-lang(.)=$lang]
    let $inflections := $ref/xdb:key($refs[1], 'inflect-to-ref', @source)[not(contains(@mark, '*'))]
    return (
        concat(
            if ($ref[1]/c:get-lang(.) = 'dor') then 'Dor. ' else '',
            if ($ref[1]/c:get-lang(.) = 'oss') then 'Oss. ' else '',
            if ($ref[1]/inflect[not(@form='infinitive')]) then local:show-infect($ref[1]) else (),
            if ($lang = 'mp' and $ref) then '*' else '',
            $ref/@mark/translate(., '-|', '')
        ),
        <i>
            {if ($ref/deriv/@i1) then concat($ref/deriv/@i1/string(), ', ') else ''}
            {if ($ref/deriv/@i2) then concat($ref/deriv/@i2/string(), ', ') else ''}
            {if ($ref/deriv/@i3) then concat($ref/deriv/@i3/string(), ', ') else ''}
            {$ref/@v/replace(., '/', ', ')}
        </i>,
        for $inflect in $inflections
        return (', ', 
            local:show-infect($inflect), 
            $ref/@mark/translate(., '-|', ''),
            <i>{$inflect/@v/replace(., '/', ', ')}</i>
        )
    )
};

<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Etymologies Export</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
<body>
<table>
<tr><th>Source</th><th>Base</th><th>Speech</th><th>PQ</th><th>Q</th><th>ON</th><th>N</th><th>T</th><th>Ilk</th><th>Dan</th><th>Fal</th></tr>
 {
for $word in //word[local:is-root(.)][ref[contains(@source, 'Ety')]]
let $refs := $word/ref[contains(@source, 'Ety')][not(correction)]
for $ref in $refs[xdb:key($word, 'deriv-to-ref', @source)]
let $derivs := local:find-derivatives($ref)
let $derivs2 := local:find-derivatives($derivs)
let $derivs3 := local:find-derivatives($derivs2)
let $derivs4 := local:find-derivatives($derivs3)
let $derivs5 := local:find-derivatives($derivs4)
let $all-derivs := ($derivs, $derivs2, $derivs3, $derivs4, $derivs5)
order by c:normalize-for-sort(substring-after(substring-before($ref/@source/string(), '.'), '/'))
return
for $deriv in $all-derivs
let $cognate-refs := $deriv/xdb:allReferenceCognates(.)
let $deriv-of-refs := $deriv/deriv/c:get-ref(.)[not(c:get-speech(.)='root')]
let $deriv-of-refs2 := $deriv-of-refs/deriv/c:get-ref(.)[not(c:get-speech(.)='root')]
let $all-deriv-ofs := ($deriv-of-refs, $deriv-of-refs2)
let $show-refs := $deriv | $cognate-refs | $all-deriv-ofs
return
if (local:skip-deriv($deriv, $cognate-refs)) then () else
<tr>
<td>{substring-before($ref/@source/string(), '.')}</td>
<td><span class="{local:derive-css($ref[1])}">{$ref/@v/string()}</span></td>
<td>{local:show-speech($deriv)}</td>
<td>{local:show-refs('mp', $show-refs)}</td>
<td>{local:show-refs('mq', $show-refs)}</td>
<td>{local:show-refs('on', $show-refs)}</td>
<td>{local:show-refs('n', $show-refs)}</td>
<td>{local:show-refs('mt', $show-refs)}</td>
<td>{local:show-refs(('ilk', 'dor'), $show-refs)}</td>
<td>{local:show-refs(('dan', 'oss'), $show-refs)}</td>
<td>{local:show-refs('fal', $show-refs)}</td>
</tr>
} </table>
<script src="../../js/dark-mode.js" ></script>
</body>
</html>
