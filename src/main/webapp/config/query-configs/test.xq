import module namespace c = "common.xq" at "common.xq";

<html>
<body>
<table> {
let $l := 'eq'
let $exclusions := <exclusions>
<word l="eq" v="filqe"/>
<word l="eq" v="fandor"/>
<word l="eq" v="falas(se)"/>
<word l="eq" v="erus(ta)"/>
<word l="eq" v="ettanu"/>
<word l="eq" v="en(we)"/>
<word l="eq" v="enqesto"/>
<word l="eq" v="enqest(y)a"/>
<word l="eq" v="ea(r)"/>
<word l="eq" v="lutu-"/>
<word l="eq" v="tyú(ta)"/>
<word l="eq" v="kirya"/>
<word l="eq" v="kili-"/>
<word l="eq" v="kelu(me)"/>
<word l="eq" v="kara-"/>
<word l="eq" v="aurqil(e)a"/>
<word l="eq" v="at-"/>
<word l="eq" v="asampe(a)"/>
<word l="eq" v="har(e)"/>
<word l="eq" v="ar(a)"/>
<word l="eq" v="angaisin(i)e"/>
<word l="eq" v="ando(n)"/>
<word l="eq" v="ande(a)"/>
<word l="eq" v="ari-"/>
<word l="eq" v="an(a)"/>
<word l="eq" v="ambi"/>
<word l="eq" v="tarqin(a)"/>
<word l="en" v="tum(b)"/>
<word l="en" v="lhigen"/>
<word l="en" v="tham(b)"/>
<word l="en" v="gaug"/>
<word l="en" v="orvath"/>
<word l="g" v="-win"/>
<word l="en" v="nen(n)"/>
<word l="en" v="mig"/>
<word l="en" v="lhim(p)"/>
<word l="en" v="lham(b)"/>
<word l="en" v="go-"/>
<word l="en" v="glavaith"/>
<word l="en" v="glam(m)"/>
<word l="en" v="fionwin"/>
<word l="en" v="fan(d)"/>
<word l="en" v="e(i)ngion"/>
<word l="en" v="elven"/>
<word l="en" v="elvain(n)"/>
<word l="en" v="Uidhel"/>
<word l="en" v="dram(b)"/>
<word l="en" v="dam(b)"/>
<word l="en" v="dag-"/>
<word l="en" v="cum(b)"/>
<word l="en" v="bhraig"/>
<word l="en" v="ornoth"/>
<word l="en" v="am(b)red"/>
<word l="en" v="awes"/>
<word l="en" v="am(m)arth"/>
<word l="q" v="cirya¹"/>
<word l="q" v="cuivië¹"/>
<word l="g" v="Gwalthir"/>
<word l="g" v="u"/>
<word l="g" v="u-"/>
<word l="g" v="duilin(g)"/>
<word l="g" v="tôb(a)"/>
<word l="g" v="adr(a)"/>
<word l="g" v="-(o)th"/>
<word l="g" v="tess(il)"/>
<word l="g" v="talgrin(d)"/>
<word l="g" v="ain²"/>
<word l="g" v="si(n)-"/>
<word l="g" v="-(r)on"/>
<word l="g" v="ress"/>
<word l="g" v="ren(d)"/>
<word l="g" v="-(r)in"/>
<word l="g" v="oth"/>
<word l="g" v="osp(a)"/>
<word l="g" v="olod"/>
<word l="g" v="ol"/>
<word l="g" v="-r(i)ol"/>
<word l="g" v="-(i)ol"/>
<word l="g" v="-odro(n)"/>
<word l="g" v="nio(s)"/>
<word l="g" v="-(n)ir"/>
<word l="g" v="nig(la)"/>
<word l="g" v="ni-"/>
<word l="g" v="nethli"/>
<word l="g" v="nenn"/>
<word l="g" v="deldron"/>
<word l="g" v="na"/>
<word l="g" v="moth(in)"/>
<word l="g" v="môna"/>
<word l="g" v="mavwin¹"/>
<word l="g" v="mar(o)n"/>
<word l="g" v="loda-"/>
<word l="g" v="limp(elis)"/>
<word l="g" v="elf(in)"/>
<word l="g" v="laith(r)a-"/>
<word l="g" v="(g)leg"/>
<word l="g" v="laib"/>
<word l="g" v="ir"/>
<word l="g" v="bo(n)"/>
<word l="g" v="-(i)on"/>
<word l="g" v="in-"/>
<word l="g" v="ilt-"/>
<word l="g" v="idhr(a)"/>
<word l="g" v="alc(hor)"/>
<word l="g" v="-iont(ha)"/>
<word l="g" v="i"/>
<word l="g" v="hum(i)los"/>
<word l="g" v="dauth(r)a-"/>
<word l="g" v="hal(a)-"/>
<word l="g" v="hab(in)"/>
<word l="g" v="gwiw"/>
<word l="g" v="gwer-"/>
<word l="g" v="gwen(n)"/>
<word l="g" v="gwin"/>
<word l="g" v="gwembel"/>
<word l="g" v="gwe-"/>
<word l="g" v="gwarin(n)"/>
<word l="g" v="gwar(e)dhon"/>
<word l="g" v="gwar(e)dhir"/>
<word l="g" v="gurth(u)"/>
<word l="g" v="govin(d)riol"/>
<word l="g" v="gonothri(n)"/>
<word l="g" v="Golda"/>
<word l="g" v="olf(in)"/>
<word l="g" v="godaithri(o)n"/>
<word l="g" v="go-¹"/>
<word l="g" v="glo(r)nethlin"/>
<word l="g" v="-glin"/>
<word l="g" v="glen(n)"/>
<word l="g" v="glar(os)"/>
<word l="g" v="glant(hi)"/>
<word l="g" v="glair"/>
<word l="g" v="gima-"/>
<word l="g" v="gerd(h)olm"/>
<word l="g" v="gar(th)"/>
<word l="g" v="fuglas"/>
<word l="g" v="gam(m)a-"/>
<word l="g" v="gal(a)"/>
<word l="g" v="glarw(ed)"/>
<word l="g" v="gad(a)"/>
<word l="g" v="fuior"/>
<word l="g" v="fini(o)s"/>
<word l="g" v="finn"/>
<word l="g" v="bilin(c)"/>
<word l="g" v="fidhrad"/>
<word l="g" v="far(o)n"/>
<word l="g" v="tuil"/>
<word l="g" v="er(e)tha-"/>
<word l="g" v="eng(a)"/>
<word l="g" v="elm(en)"/>
<word l="g" v="el(u)m"/>
<word l="g" v="aithla-"/>
<word l="g" v="ecthel(uin)"/>
<word l="g" v="aithl"/>
<word l="g" v="est(i)rin"/>
<word l="g" v="egli(n)"/>
<word l="g" v="edh"/>
<word l="g" v="cwivros"/>
<word l="g" v="dorn(a)"/>
<word l="g" v="cwim(ri)"/>
<word l="g" v="cris(s)"/>
<word l="g" v="crunc"/>
<word l="g" v="clum(mi)"/>
<word l="g" v="cing(win)"/>
<word l="g" v="-chi"/>
<word l="g" v="carn(in)"/>
<word l="g" v="brin(in)"/>
<word l="g" v="bros(s)"/>
<word l="g" v="bron(n)"/>
<word l="g" v="bar(n)a-"/>
<word l="g" v="martion"/>
<word l="g" v="ba"/>
<word l="g" v="ausin"/>
<word l="g" v="avosaith"/>
<word l="g" v="aur(a)"/>
<word l="g" v="arin(g)"/>
<word l="g" v="a"/>
<word l="g" v="anthor(in)"/>
<word l="g" v="annor(in)"/>
<word l="g" v="mart(os)"/>
<word l="g" v="alw(eg)"/>
<word l="g" v="alfuil(in)"/>
<word l="g" v="aglar(i)ol"/>
<word l="g" v="air(in)"/>
<word l="g" v="usc"/>
<word l="g" v="(n)ada"/>
<word l="s" v="aen"/>
<word l="s" v="a¹"/>
<word l="s" v="alph"/>
<word l="s" v="and"/>
<word l="s" v="annon"/>
<word l="s" v="ar(a)-"/>
<word l="s" v="athae"/>
<word l="s" v="ent"/>
<word l="s" v="canthui"/>
<word l="s" v="cîw"/>
<word l="s" v="cû"/>
<word l="s" v="dol(l)"/>
<word l="s" v="dúath"/>
<word l="s" v="Edhel"/>
<word l="s" v="Eledh"/>
<word l="s" v="êl"/>
<word l="s" v="en¹"/>
<word l="s" v="enedh"/>
<word l="s" v="esten(t)"/>
<word l="s" v="gaearon"/>
<word l="s" v="galadh"/>
<word l="s" v="glan(n)"/>
<word l="s" v="glîn(n)"/>
<word l="s" v="Golodh"/>
<word l="s" v="golas"/>
<word l="s" v="golodh"/>
<word l="s" v="gwae(w)"/>
<word l="s" v="hadhro"/>
<word l="s" v="hadhwa-"/>
<word l="s" v="haudh"/>
<word l="s" v="heledh"/>
<word l="s" v="hí"/>
<word l="s" v="(h)lô"/>
<word l="s" v="hwâ"/>
<word l="s" v="i¹"/>
<word l="s" v="-ian(d)"/>
<word l="s" v="-iel¹"/>
<word l="s" v="-ion²"/>
<word l="s" v="lam"/>
<word l="s" v="lass"/>
<word l="s" v="lind¹"/>
<word l="s" v="loss"/>
<word l="s" v="mêd(h)"/>
<word l="s" v="men¹"/>
<word l="s" v="míriel"/>
<word l="s" v="nalla"/>
<word l="s" v="neledh"/>
<word l="s" v="nin"/>
<word l="s" v="nos(s)"/>
<word l="s" v="ogol"/>
<word l="s" v="Orbelain"/>
<word l="s" v="othui"/>
<word l="s" v="Orgaladhad"/>
<word l="s" v="othgar(ed)"/>
<word l="s" v="othol"/>
<word l="s" v="rem"/>
<word l="s" v="rhûn"/>
<word l="s" v="teitha-"/>
<word l="s" v="thind"/>
<word l="s" v="thoron"/>
<word l="s" v="tolodh"/>
<word l="n" v="orchal"/>
<word l="n" v="-(i)ol"/>
<word l="n" v="hae"/>
<word l="n" v="merilin(n)"/>
<word l="n" v="lham(b)"/>
<word l="n" v="-iel"/>
<word l="n" v="forn(en)"/>
<word l="n" v="heledir(n)"/>
<word l="n" v="haudh"/>
<word l="n" v="hann"/>
<word l="n" v="glaer"/>
<word l="n" v="galadh"/>
<word l="n" v="oer"/>
<word l="n" v="dúlin(n)"/>
<word l="n" v="car(dh)"/>
<word l="n" v="ambenn"/>
<word l="q" v="yondë"/>
<word l="q" v="yó(m)"/>
<word l="q" v="-xë¹"/>
<word l="q" v="wingë"/>
<word l="q" v="wendë"/>
<word l="q" v="-wë"/>
<word l="q" v="vaiwë"/>
<word l="q" v="úvanë(a)"/>
<word l="q" v="usquë"/>
<word l="q" v="ua-"/>
<word l="q" v="-ttë¹"/>
<word l="q" v="to(lo)sta"/>
<word l="q" v="tillë"/>
<word l="q" v="tassë"/>
<word l="q" v="tasar(ë)"/>
<word l="q" v="tar(a)"/>
<word l="q" v="tar(a)"/>
<word l="q" v="-tar"/>
<word l="q" v="tancal(a)"/>
<word l="q" v="tal(da)"/>
<word l="q" v="talda"/>
<word l="q" v="tai¹"/>
<word l="q" v="sís"/>
<word l="q" v="-ilco"/>
<word l="q" v="siar(ë)"/>
<word l="q" v="sir(a)"/>
<word l="q" v="sá"/>
<word l="q" v="ron(go)"/>
<word l="q" v="-rya¹"/>
<word l="q" v="ro-"/>
<word l="q" v="-r(o)"/>
<word l="q" v="riel(lë)"/>
<word l="q" v="rauco"/>
<word l="q" v="quín(ë)"/>
<word l="q" v="qui"/>
<word l="q" v="quet-"/>
<word l="q" v="Quenyarin"/>
<word l="q" v="Quenya"/>
<word l="q" v="quenta"/>
<word l="q" v="Quendë"/>
<word l="q" v="quén"/>
<word l="q" v="quár(ë)"/>
<word l="q" v="cëa(n)"/>
<word l="q" v="palantír"/>
<word l="q" v="otso"/>
<word l="q" v="o(to)sta"/>
<word l="q" v="ontari(l)"/>
<word l="q" v="omentië"/>
<word l="q" v="olass(i)ë"/>
<word l="q" v="oia(la)"/>
<word l="q" v="-nta"/>
<word l="q" v="nos(së)"/>
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
    [count(distinct-values(ref[not(inflect)][not(contains(@mark, '†'))][not(contains(@mark, '-'))][not(contains(@mark, '|'))][not(contains(@mark, '?'))][not(contains(@mark, '‽'))][not(contains(@mark, '**'))]
    [not(correction)][not(change)]/@v/translate(c:normalize-for-sort(.), '’', ''))) gt 1]
let $variants := string-join(distinct-values($word/ref[not(inflect)][not(contains(@mark, '†'))][not(contains(@mark, '-'))][not(contains(@mark, '|'))][not(contains(@mark, '?'))][not(contains(@mark, '‽'))][not(contains(@mark, '**'))][not(correction)]/@v
    [not(c:normalize-for-sort(translate(., 'c()|¹²³', 'k')) = c:normalize-for-sort(translate($word/@v, 'c¹²³', 'k')))]/translate(lower-case(.), 'ūë-', 'úe')), '; ')
let $see-refs := string-join($word/ancestor-or-self::word[last()]//
    word[see[@v = $word/@v and @l = $word/@l]]/@v/translate(lower-case(.), '¹²³⁴', ''), '; ')
return
if (translate($variants, 'ăĕĭŏŭāēīōūökʼ-[]()·¹²', 'aeiouáéíóúoc') = translate($see-refs, 'ëök[]()-', 'eoc')) then () else
if ($exclusions/word[@l = $word/@l and @v=$word/@v]) then () else
<tr>
<td>&lt;word l="{c:get-lang($word)}" v="{c:print-word($word, <print-word show-link="y"/>)}"</td>
<td>{$variants}</td>
<td>{$see-refs}</td>
</tr>
} </table>
</body>
</html>
