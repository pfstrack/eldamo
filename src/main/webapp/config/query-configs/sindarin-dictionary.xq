import module namespace c = "common.xq" at "common.xq";

declare variable $id := 's';
declare variable $pubmode external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

declare function local:lang-refs($word as element()) as element()* {
    $word/descendant-or-self::word[@l='s' or @l='n']/ref
};

declare function local:clean-sources($sources as xs:string) as xs:string {
    replace($sources, 'Let/', 'Letters/')
};

declare function local:print-def($word as element()) as item()* {
    let $alt-lang := c:alt-lang($word)
    let $lang-refs := local:lang-refs($word)
    let $extracted-from := if ($lang-refs[not(contains(@mark, '*'))]) then () else $lang-refs[1]/xdb:key(., 'element-in-ref', @source)[1]
    let $inflected-from := if ($lang-refs[not(inflect)]) then () else $lang-refs[inflect][1]
    let $inflections := $lang-refs[inflect]
    return
    (
        if ($alt-lang)
        then concat('[', $alt-lang, '] ')
        else (),
        <i>
            { concat(c:display-speech($word), ' ') }
            { if (contains($word/@mark, '†')) then ' Arch. ' else () }
        </i>,
        c:get-gloss($word),
        if ($alt-lang)
        then
            if (local:normalized-item($word) != local:normalized-item($word/word[1]))
            then (
                <br/>,
                'Sindarized from',
                $alt-lang,
                ' ',
                <i> {
                    let $noldorin := local:normalized-item($word/word[1]) return
                    if (starts-with($noldorin, 'mb') or starts-with($noldorin, 'nd') or starts-with($noldorin, 'ng'))
                    then substring($noldorin, 2)
                    else $noldorin
                } </i>,
                '',
                if (contains($word/@mark, '^') or contains($word/@v, 'lth')) then () else ' ERROR:NO_HAT'
            )
            else ()
        else (),
(:
        if ($inflections) then
            for $inflection in $inflections return
            (
                <br/>, 
                <i>{c:print-inflect-forms($inflection/inflect/@form)}</i>,
                concat(' ', if (c:get-lang($inflection) != 's') then c:print-lang($inflection) else ''), 
                <i>{$inflection/@v/string()}</i>,
                concat('; ', local:clean-sources(c:print-source($inflection)))
            )
        else (),
:)
        if ($extracted-from)
        then (
            <br/>,
            'Extracted from ',
            $alt-lang, ' ',
            <i>{$extracted-from/@v/string()}</i>,
            concat(if (c:get-gloss($extracted-from)) then ' ' else '',
                c:get-gloss($extracted-from), '; ', local:clean-sources(c:print-source($extracted-from))),
            if (contains($word/@mark, '*')) then () else ' ERROR:NO_STAR'
        )
        else (),
        if ($inflected-from and not($extracted-from))
        then (
            <br/>,
            'Deduced from ',
            <i>{c:print-inflect-forms($inflected-from/inflect/@form)} </i>,
            concat(' ', $alt-lang, ' '), 
            <i>{$inflected-from/@v/string()}</i>,
            concat('; ', local:clean-sources(c:print-source($inflected-from))),
            if (
            contains($word/@mark, '*') or contains($word/@mark, '#')
            ) then () else ' ERROR:NO_HASH'
        )
        else (),
        let $sources := local:clean-sources(replace(c:print-sources(
            $lang-refs[not(@mark="*")][not(c:print-source(.) = c:print-source($inflected-from))]
        ), ' ✧ ', '')) 
        return if ($sources = '') then (
            if ($inflected-from or $extracted-from) then () else 'ERROR:NO_SOURCE'
        ) else (<br/>, $sources) 
    )
};

declare function local:normalized-item($word as element()) as xs:string {
    let $base := lower-case(translate($word/@v, 'ëâêô¹²³⁴⁵⁶⁷⁸⁹', 'eaeo')) return (: îûŷ iuy :)
    let $tengwared := if ($word/@tengwar)
    then translate(concat(translate($word/@tengwar, '-', ''), substring($base, 2)), 'ñ', 'n') else 
    $base
    return if ($word/@v = 'êl')
    then 'êl'
    else $tengwared
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>sindarin-dictionary-export</title>
<style>
table   {{ border: solid 1px black; border-collapse: collapse }}
td, th  {{ border: solid 1px black; padding: 0.2em; vertical-align: top }}
th      {{ background: #CCCCCC }}
</style>
</head>
<body>
<table> { 
let $words := xdb:key(/*, 'language', $id)
let $word-list := $words
        [not(ends-with(c:get-speech(.), '-name'))]
        [not(c:get-speech(.)='text')]
        [not(c:get-speech(.)='phrase' or c:get-speech(.)='text')]
        [not(c:get-speech(.)='grammar')]
        [not(starts-with(c:get-speech(.), 'phone'))]
        [not(c:get-speech(.)='root')]
        [not(see)]
        [not(contains(@mark, '-'))]
        [not(contains(@mark, '?'))]
        [not(contains(@mark, '**'))]
        [not(contains(@speech, '?'))]
        [not(@speech = 'suf')]
        [not(@v = 'bas(t)')]
        [not(@v = 'gann(ad)a-')]
        [not(@v = 'gwae(w)')]
        [not(@v = 'lathr(ad)a-')]
        [not(@v = 'nan(d)')]
        [not(@v = 'nos(s)')]
        [not(@v = 'othgar(ed)')]
        [not(@v = 'ras(t)')]
let $item-list := distinct-values($word-list/local:normalized-item(.))
for $item in $item-list 
order by c:normalize-for-sort($item)
return
let $item-words := $word-list[local:normalized-item(.) = $item]
return (
    <tr>
        <td>{$item} {if (contains($item, '(')) then ' ERROR:PAREN' else ()}</td>
        <td> {
            if ($item-words[2] or $item = 'mal')
            then
            <ol> { (
                for $word in $item-words return
                <li>{local:print-def($word)}</li>,
                if ($item = 'mal') then
                    <li><i>conj.</i> but<br/>Neo-Sindarin reconstruction.</li>
                else () 
            ) } </ol>
            else local:print-def($item-words[1])
        } </td>
    </tr>
) }
    <tr>
        <td>anha-</td>
        <td><i> v. </i>to give<br/>PE17/93</td>
    </tr>
    <tr>
        <td>antha-</td>
        <td><i> v. </i>to give<br/>PE17/93</td>
    </tr>
    <tr>
        <td>dolla-</td>
        <td>[N.] <i> v. </i>to conceal<br/>Sindarized from N.  <i>doltha-</i><br/>Deduced from <i>inf.</i> N. <i>doltha</i>; Ety/DUL</td>
    </tr>
    <tr>
        <td>drav-</td>
        <td>[N.] <i> n. </i>to hew<br/>Deduced from <i>inf.</i> N. <i>dravo</i>; Ety/DARÁM</td>
    </tr>
    <tr>
        <td>falla-</td>
        <td>[N.] <i> v. </i>to foam<br/>Sindarized from N.  <i>faltha-</i><br/>Deduced from <i>inf.</i> N. <i>faltho</i>; Ety/PHAL</td>
    </tr>
    <tr>
        <td>fanha-</td>
        <td><i> v. </i>to veil, cloak<br/>PE17/174</td>
    </tr>
    <tr>
        <td>fantha-</td>
        <td><i> v. </i>to veil, cloak<br/>PE17/174</td>
    </tr>
    <tr>
        <td>glinna-</td>
        <td><i> v. </i>to glance (at)<br/>Sindarized from <i>glintha-</i>; WJ/337</td>
    </tr>
    <tr>
        <td>gwae</td>
        <td><i> n. </i>wind<br/>PE17/33, 34, 189; WJ/418; Ety/WĀ</td>
    </tr>
    <tr>
        <td>gwaew</td>
        <td><i> n. </i>wind<br/>PE17/33, 34, 189; WJ/418; Ety/WĀ</td>
    </tr>
    <tr>
        <td>halla-</td>
        <td>[N.] <i> v. </i>to screen<br/>Sindarized from N.  <i>haltha-</i><br/>Ety/SKAL¹; EtyAC/SKAL¹ </td>
    </tr>
    <tr>
        <td>hella-</td>
        <td>[N.] <i> v. </i>to strip<br/>Sindarized from N.  <i>heltha-</i><br/>Ety/SKEL; EtyAC/SKEL</td>
    </tr>
    <tr>
        <td>lathra-</td>
        <td>[N.] <i> v. </i>to listen in, eavesdrop<br/>Sindarized from N.  <i>lhathra-</i><br/>Deduced from <i>inf.</i> N. <i>lhathro</i>; Ety/LAS²<br/>EtyAC/LAS²</td>
    </tr>
    <tr>
        <td>lathrada-</td>
        <td>[N.] <i> v. </i>to listen in, eavesdrop<br/>Sindarized from N.  <i>lhathrada-</i><br/>Deduced from <i>inf.</i> N. <i>lhathrado</i>; Ety/LAS²<br/>EtyAC/LAS²</td>
    </tr>
    <tr>
        <td>mbas</td>
        <td><i> n. </i>bread<br/>PE17/144; VT44/27; Ety/KOR, MBAS</td>
    </tr>
    <tr>
        <td>mbass</td>
        <td><i> n. </i>bread<br/>PE17/144; VT44/27; Ety/KOR, MBAS</td>
    </tr>
    <tr>
        <td>mbast</td>
        <td><i> n. </i>bread<br/>PE17/144; VT44/27; Ety/KOR, MBAS</td>
    </tr>
    <tr>
        <td>mela-</td>
        <td><i> v. </i>to love<br/>Deduced from <i>negative-quasi-participle </i>  <i>úvel</i>; PE17/144<br/>PE17/145; EtyAC/MEL</td>
    </tr>
    <tr>
        <td>nan</td>
        <td><i> n. </i>valley<br/>PE17/37, 83; RC/269; SA/nan(d), sîr; Ety/NAD</td>
    </tr>
    <tr>
        <td>nand</td>
        <td><i> n. </i>valley<br/>PE17/37, 83; RC/269; SA/nan(d), sîr; Ety/NAD</td>
    </tr>
    <tr>
        <td>nellil</td>
        <td>[N.] <i> n. </i>triangle<br/>Sindarized from N.  <i>nelthil</i><br/>Ety/NEL, TIL</td>
    </tr>
    <tr>
        <td>nganna-</td>
        <td>[N.] <i> v. </i>to play a harp<br/>Deduced from <i>inf.</i> N. <i>ganno</i>; Ety/ÑGAN</td>
    </tr>
    <tr>
        <td>ngannada-</td>
        <td>[N.] <i> v. </i>to play a harp<br/>Deduced from <i>inf.</i> N. <i>gannado</i>; Ety/ÑGAN</td>
    </tr>
    <tr>
        <td>ngawa-</td>
        <td>[N.] <i> v. </i>to howl<br/>Ety/ÑGAW</td>
    </tr>
    <tr>
        <td>nos</td>
        <td><i> n. </i>family, kindred, clan, house; race, tribe, people<br/>PE17/169; PM/320, 360; Ety/NŌ</td>
    </tr>
    <tr>
        <td>noss</td>
        <td><i> n. </i>family, kindred, clan, house; race, tribe, people<br/>PE17/169; PM/320, 360; Ety/NŌ</td>
    </tr>
    <tr>
        <td>olla-</td>
        <td>[N.] <i> v. </i>to dream<br/>Sindarized from N.  <i>oltha-</i><br/>Ety/LOS, ÓLOS</td>
    </tr>
    <tr>
        <td>othgar</td>
        <td><i> n. </i>doing wrong, *wrong doing<br/>PE17/151</td>
    </tr>
    <tr>
        <td>othgared</td>
        <td><i> n. </i>doing wrong, *wrong doing<br/>PE17/151</td>
    </tr>
    <tr>
        <td>pellaes</td>
        <td>[N.] <i> n. </i>pivot<br/>Sindarized from N.  <i>pelthaes</i><br/>Ety/PEL, TAK; EtyAC/TAK</td>
    </tr>
    <tr>
        <td>ras</td>
        <td><i> n. </i>cape, shore<br/>WJ/190</td>
    </tr>
    <tr>
        <td>rast</td>
        <td><i> n. </i>cape, shore<br/>WJ/190</td>
    </tr>
    <tr>
        <td>thran</td>
        <td><i> adj. </i>vigorous<br/>PE17/27, 187</td>
    </tr>
    <tr>
        <td>tolla-</td>
        <td>[N.] <i> v. </i>to fetch<br/>Sindarized from N.  <i>toltha-</i><br/>Deduced from <i>inf.</i> N. <i>toltho</i>; Ety/TUL</td>
    </tr>
</table>
</body>
</html>