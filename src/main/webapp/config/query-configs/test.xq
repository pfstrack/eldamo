import module namespace c = "common.xq" at "common.xq";

<html>
<body>
<table> {
let $l := 'q'
let $exclusions := <exclusions>
<word l="q" v="nórë"/>
<word l="q" v="niquis(së)"/>
<word l="q" v="net(ë)"/>
<word l="q" v="ne(re)sta"/>
<word l="q" v="nenda"/>
<word l="q" v="nel(e)quë"/>
<word l="q" v="nel(d)esta"/>
<word l="q" v="-(n)dur"/>
<word l="q" v="-ndon"/>
<word l="q" v="-(n)dil"/>
<word l="q" v="minquë"/>
<word l="q" v="-lmë¹"/>
<word l="q" v="mar(da)"/>
<word l="q" v="maqua"/>
<word l="q" v="man"/>
<word l="q" v="Maia"/>
<word l="q" v="lunca"/>
<word l="q" v="luinë"/>
<word l="q" v="-lta"/>
<word l="q" v="lón(a)"/>
<word l="q" v="li(n)-"/>
<word l="q" v="lepekan(t)"/>
<word l="q" v="lempë"/>
<word l="q" v="it(ë)"/>
<word l="q" v="-itë"/>
<word l="q" v="-ion"/>
<word l="q" v="inquë"/>
<word l="q" v="ilvan(y)a"/>
<word l="q" v="-ien¹"/>
<word l="q" v="-iel"/>
<word l="q" v="-ië²"/>
<word l="q" v="hrú(y)a"/>
<word l="q" v="hlón(a)"/>
<word l="q" v="heru"/>
<word l="q" v="ca"/>
<word l="q" v="et(e)-"/>
<word l="q" v="epetai"/>
<word l="q" v="opo"/>
<word l="q" v="en(a)"/>
<word l="q" v="coiv(i)ë"/>
<word l="q" v="castol(o)"/>
<word l="q" v="cas(ta)"/>
<word l="q" v="Casar"/>
<word l="q" v="ca(na)sta"/>
<word l="q" v="axë"/>
<word l="q" v="auta-¹"/>
<word l="q" v="au-"/>
<word l="q" v="atya¹"/>
<word l="q" v="at(a)-"/>
<word l="q" v="asëa"/>
<word l="q" v="as(a)-"/>
<word l="q" v="árë"/>
<word l="q" v="arata"/>
<word l="q" v="ar(a)-"/>
<word l="q" v="ar(a)"/>
<word l="q" v="ar"/>
<word l="q" v="an(a)"/>
<word l="q" v="ar(i)-"/>
<word l="q" v="an(a)-"/>
<word l="q" v="amya"/>
<word l="q" v="alcarin(qua)"/>
<word l="q" v="al(a)-²"/>
<word l="q" v="al(a)-¹"/>
<word l="q" v="a"/>
<word l="mq" v="an-"/>
<word l="mq" v="ar"/>
<word l="mq" v="an(ner)"/>
<word l="mq" v="an(ner)"/>
<word l="mq" v="at(a)-"/>
<word l="mq" v="au(ve)"/>
<word l="mq" v="ear"/>
<word l="mq" v="elen"/>
<word l="mq" v="kalarin(a)"/>
<word l="mq" v="engwa²"/>
<word l="mq" v="falmar(in)"/>
<word l="mq" v="halatir(no)"/>
<word l="mq" v="qantien"/>
<word l="mq" v="i²"/>
<word l="mq" v="-ite"/>
<word l="mq" v="kulina"/>
<word l="mq" v="lá¹"/>
<word l="mq" v="lau(me)"/>
<word l="mq" v="mai(y)a"/>
<word l="mq" v="mar(dar)"/>
<word l="mq" v="meren(de)"/>
<word l="mq" v="minqetyarme"/>
<word l="mq" v="nan"/>
<word l="mq" v="nár(e)"/>
<word l="mq" v="-(n)dil"/>
<word l="mq" v="nelke"/>
<word l="mq" v="nó²"/>
<word l="mq" v="nu"/>
<word l="mq" v="númen"/>
<word l="mq" v="nyar(a)-"/>
<word l="mq" v="sinome"/>
<word l="eq" v="alkar(in)"/>
<word l="eq" v="am(u)-"/>
<word l="eq" v="(a)mapta-"/>
<word l="eq" v="Ambalar"/>
<word l="eq" v="amun"/>
<word l="mq" v="al(a)-"/>
<word l="mq" v="ola-"/>
<word l="mq" v="alkar(e)"/>
<word l="mq" v="yen(de)"/>
<word l="mq" v="yár"/>
<word l="mq" v="vai(y)a"/>
<word l="mq" v="vaháya"/>
<word l="mq" v="-(u)va"/>
<word l="mq" v="úmahta(le)"/>
<word l="mq" v="tet(ta)"/>
<word l="mq" v="tasar(e)"/>
<word l="mq" v="tankil"/>
<word l="mq" v="-sta¹"/>
<word l="mq" v="sí"/>
<word l="mq" v="-(á)re"/>
<word l="mq" v="Qenya"/>
<word l="mq" v="qentaro"/>
<word l="mq" v="qenta"/>
<word l="mq" v="qár(e)"/>
<word l="mq" v="orro¹"/>
<word l="mq" v="o-"/>
</exclusions>
for $word in c:lang-words(/*, $l)
    [not(contains(c:get-speech(.), 'phon'))][not(contains(c:get-speech(.), 'name'))]
    [not(contains(c:get-speech(.), 'grammar'))][not(contains(c:get-speech(.), 'text'))][not(contains(c:get-speech(.), 'phrase'))]
    [count(distinct-values(ref[not(inflect)][not(contains(@mark, '†'))][not(contains(@mark, '-'))][not(contains(@mark, '|'))]
    [not(correction)][not(change)]/@v/translate(c:normalize-for-sort(.), '’', ''))) gt 1]
let $variants := string-join(distinct-values($word/ref[not(inflect)][not(contains(@mark, '†'))][not(contains(@mark, '-'))][not(contains(@mark, '|'))][not(correction)]/@v
    [not(translate(c:normalize-for-sort(.), 'c()|', 'k') = c:normalize-for-sort(translate($word/@v, 'c¹²³', 'k')))]/translate(lower-case(.), 'ë-', 'e')), '; ')
let $see-refs := string-join($word/ancestor-or-self::word[last()]//
    word[see[@v = $word/@v and @l = $word/@l]]/@v/translate(lower-case(.), '¹²³', ''), '; ')
return
if (translate($variants, 'ăĕĭŏŭāēīōūök-[]()·', 'aeiouáéíóúoc') = translate($see-refs, 'ëö()-', 'eo')) then () else
if ($exclusions/word[@l = $word/@l and @v=$word/@v]) then () else
<tr>
<td>&lt;word l="{c:get-lang($word)}" v="{c:print-word($word, <print-word show-link="y"/>)}"</td>
<td>{$variants}</td>
<td>{$see-refs}</td>
</tr>
} </table>
</body>
</html>
