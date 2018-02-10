module namespace c="common.xq";

declare function c:normalize-for-sort($value as xs:string?) as xs:string {
    let $w0 := replace(replace($value, 'yá²', 'yá%²'), 'yá¹', 'yá%¹')
    let $w1 := translate(lower-case($w0), 'χƕıǝçƀɟḷḹẏýṣṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûŷăĕĭŏŭãæǣǭęχřš¹²³⁴⁵⁶⁷⁸⁹ .?-–~·‘’[]{}()!̆,`¯̯̥́̄̂', 
                                          'hhiecbjllyysmnrrnnaeiouaeiouaeiouaeiouaeiouyaeiouaaeoexrs123456789')
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

declare function c:get-neo-gloss($word as element()?) as xs:string? {
    if ($word/@ngloss) then $word/@ngloss/string()
    else c:get-gloss($word)
};

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

declare function c:print-neo-gloss($word as element()?) as node()* {
    let $gloss := c:get-neo-gloss($word)
    let $css := () (: c:derive-css($word) :)
    return
        if ($gloss and $css) then (text{' “'}, <span class="{$css}">{$gloss}</span>, text{'”'})
        else if ($gloss) then text{concat(' “', $gloss, '”')}
        else ()
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

declare function c:get-lang($ref as element()*) as xs:string? {
    $ref/ancestor-or-self::*[@l][1]/@l/string()
};

declare function c:get-langs($ref as element()*) as xs:string* {
    tokenize(c:get-lang($ref), '\s')
};

declare function c:is-primitive($ref as element()*) as xs:boolean {
    let $lang := c:get-lang($ref) return
    $lang = ('p', 'mp', 'ep', 'np')
};

declare function c:is-neo-lang($ref as element()*) as xs:boolean {
    let $lang := c:get-lang($ref) return
    $lang = ('nq', 'q', 'mq', 'eq', 'ns', 's', 'n', 'en', 'g', 'np', 'p', 'mp', 'ep')
};

declare function c:get-neo-lang($ref as element()*) as xs:string {
    let $lang := c:get-lang($ref) return
    if ($lang = ('nq', 'q', 'mq', 'eq')) then 'nq'
    else if ($lang = ('ns', 's', 'n', 'en', 'g')) then 'ns'
    else if ($lang = ('np', 'p', 'mp', 'ep')) then 'np'
    else ''
};

declare function c:get-neo-lang-group($lang as xs:string) as xs:string* {
    if ($lang = 'nq') then ('nq', 'q', 'mq', 'eq')
    else if ($lang = 'ns') then ('ns', 's', 'n', 'en', 'g')
    else if ($lang = 'np') then ('ns', 's', 'n', 'en', 'g')
    else $lang
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
    else if ($lang='np')
        then 'ᴺ✶'
    else if ($lang='mq')
        then 'ᴹQ. '
    else if ($lang='nq')
        then 'ᴺQ. '
    else if ($lang='mt')
        then 'ᴹT. '
    else if ($lang='ns')
        then 'ᴺS. '
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
    else if ($lang='norths')
        then 'North S. '
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

declare function c:print-lang2($ref as element()?) as xs:string {
    translate(c:print-lang($ref), ' ', '')
};

declare function c:lang-words($root as element(), $id) as element()* {
    if ($id = 'nq') then
        (xdb:key($root, 'language', 'nq') | xdb:key($root, 'language', 'q') | xdb:key($root, 'language', 'mq') | xdb:key($root, 'language', 'eq'))
        [not(combine)]
        (: [starts-with(c:normalize-spelling(lower-case(c:normalize-for-sort(@v))), 'ah')] :)
    else if ($id = 'ns') then
        (xdb:key($root, 'language', 'ns') | xdb:key($root, 'language', 's') | xdb:key($root, 'language', 'n') | xdb:key($root, 'language', 'en') | xdb:key($root, 'language', 'g'))
        [not(combine)]
    else if ($id = 'np') then 
        (xdb:key($root, 'language', 'np') | xdb:key($root, 'language', 'p') | xdb:key($root, 'language', 'mp') | xdb:key($root, 'language', 'ep'))
        [not(combine)]
    else xdb:key($root, 'language', $id)
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
        if (contains($speech, ' ')) then
            let $a := tokenize($speech, '\s')
            let $r := string-join($a, '. and ')
            return concat(' ', $r, '.')
        else if ($speech='masc-name') then ' m.'
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
                (<span class="deleted">{($start, if ($has-brackets) then text{$word-text} else <i>{$word-text}</i>, $end)}</span>, text{$postfix})
            else if (starts-with($ref/../../@mark, '|')) then
                (<span class="deleted-section">{($start, if ($has-brackets) then text{$word-text} else <i>{$word-text}</i>, $end)}</span>, text{$postfix})
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
    <a title="{c:print-lang($word)}({string($word/@order)}) {string($word/@v)}" href="{c:to-word-link($word)}">{$text}</a>
};

declare function c:print-word($word as element()?, $control as element()?) as node()* {
    let $show-lang := $control/@show-lang
    let $show-link := $control/@show-link
    let $show-gloss := $control/@show-gloss
    let $hide-mark := $control/@hide-mark
    let $normalize := $control/@normalize
    let $is-neo := $control/@is-neo
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
            c:to-word-link($word/ancestor-or-self::word[1])
        else if (name($word) = 'ref') then 
            concat('../references/ref-', substring-before($word/@source, '/'), '.html#', $word/@source)
        else
            c:to-word-link($word)
    let $value := if ($normalize = 'true')
        then c:normalize-spelling($word/@v/string())
        else $word/@v/string()
    return (
        if (not($hide-mark) and c:is-primitive($word)) then text {$word/translate(@mark, '-|', '')} else (),
        if ($show-lang) then text {c:print-lang($word)} else (),
        if (not($hide-mark) and not(c:is-primitive($word))) then text {$word/translate(@mark, '-|', '')} else (),
        (
            <span class="{$css}">{
                if ($link) then <a href="{$link}">{$value}</a>
                else $value
            }</span>,
            if ($show-gloss and $is-neo) then c:print-neo-gloss($word)
            else if ($show-gloss) then c:print-gloss($word) else ()
        )
    )
};

declare function c:normalize-spelling($value) as xs:string {
    let $v1 := translate(replace(replace(replace($value, 'q', 'qu'), 'quu', 'qu'), 'ks', 'x'), 'k', 'c')
    let $v2 := replace($v1, 'ea', 'ëa')
    let $v3 := if ($v2 = 'nye' or $v2 = 'lye') then $v2
        else if (string-length(translate($v2, '¹²³⁴', '')) < 3) then $v2
        else if (ends-with($v2, 'e')) then concat(substring($v2, 1, string-length($v2) - 1), 'ë')
        else if (ends-with($v2, 'e)')) then concat(substring($v2, 1, string-length($v2) - 2), 'ë)')
        else if (ends-with($v2, 'e¹')) then concat(substring($v2, 1, string-length($v2) - 2), 'ë¹')
        else if (ends-with($v2, 'e²')) then concat(substring($v2, 1, string-length($v2) - 2), 'ë²')
        else if (ends-with($v2, 'e³')) then concat(substring($v2, 1, string-length($v2) - 2), 'ë³')
        else if (ends-with($v2, 'e⁴')) then concat(substring($v2, 1, string-length($v2) - 2), 'ë⁴')
        else $v2
    return $v3
};

declare function c:to-word-link($word) as xs:string {
    concat('../words/word-', xdb:hashcode($word), '.html')
    (: concat('../entries/entry-', c:get-lang($word), '-', translate($word/@v, ' ', '_'), '.html') :)
};

declare function c:word-lookup($root as element()?, $l, $v) as element()* {
    let $generic-words := $root/xdb:key($root, 'word', $v)
    return $generic-words[c:get-lang(.) = $l]
};

declare function c:get-word($ref as element()?) as element()* {
    let $ref-lang := c:get-lang($ref)
    let $generic-words := $ref/xdb:key($ref, 'word', $ref/@v)
    let $words :=
        if ($ref/@l) then $generic-words[c:get-lang(.) = $ref-lang]
        else if (count($generic-words) = 1) then $generic-words
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
    let $alt := $word[not($word/ref)][not(starts-with(@speech, 'phon') or @speech='grammar' or @speech='text')]//word[ref][1][@l][@l != $word/@l]
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
