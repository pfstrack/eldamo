module namespace c="common.xq";

declare function c:normalize-for-sort($value as xs:string?) as xs:string {
    let $w0 := replace(replace($value, 'yá²', 'yá%²'), 'yá¹', 'yá%¹')
    let $w1 := translate(lower-case($w0), 'χƕıǝçƀɟḷḹẏýṣṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûăĕĭŏŭæǣǭχřš¹²³⁴⁵⁶⁷⁸⁹ .?-–·‘’[]{}()!̆,`¯̯̥́̄̂', 
                                             'hhiecbjllyysmnrrnnaeiouaeiouaeiouaeiouaeiouaeiouaeoxrs123456789')
    let $w2 := replace($w1, 'ð', 'dzz')
    let $w3 := replace($w2, 'þ', 'tzz')
    let $w4 := replace($w3, 'θ', 'tzz')
    let $w5 := replace($w4, 'ʒ', 'hzz')
    let $w6 := replace($w5, 'ɣ', 'hzz')
    return $w6
};

declare function c:normalize-for-index($value as xs:string?) as xs:string {
    let $w1 := translate(lower-case($value), 'ƕıǝðþθʒɣçƀɟḷḹẏýṣṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûăĕĭŏŭæǣǭχřš¹²³⁴⁵⁶⁷⁸⁹ .?-–·‘’[]{}()!̆,`¯̯̥́̄̂', 
                                             'hietttggcbjllyysmnrrnnaeiouaeiouaeiouaeiouaeiouaeiouaeoxrs')
    return $w1
};

declare function c:normalize-for-match($value as xs:string?) as xs:string {
    normalize-space(translate(lower-case($value), '-ë¹²³⁴⁵⁶⁷⁸⁹,!.?', ' e'))
};

declare function c:derive-css($word as element()?) as xs:string {
    if (contains($word/@mark, '-')) then 'deleted'
    else if (contains($word/@mark, '|')) then 'deleted-section'
    else ''
};

(: gloss :)

declare function c:get-gloss($word as element()?) as xs:string? {
    let $gloss :=
        if ($word/@gloss) then $word/@gloss/string()
        else if (count($word[not(ref)]/word/@gloss)=1) then string($word/word/@gloss)
        else if (count($word[not(ref)]/*/ref[not(inflect) or c:is-root($word)][not(correction)]/@gloss)=1) then $word[not(ref)]/*/ref[not(inflect) or c:is-root($word)][not(correction)]/@gloss/string()
        else
            let $glosses := $word/ref[@gloss]
                [not(inflect) or c:is-root($word)]
                [not(correction)]
                [not(@mark/contains(., '-')) or $word/@mark/contains(., '-')]
            return
                if (count(distinct-values($glosses/@gloss/lower-case(.))) gt 1)
                then 'ERROR:MULTIGLOSS'
                else $glosses[1]/@gloss/string()
    return $gloss
};

declare function c:print-gloss($word as element()?) as node()* {
    let $gloss := c:get-gloss($word)
    let $css := () (: c:derive-css($word) :)
    return
        if ($gloss and $css) then (text{' “'}, <span class="{$css}">{$gloss}</span>, text{'”'})
        else if ($gloss) then text{concat(' “', $gloss, '”')}
        else ()
};

declare function c:print-gloss-no-space($word as element()?) as node()? {
    let $gloss := c:get-gloss($word)
    let $css := c:derive-css($word)
    return
        if ($gloss and $css) then <span class="{$css}">“{$gloss}”</span>
        else if ($gloss) then text{concat('“', $gloss, '”')}
        else ()
};

(: lang :)

declare function c:get-lang-strata($ref as element()?) as xs:string* {
    let $lang := c:get-lang($ref) return
    if ($lang = ('p', 'q', 's', 'os', 'ns', 'ln', 'lon', 'nan', 't', 'val')) then ('p', 'q', 's', 'os', 'ns', 'ln', 'lon', 'nan', 't', 'val')
    else if ($lang = ('mp', 'mq', 'n', 'ilk', 'dor', 'dan', 'mt')) then ('mp', 'mq', 'n', 'ilk', 'dor', 'dan', 'mt')
    else if ($lang = ('ep', 'eq', 'en', 'eon', 'eoq', 'g', 'sol', 'et', 'eilk')) then ('ep', 'eq', 'en', 'eon', 'eoq', 'g', 'sol', 'et', 'eilk')
    else ($lang)
};

declare function c:get-deriv-lang($ref as element()?) as xs:string* {
    let $lang := c:get-lang($ref) return
    if ($lang = ('mp', 'er', 'ep')) then c:get-lang-strata($ref)
    else $lang
};

declare function c:get-lang($ref as element()*) as xs:string? {
    $ref/ancestor-or-self::*[@l][1]/@l/string()
};

declare function c:get-langs($ref as element()*) as xs:string* {
    tokenize(c:get-lang($ref), '\s')
};

declare function c:is-primitive($ref as element()*) as xs:boolean {
    let $lang := c:get-lang($ref) return
    $lang = ('p', 'mp', 'ep')
};

declare function c:is-root($ref as element()*) as xs:boolean {
    let $speech := c:get-speech($ref) return
    $speech = 'root'
};

declare function c:other-lang($ref1 as element()?, $ref2 as element()) as xs:boolean {
    c:get-lang($ref1) != c:get-lang($ref2) 
};

declare function c:convert-lang($lang as xs:string?) as xs:string {
    if ($lang='p')
        then '✶'
    else if ($lang='mp')
        then 'ᴹ✶'
    else if ($lang='ep')
        then 'ᴱ✶'
    else if ($lang='mq')
        then 'ᴹQ. '
    else if ($lang='mt')
        then 'ᴹT. '
    else if ($lang='ln')
        then 'ᴸN. '
    else if ($lang='lon')
        then 'ᴸON. '
    else if ($lang='en')
        then 'ᴱN. '
    else if ($lang='eon')
        then 'ᴱON. '
    else if ($lang='eoq')
        then 'ᴱOQ. '
    else if ($lang='eilk')
        then 'ᴱIlk. '
    else if ($lang='et')
        then 'ᴱT. '
    else if ($lang='eq')
        then 'ᴱQ. '
    else if ($lang='ad')
        then 'Ad. '
    else if ($lang='pad')
        then '✶Ad. '
    else if ($lang='kh')
        then 'Kh. '
    else if ($lang='ed')
        then 'Ed. '
    else if ($lang='edan')
        then 'ED. '
    else if ($lang='av')
        then 'Av. '
    else if ($lang='un')
        then 'Un. '
    else if (string-length($lang) = 1 or string-length($lang) = 2)
        then concat(upper-case($lang), '. ')
    else
        concat(upper-case(substring($lang, 1, 1)), substring($lang, 2), '. ')
};

declare function c:print-lang($ref as element()?) as xs:string {
    let $lang := c:get-lang($ref)
    let $converted := c:convert-lang(string($lang))
    let $speech := c:get-speech($ref)
    return if ($speech = 'root') then translate($converted, '✶', '√') else $converted
};

(: source :)

declare function c:print-source($ref as element()?) as xs:string {
    substring-before(replace(replace(concat($ref/@source, '.'), '/0', '/'), '/0', '/'), '.')
};

declare function c:print-source-link($ref as element()) as element() {
    let $link := concat('../references/ref-', substring-before($ref/@source, '/'), '.html#', $ref/@source)
    let $src := c:print-full-source($ref)
    return <a href="{$link}" style="color: black">{$src}</a>
};

declare function c:print-sources($refs as element()*) as xs:string {
    let $sources := distinct-values($refs[
        not(contains(@source, 'I/') or contains(@source, 'I1/') or contains(@source, 'I2/')) 
        or starts-with(@source, 'TI/') or starts-with(@source, 'TAI/')
    ]/c:print-source(.))
    let $source-list := <list> {
        for $source in $sources return
        <source b="{substring-before($source, '/')}" p="{substring-after($source, '/')}"/>
    } </list>
    let $books := distinct-values($source-list/source/@b)
    let $book-pages :=
        for $book in $books return concat(
            $book, '/',
            string-join($source-list/source[@b = $book]/@p, ', ')
        )
    return concat(' ✧ ', string-join($book-pages, '; '))
};

declare function c:print-full-source($ref as element()) as xs:string {
    if (ends-with(translate(lower-case($ref/@source), '-äë¹²³', ' ae'), concat('i/',  translate(lower-case($ref/../@v), '-äë¹²³', ' ae'), '.001')))
    then substring-before($ref/@source, '/')
    else if (ends-with(translate($ref/@source, '¹²³', ''), concat('I1/',  translate($ref/../@v, '¹²³', ''), '.001')))
    then substring-before($ref/@source, '/')
    else if (ends-with(translate($ref/@source, '¹²³', ''), concat('I2/',  translate($ref/../@v, '¹²³', ''), '.001')))
    then substring-before($ref/@source, '/')
    else if (ends-with(translate($ref/@source, '¹²³', ''), concat('1A/',  translate($ref/../@v, '¹²³', ''), '.001')))
    then substring-before($ref/@source, '/')
    else if (ends-with(translate($ref/@source, '¹²³', ''), concat('2A/',  translate($ref/../@v, '¹²³', ''), '.001')))
    then substring-before($ref/@source, '/')
    else $ref/@source/string()
};

declare function c:print-full-sources($refs as element()*) as xs:string {
    let $sources := distinct-values($refs/c:print-full-source(.))
    return concat(' ✧ ', string-join($sources, ', '))
};

(: speech :)

declare function c:get-speech($ref as element()?) as xs:string? {
    $ref/ancestor-or-self::*[@speech][1]/@speech/string()
};

declare function c:print-speech($ref as element()?) as element()? {
    <i>{c:display-speech($ref)}</i>
};

declare function c:display-speech($ref as element()?) as xs:string? {
    let $speech := c:get-speech($ref)
    let $display :=
        if ($speech='masc-name') then ' m.'
        else if ($speech='fem-name') then ' f.'
        else if ($speech='place-name') then ' loc.'
        else if ($speech='collective-name') then ' coll.'
        else if ($speech='collective-noun') then ' coll.'
        else if ($speech='proper-name') then ' pn.'
        else if ($speech='cardinal') then ' num. card.'
        else if ($speech='ordinal') then ' num. ord.'
        else if ($speech='vb') then ' v.'
        else if ($speech='phrase') then ''
        else if ($speech='text') then ''
        else if ($speech='phonetic-group') then ''
        else if ($speech='phoneme') then ''
        else if ($speech='phonetic-rule') then ''
        else if ($speech='adj n') then ' adj. and n.'
        else if ($speech='adv n') then ' adv. and n.'
        else if ($speech='n adj') then ' n. and adj.'
        else if ($speech='n adv') then ' n. and adv.'
        else if ($speech='adj adv') then ' adj. and adv.'
        else if ($speech='adv adj') then ' adv. and adj.'
        else if ($speech='adv conj') then ' adv. and conj.'
        else if ($speech='prep pref') then ' prep. and pref.'
        else if ($speech='prep adv') then ' prep. and adv.'
        else if ($speech='adv interj') then ' adv. and interj.'
        else if ($speech='pron conj') then ' pron. and conj.'
        else if (ends-with($speech, '?')) then concat(' ', $speech)
        else concat(' ', $speech, '.')
    return $display
};

declare function c:is-word($ref as element()?) as xs:boolean {
    let $speech := c:get-speech($ref)
    return
    if (not($speech)) then false()
    else if ($speech='phrase') then false()
    else if ($speech='text') then false()
    else if ($speech='grammar') then false()
    else if (ends-with($speech, '-name')) then false()
    else if (starts-with($speech, 'phone')) then false()
    else true()
};

(: word :)

declare function c:print-wordlet($ref as attribute()?, $postfix as xs:string) as node()* {
    if ($ref) then
        let $has-brackets := starts-with($ref, '[') and ends-with($ref, ']')
        let $word-text := if ($has-brackets) then substring-before(substring-after($ref, '['), ']') else string($ref)
        let $start := if ($has-brackets) then text {'['} else ()
        let $end := if ($has-brackets) then text {']'} else ()
        return
            if (starts-with($ref/../../@mark, '-')) then
                (<strike>{($start, if ($has-brackets) then text{$word-text} else <i>{$word-text}</i>, $end)}</strike>, text{$postfix})
            else if (starts-with($ref/../../@mark, '|')) then
                (<u>{($start, if ($has-brackets) then text{$word-text} else <i>{$word-text}</i>, $end)}</u>, text{$postfix})
            else
                ($start, if ($has-brackets) then text{$word-text} else <i>{$word-text}</i>, $end, text{$postfix})
    else ()
};

declare function c:has-brackets($ref as node()?) as xs:boolean {
    starts-with($ref/@v, '[') and ends-with($ref/@v, ']') and not(contains(substring-after($ref/@v, '['), '['))
};

declare function c:print-link-to-word($ref as element(), $text) as element() {
    let $word := c:get-word($ref) return
    if (starts-with($ref/@v, 'ø')) then <span>{$text}</span> else
    if ($ref/@v='?' or $ref/@rule='?') then <span> ? </span> else
    if (not($word)) then <span> !!! </span> else
    <a title="{c:print-lang($word)}({string($word/@order)}) {string($word/@v)}" href="{concat('../words/word-', xdb:hashcode($word), '.html')}">{$text}</a>
};

declare function c:print-word($word as element()?, $control as element()?) as node()* {
    let $show-lang := $control/@show-lang
    let $show-link := $control/@show-link
    let $hide-mark := $control/@hide-mark
    let $style := $control/@style
    let $has-brackets := c:has-brackets($word)
    return
    if (not($word)) then () else
    let $primary-style := if ($style = 'bold') then 'primary'
                          else if ($style = 'none' or $has-brackets) then 'none'
                          else 'secondary'
    let $css := concat($primary-style, ' ', c:derive-css($word))
    let $link := 
        if (not($show-link)) then
            ()
        else if ($show-link = 'parent') then
            concat('../words/word-', xdb:hashcode($word/ancestor-or-self::word[1]), '.html')
        else if (name($word) = 'ref') then 
            concat('../references/ref-', substring-before($word/@source, '/'), '.html#', $word/@source)
        else
            concat('../words/word-', xdb:hashcode($word), '.html')
    let $value := $word/@v/string()
    return (
        if (not($hide-mark) and c:is-primitive($word)) then text {$word/translate(@mark, '-|', '')} else (),
        if ($show-lang) then text {c:print-lang($word)} else (),
        if (not($hide-mark) and not(c:is-primitive($word))) then text {$word/translate(@mark, '-|', '')} else (),
        <span class="{$css}">{
            if ($link) then <a href="{$link}">{$value}</a>
            else $value
        }</span>
    )
};

declare function c:get-word($ref as element()?) as element()* {
    let $ref-lang := c:get-lang($ref)
    let $generic-words := $ref/xdb:key($ref, 'word', $ref/@v)
    let $in-strata-words := $generic-words[c:get-lang(.) = c:get-lang-strata($ref)]
    let $words :=
        if ($ref/@l) then $generic-words[c:get-lang(.) = $ref-lang]
        else if (count($generic-words) = 1) then $generic-words
        else if (count($in-strata-words) = 1) then $generic-words[c:get-lang(.) = c:get-lang-strata($ref)]
        else $generic-words[c:get-lang(.) = $ref-lang]
    return $words
};

declare function c:get-ref($ref as element()?) as element()? {
    let $refs := $ref/xdb:key($ref, 'ref', $ref/@source)
    return if (count($refs) gt 1) then () else $refs
};

declare function c:majority-value($values as node()*) as xs:string? {
    let $groups :=
        <groups> {
            for $value in distinct-values($values) return
            <group> {
                for $item in $values[. = $value] return <item>{$value}</item>
            } </group>
        } </groups> 
    let $ordered-groups :=
        <groups> {
            for $group in $groups/group order by -1 * count($group/item) return $group
        } </groups> 
    let $distinct := distinct-values($values)
    return $ordered-groups/group[1]/item[1]/string()
};

declare function c:print-word-elements($elements as element()*, $word, $control) as node()* {
    let $result :=
        for $element in $elements
        let $element-ref := c:get-word($element)
        return
            <span> { (
                if ($element/@v='?') then <i>?</i>
                else if (not(count($element-ref) = 1)) then (
                    <i>{$element/@v/string()}</i>,
                    ' (ERROR:MISMATCH)'
                ) else (
                    if (c:get-lang($element-ref) != c:get-lang($word)) then c:print-lang($element-ref) else (),
                    c:print-word($element-ref, $control),
                    $element/@mark/string(),
                    if ($element/@form) then concat(' (', $element/@form, ')') else ()
                ),
                if ($element/following-sibling::element) then
                    if ($element/@group != $element/following-sibling::element[1]/@group) then ' // ' else ' + '
                else ()
            ) } </span>
    return $result/node()
};

declare function c:is-rule($ref as element()?) as xs:boolean {
    if ($ref/@rule or xdb:key($ref, 'rule-to-ref', $ref/@source))
    then true()
    else false()
};

declare function c:show-hierarchy($items as element()*, $grouping as xs:string, $label as xs:string) as element()* {
    if ($items) then <h2>{$label}</h2> else (),
    let $lang := c:get-lang($items[1])
    let $top-level := $items[not(xdb:key(., 'element-in', @v)[c:get-speech(.)=$grouping and c:get-lang(.) = $lang])] return
    c:show-hierarchy-list($top-level, $grouping)
};

declare function c:show-hierarchy-list($items as element()*, $grouping as xs:string) as element()* {
    <ul> {
    for $word in $items
    let $elements := $word/element
    let $child-elements := $elements[c:get-word(.)[c:get-speech(.)=$grouping]]
    let $non-child-elements := $elements[c:get-word(.)[not(c:get-speech(.)=$grouping)]]
    order by $word/@order, c:normalize-for-sort($word/@v)
    return (
        <li>
            { c:print-word($word, <control style="bold" show-link="y"/>) }
            { if ($non-child-elements) then 
            <span>: {c:print-word-elements($non-child-elements, $word, <control show-link="y"/>)}</span>
            else() }
            { c:show-hierarchy-list($child-elements/c:get-word(.), $grouping) }
        </li>
    ) } </ul>
};

declare function c:alt-lang($word as element()) as xs:string {
    let $alt := $word[not($word/ref)][not(starts-with(@speech, 'phon') or @speech='grammar')]//word[ref][@l][@l != $word/@l] |
                $word[not($word/ref)][not(starts-with(@speech, 'phon') or @speech='grammar')]/word[1][@l][@l != $word/@l]
    return if ($alt)
    then translate(c:print-lang($alt[1]), ' ', '')
    else ''
};

(: inflect :)

declare function c:print-inflect-form($form as xs:string) as xs:string {
    if ($form='plural')
        then 'pl.'
    else if ($form='class-plural')
        then 'class pl.'
    else if ($form='imperative')
        then 'imp.'
    else if ($form='infinitive')
        then 'inf.'
    else if ($form='present')
        then 'pres.'
    else if ($form='soft-mutation')
        then 'soft mut.'
    else if ($form='nasal-mutation')
        then 'nasal mut.'
    else
        $form
};

declare function c:print-inflect-forms($forms as xs:string) as xs:string {
    let $form-list := 
        for $form in tokenize($forms, ' ')
        return c:print-inflect-form($form)
    return string-join($form-list, ' ')
};
