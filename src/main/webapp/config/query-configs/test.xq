import module namespace c = "common.xq" at "common.xq";

<html>
<body>
<div> {
for $ref in //word[not(@speech)][not(ancestor::word[@speech][1]/@speech)]
return <p>{$ref/@v/string()}</p>
} </div>
</body>
</html>

(:
declare function local:showPE17QRef($value as node()) as xs:string {
    let $v1 := translate($value, ',', '')
    let $v2 := replace($v1, 'pl1\. ', '')
    let $v3 := replace($v2, 'pl2\. ', '')
    let $v4 := replace($v3, 'DG\*', '')
    let $v5 := replace($v4, 'pl\. ', '')
    let $v6 := replace($v5, 'pl1 ', '')
    let $v7 := replace($v6, 'du. ', '')
    let $v8 := replace($v7, "'", "’")
    let $v9 := replace($v8, "arch. ", "")
    return $v9
};

declare function local:showPE17QSource($value as node()) as xs:string {
    let $v1 := translate($value, '/[]', ':')
    let $v2 := replace($v1, 'PE17:', '0')
    let $v3 := replace($v2, '0([0-9][0-9][0-9])', '$1')
    return $v3
};

declare function local:rowId($row as element()) as xs:string {
    let $source := substring-before(concat(substring-before(concat($row/td[2], ':'), ':'), '-'), '-')
    let $value := lower-case(substring-before(concat($row/td[1], '/'), '/')) 
    let $value2 := translate($value, 'ŋĺkâêîôûāēīōūăĕĭŏŭäëïöü()[]-¯+', 'ñícáéíóúáéíóúaeiouaeiou')
    let $value3 := replace($value2, 'þ', 'th')
    let $value4 := replace($value3, 'x', 'cs')
    let $value5 := replace($value4, 'q', 'qu')
    let $value6 := replace($value5, 'quu', 'qu')
    return concat(normalize-space($source), '|', normalize-space($value6))
};

declare variable $PE17Q := doc('/Users/pfstrack/Dropbox/quenya-web/web/data/PE17Q.xml');

<html>
<body> {
let $t1 :=
    <table> { (
    <tr><td>i</td><td>013</td></tr>,
    <tr><td>lúmenn[a]</td><td>013</td></tr>,
    <tr><td>elen</td><td>014</td></tr>,
    <tr><td>sile</td><td>014</td></tr>,
    <tr><td>Elendil</td><td>015</td></tr>,
    <tr><td>Númenóre</td><td>015</td></tr>,
    <tr><td>nelya</td><td>017</td></tr>,
    <tr><td>Lúna</td><td>022</td></tr>,
    <tr><td>eldi</td><td>025</td></tr>,
    <tr><td>Taníquetil</td><td>026</td></tr>,
    <tr><td>Foro-</td><td>028</td></tr>,
    <tr><td>Hyara-</td><td>028</td></tr>,
    <tr><td>nan(do)</td><td>028</td></tr>,
    <tr><td>Nand’</td><td>028</td></tr>,
    <tr><td>Ondoluncava</td><td>028</td></tr>,
    <tr><td>Ondolin</td><td>029</td></tr>,
    <tr><td>Vaire</td><td>033</td></tr>,
    <tr><td>telperin</td><td>042</td></tr>,
    <tr><td>tegmá</td><td>043</td></tr>,
    <tr><td>aranion</td><td>049</td></tr>,
    <tr><td>malat-</td><td>051</td></tr>,
    <tr><td>malta-</td><td>051</td></tr>,
    <tr><td>ninda-</td><td>052</td></tr>,
    <tr><td>anga</td><td>056</td></tr>,
    <tr><td>elda</td><td>056</td></tr>,
    <tr><td>eleni</td><td>056</td></tr>,
    <tr><td>ep’</td><td>056</td></tr>,
    <tr><td>laica</td><td>056</td></tr>,
    <tr><td>torna</td><td>056</td></tr>,
    <tr><td>an</td><td>057</td></tr>,
    <tr><td>ana</td><td>057</td></tr>,
    <tr><td>anamelda</td><td>057</td></tr>,
    <tr><td>ancalima</td><td>057</td></tr>,
    <tr><td>ari-</td><td>057</td></tr>,
    <tr><td>arimelda</td><td>057</td></tr>,
    <tr><td>elda</td><td>057</td></tr>,
    <tr><td>elenion</td><td>057</td></tr>,
    <tr><td>epe</td><td>057</td></tr>,
    <tr><td>ep’</td><td>057</td></tr>,
    <tr><td>-illatar</td><td>057</td></tr>,
    <tr><td>-iltar(o)</td><td>057</td></tr>,
    <tr><td>na</td><td>057</td></tr>,
    <tr><td>vanima</td><td>057</td></tr>,
    <tr><td>vanimelda</td><td>057</td></tr>,
    <tr><td>vanya</td><td>057</td></tr>,
    <tr><td>kiryando</td><td>058</td></tr>,
    <tr><td>tar</td><td>058</td></tr>,
    <tr><td>-tye</td><td>058</td></tr>,
    <tr><td>-tie</td><td>058</td></tr>,
    <tr><td>á na</td><td>058</td></tr>,
    <tr><td>-ie</td><td>059</td></tr>,
    <tr><td>lintie</td><td>059</td></tr>,
    <tr><td>lintierya(nen)</td><td>059</td></tr>,
    <tr><td>mára</td><td>059</td></tr>,
    <tr><td>mārie</td><td>059</td></tr>,
    <tr><td>Naldariel(lle)</td><td>059</td></tr>,
    <tr><td>na mārie</td><td>059</td></tr>,
    <tr><td>namárië</td><td>059</td></tr>,
    <tr><td>norne</td><td>059</td></tr>,
    <tr><td>lanya</td><td>060</td></tr>,
    <tr><td>-i</td><td>062</td></tr>,
    <tr><td>-r</td><td>062</td></tr>,
    <tr><td>av|va</td><td>063</td></tr>,
    <tr><td>mar vanwa tyalieva</td><td>064</td></tr>,
    <tr><td>oromardi</td><td>064</td></tr>,
    <tr><td>vanwa</td><td>064</td></tr>,
    <tr><td>yulda</td><td>064</td></tr>,
    <tr><td>i</td><td>065</td></tr>,
    <tr><td>lann’</td><td>065</td></tr>,
    <tr><td>pallan</td><td>065</td></tr>,
    <tr><td>pelo</td><td>065</td></tr>,
    <tr><td>tintalle</td><td>066</td></tr>,
    <tr><td>eldi</td><td>067</td></tr>,
    <tr><td>eleni</td><td>067</td></tr>,
    <tr><td>Elentári</td><td>067</td></tr>,
    <tr><td>Vardo</td><td>067</td></tr>,
    <tr><td>cari-nwa</td><td>068</td></tr>,
    <tr><td>carya</td><td>068</td></tr>,
    <tr><td>matya</td><td>068</td></tr>,
    <tr><td>melu</td><td>068</td></tr>,
    <tr><td>ađ</td><td>071</td></tr>,
    <tr><td>ař</td><td>071</td></tr>,
    <tr><td>ta</td><td>071</td></tr>,
    <tr><td>yo</td><td>071</td></tr>,
    <tr><td>ar</td><td>072</td></tr>,
    <tr><td>Calacirian</td><td>073</td></tr>,
    <tr><td>i falmalinnar</td><td>073</td></tr>,
    <tr><td>míri</td><td>073</td></tr>,
    <tr><td>-r</td><td>073</td></tr>,
    <tr><td>undu-</td><td>073</td></tr>,
    <tr><td>-ndo</td><td>074</td></tr>,
    <tr><td>Eru</td><td>075</td></tr>,
    <tr><td>-lmo</td><td>075</td></tr>,
    <tr><td>aire</td><td>076</td></tr>,
    <tr><td>-arya</td><td>076</td></tr>,
    <tr><td>elye</td><td>076</td></tr>,
    <tr><td>fanyar</td><td>076</td></tr>,
    <tr><td>i·</td><td>076</td></tr>,
    <tr><td>lassi</td><td>076</td></tr>,
    <tr><td>linte</td><td>076</td></tr>,
    <tr><td>lírinen</td><td>076</td></tr>,
    <tr><td>met</td><td>076</td></tr>,
    <tr><td>-t</td><td>076</td></tr>,
    <tr><td>tier</td><td>076</td></tr>,
    <tr><td>tári</td><td>076</td></tr>,
    <tr><td>tário</td><td>076</td></tr>,
    <tr><td>unótime</td><td>076</td></tr>,
    <tr><td>-va</td><td>076</td></tr>,
    <tr><td>ve</td><td>076</td></tr>,
    <tr><td>ómo</td><td>076</td></tr>,
    <tr><td>hentie</td><td>077</td></tr>,
    <tr><td>hentá</td><td>077</td></tr>,
    <tr><td>parma</td><td>077</td></tr>,
    <tr><td>li-</td><td>081</td></tr>,
    <tr><td>lómea</td><td>081</td></tr>,
    <tr><td>Nantasarion</td><td>081</td></tr>,
    <tr><td>-nor</td><td>081</td></tr>,
    <tr><td>th-/sáne-</td><td>081</td></tr>,
    <tr><td>morna</td><td>082</td></tr>,
    <tr><td>carni-</td><td>083</td></tr>,
    <tr><td>farni</td><td>083</td></tr>,
    <tr><td>Altáriel</td><td>084</td></tr>,
    <tr><td>Cala</td><td>084</td></tr>,
    <tr><td>Caltariel</td><td>084</td></tr>,
    <tr><td>laicá</td><td>084</td></tr>,
    <tr><td>laiqua</td><td>084</td></tr>,
    <tr><td>laiqua</td><td>084</td></tr>,
    <tr><td>pálan-tìr</td><td>086</td></tr>,
    <tr><td>tíra</td><td>086</td></tr>,
    <tr><td>lômí</td><td>087</td></tr>,
    <tr><td>Incánus</td><td>088</td></tr>,
    <tr><td>am</td><td>090</td></tr>,
    <tr><td>añ-</td><td>090</td></tr>,
    <tr><td>Earendil</td><td>090</td></tr>,
    <tr><td>na</td><td>090</td></tr>,
    <tr><td>ná</td><td>090</td></tr>,
    <tr><td>ankalima</td><td>091</td></tr>,
    <tr><td>eleni</td><td>091</td></tr>,
    <tr><td>elenion</td><td>091</td></tr>,
    <tr><td>illi</td><td>091</td></tr>,
    <tr><td>imb’</td><td>091</td></tr>,
    <tr><td>lá</td><td>091</td></tr>,
    <tr><td>quetta</td><td>091</td></tr>,
    <tr><td>lango</td><td>092</td></tr>,
    <tr><td>Pelóri</td><td>092</td></tr>,
    <tr><td>anta</td><td>093</td></tr>,
    <tr><td>ricir</td><td>094</td></tr>,
    <tr><td>lepne</td><td>095</td></tr>,
    <tr><td>otso</td><td>096</td></tr>,
    <tr><td>aranion</td><td>100</td></tr>,
    <tr><td>asea</td><td>100</td></tr>,
    <tr><td>ar</td><td>103</td></tr>,
    <tr><td>ṃbartā</td><td>104</td></tr>,
    <tr><td>umbar(ǝ)+í</td><td>104</td></tr>,
    <tr><td>Arda</td><td>105</td></tr>,
    <tr><td>sundóma</td><td>105</td></tr>,
    <tr><td>mbār</td><td>106</td></tr>,
    <tr><td>már</td><td>106</td></tr>,
    <tr><td>-nor</td><td>107</td></tr>,
    <tr><td>nóre</td><td>107</td></tr>,
    <tr><td>nôr</td><td>107</td></tr>,
    <tr><td>cauma</td><td>108</td></tr>,
    <tr><td>koa</td><td>108</td></tr>,
    <tr><td>taman/tamna</td><td>108</td></tr>,
    <tr><td>martam-</td><td>109</td></tr>,
    <tr><td>onos</td><td>111</td></tr>,
    <tr><td>Celec-ormë</td><td>112</td></tr>,
    <tr><td>Orome</td><td>112</td></tr>,
    <tr><td>írime</td><td>112</td></tr>,
    <tr><td>itaril</td><td>112</td></tr>,
    <tr><td>kazma</td><td>114</td></tr>,
    <tr><td>Eldă-kār(ă)</td><td>114</td></tr>,
    <tr><td>Eldar</td><td>114</td></tr>,
    <tr><td>Vala</td><td>114</td></tr>,
    <tr><td>hrōn</td><td>115</td></tr>,
    <tr><td>Voronwe</td><td>115</td></tr>,
    <tr><td>kāno</td><td>117</td></tr>,
    <tr><td>Ingoldofinwe</td><td>118</td></tr>,
    <tr><td>yestarë</td><td>120</td></tr>,
    <tr><td>sundóma</td><td>124</td></tr>,
    <tr><td>tur-</td><td>124</td></tr>,
    <tr><td>Ñoldorin</td><td>125</td></tr>,
    <tr><td>ūpa-nēn</td><td>126</td></tr>,
    <tr><td>ūpa-nēs</td><td>126</td></tr>,
    <tr><td>falma</td><td>127</td></tr>,
    <tr><td>-r</td><td>127</td></tr>,
    <tr><td>Sindarin</td><td>127</td></tr>,
    <tr><td>sí</td><td>127</td></tr>,
    <tr><td>lma</td><td>130</td></tr>,
    <tr><td>lme</td><td>130</td></tr>,
    <tr><td>met</td><td>130</td></tr>,
    <tr><td>omentielmo</td><td>130</td></tr>,
    <tr><td>vē-</td><td>130</td></tr>,
    <tr><td>hīsilōmi</td><td>133</td></tr>,
    <tr><td>Ondolinde</td><td>133</td></tr>,
    <tr><td>ʒalaðā</td><td>135</td></tr>,
    <tr><td>ʒalðā</td><td>135</td></tr>,
    <tr><td>aldarembina</td><td>136</td></tr>,
    <tr><td>aldaron</td><td>136</td></tr>,
    <tr><td>elme</td><td>136</td></tr>,
    <tr><td>ngwe</td><td>136</td></tr>,
    <tr><td>lou</td><td>137</td></tr>,
    <tr><td>lounē</td><td>137</td></tr>,
    <tr><td>lowon-</td><td>137</td></tr>,
    <tr><td>lōn</td><td>137</td></tr>,
    <tr><td>Arome</td><td>138</td></tr>,
    <tr><td>Quenya</td><td>138</td></tr>,
    <tr><td>queta</td><td>138</td></tr>,
    <tr><td>ū</td><td>144</td></tr>,
    <tr><td>ún/unye</td><td>144</td></tr>,
    <tr><td>əu</td><td>144</td></tr>,
    <tr><td>al-</td><td>146</td></tr>,
    <tr><td>alma</td><td>146</td></tr>,
    <tr><td>andamacilba</td><td>147</td></tr>,
    <tr><td>ar/ara/aran</td><td>147</td></tr>,
    <tr><td>ar/ara/aran</td><td>147</td></tr>,
    <tr><td>ari-</td><td>147</td></tr>,
    <tr><td>ciryalíva</td><td>147</td></tr>,
    <tr><td>Arda</td><td>150</td></tr>,
    <tr><td>Arda Vanya</td><td>150</td></tr>,
    <tr><td>Arda Úvana</td><td>150</td></tr>,
    <tr><td>eldi</td><td>151</td></tr>,
    <tr><td>eledā</td><td>152</td></tr>,
    <tr><td>liss-</td><td>154</td></tr>,
    <tr><td>hrúva</td><td>155</td></tr>,
    <tr><td>Ingwi</td><td>155</td></tr>,
    <tr><td>pole</td><td>155</td></tr>,
    <tr><td>kombe</td><td>158</td></tr>,
    <tr><td>okombe</td><td>158</td></tr>,
    <tr><td>lerta[n]</td><td>160</td></tr>,
    <tr><td>quete</td><td>160</td></tr>,
    <tr><td>ma</td><td>162</td></tr>,
    <tr><td>na</td><td>162</td></tr>,
    <tr><td>yé</td><td>162</td></tr>,
    <tr><td>á</td><td>162</td></tr>,
    <tr><td>áva</td><td>162</td></tr>,
    <tr><td>mār-</td><td>164</td></tr>,
    <tr><td>at-</td><td>166</td></tr>,
    <tr><td>nat</td><td>166</td></tr>,
    <tr><td>nattire</td><td>166</td></tr>,
    <tr><td>en</td><td>167</td></tr>,
    <tr><td>nor-</td><td>168</td></tr>,
    <tr><td>anel</td><td>170</td></tr>,
    <tr><td>anon</td><td>170</td></tr>,
    <tr><td>-el</td><td>170</td></tr>,
    <tr><td>-en</td><td>170</td></tr>,
    <tr><td>-ien</td><td>170</td></tr>,
    <tr><td>-ion</td><td>170</td></tr>,
    <tr><td>-on</td><td>170</td></tr>,
    <tr><td>sel-de</td><td>170</td></tr>,
    <tr><td>yon-do</td><td>170</td></tr>,
    <tr><td>parna</td><td>171</td></tr>,
    <tr><td>pende-</td><td>171</td></tr>,
    <tr><td>al-</td><td>172</td></tr>,
    <tr><td>arra</td><td>172</td></tr>,
    <tr><td>asra</td><td>172</td></tr>,
    <tr><td>asa-</td><td>172</td></tr>,
    <tr><td>hra</td><td>172</td></tr>,
    <tr><td>koainen</td><td>174</td></tr>,
    <tr><td>fanya</td><td>174</td></tr>,
    <tr><td>koainen</td><td>174</td></tr>,
    <tr><td>Maiar</td><td>174</td></tr>,
    <tr><td>quenderinwa</td><td>174</td></tr>,
    <tr><td>Valar</td><td>174</td></tr>,
    <tr><td>ar</td><td>175</td></tr>,
    <tr><td>fanainen</td><td>175</td></tr>,
    <tr><td>fantaner</td><td>175</td></tr>,
    <tr><td>Maiar</td><td>175</td></tr>,
    <tr><td>Maiaron</td><td>175</td></tr>,
    <tr><td>nassentar</td><td>175</td></tr>,
    <tr><td>quenderinwe</td><td>175</td></tr>,
    <tr><td>Valar</td><td>175</td></tr>,
    <tr><td>Valaron</td><td>175</td></tr>,
    <tr><td>ve</td><td>175</td></tr>,
    <tr><td>fana</td><td>176</td></tr>,
    <tr><td>fanar</td><td>176</td></tr>,
    <tr><td>fanta-</td><td>176</td></tr>,
    <tr><td>koar</td><td>177</td></tr>,
    <tr><td>emma</td><td>179</td></tr>,
    <tr><td>fanar</td><td>179</td></tr>,
    <tr><td>indemmar</td><td>179</td></tr>,
    <tr><td>quanta</td><td>179</td></tr>,
    <tr><td>nŏr</td><td>181</td></tr>,
    <tr><td>nār-</td><td>183</td></tr>,
    <tr><td>ruine</td><td>183</td></tr>,
    <tr><td>-ea</td><td>186</td></tr>,
    <tr><td>orwa</td><td>186</td></tr>,
    <tr><td>taniquetil</td><td>186</td></tr>,
    <tr><td>Elda</td><td>189</td></tr>,
    <tr><td>Elwë</td><td>189</td></tr>,
    <tr><td>waiwe</td><td>189</td></tr>,
    <tr><td>iel</td><td>190</td></tr>,
    <tr><td>Manwe</td><td>190</td></tr>,
    <tr><td>-uell-</td><td>190</td></tr>,
    <tr><td>vehte</td><td>190</td></tr>,
    <tr><td>Voronwë</td><td>190</td></tr>,
    <tr><td>wehte</td><td>190</td></tr>,
    <tr><td>-wel</td><td>190</td></tr>,
    <tr><td>-well-</td><td>190</td></tr>,
    <tr><td>-wend-</td><td>190</td></tr>,
    <tr><td>we’kā</td><td>190</td></tr>,
    <tr><td>we’te</td><td>190</td></tr>,
    <tr><td>-wē</td><td>190</td></tr>,
    <tr><td>wista-</td><td>191</td></tr>,
    for $ref in $PE17Q/*/ref
    let $source := local:showPE17QSource($ref/@source)
    let $source2 := substring-after($source, ':')
    let $source3 := substring-after($source2, ':')
    let $source4 := substring-after($source3, ':')
    let $source5 := substring-after($source4, ':')
    let $source6 := substring-after($source5, ':')
    let $source7 := substring-after($source6, ':')
    return (
        if ($ref/@v != "") then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{$source}</td>
        </tr> else (),
        if ($ref/@v != "" and $source2) then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{replace(concat('0', $source2), '0([0-9][0-9][0-9])', '$1')}</td>
        </tr> else (),
        if ($ref/@v != "" and $source3) then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{replace(concat('0', $source3), '0([0-9][0-9][0-9])', '$1')}</td>
        </tr> else (),
        if ($ref/@v != "" and $source4) then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{replace(concat('0', $source4), '0([0-9][0-9][0-9])', '$1')}</td>
        </tr> else (),
        if ($ref/@v != "" and $source5) then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{replace(concat('0', $source5), '0([0-9][0-9][0-9])', '$1')}</td>
        </tr> else (),
        if ($ref/@v != "" and $source6) then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{replace(concat('0', $source6), '0([0-9][0-9][0-9])', '$1')}</td>
        </tr> else (),
        if ($ref/@v != "" and $source7) then <tr source="GR">
            <td>{local:showPE17QRef($ref/@v)}</td>
            <td>{replace(concat('0', $source7), '0([0-9][0-9][0-9])', '$1')}</td>
        </tr> else (),
        if ($ref/@du != "") then <tr source="GR">
            <td>{local:showPE17QRef($ref/@du)}</td>
            <td>{$source}</td>
        </tr> else (),
        if ($ref/@p1 != "") then <tr source="GR">
            <td>{local:showPE17QRef($ref/@p1)}</td>
            <td>{$source}</td>
        </tr> else (),
        if ($ref/@p2 != "") then <tr source="GR">
            <td>{local:showPE17QRef($ref/@p2)}</td>
            <td>{$source}</td>
        </tr> else (),
        if ($ref/@inf != "") then <tr source="GR">
            <td>{local:showPE17QRef($ref/@inf)}</td>
            <td>{$source}</td>
        </tr> else ()
    ) ) }
    </table>
let $refs := //ref[c:get-lang(.)='q' or c:get-lang(.)='mq']
                  [starts-with(@source, 'PE17')]
                  [not(c:get-speech(.)='phrase')]
                  [not(c:get-speech(.)='grammar')]
                  [not(starts-with(c:get-speech(.), 'phon'))]
let $t2 :=
    <table> { (
    <tr><td>mátie</td><td>013</td></tr>,
    <tr><td>elwe</td><td>013</td></tr>,
    <tr><td>-lwa</td><td>014</td></tr>,
    <tr><td>-mma</td><td>014</td></tr>,
    <tr><td>-nwa</td><td>014</td></tr>,
    <tr><td>omentielman</td><td>014</td></tr>,
    <tr><td>omentielwa</td><td>014</td></tr>,
    <tr><td>ommentiemman</td><td>014</td></tr>,
    <tr><td>Númenor</td><td>015</td></tr>,
    <tr><td>delw</td><td>017</td></tr>,
    <tr><td>andú</td><td>018</td></tr>,
    <tr><td>Elendil</td><td>018</td></tr>,
    <tr><td>for-</td><td>018</td></tr>,
    <tr><td>hró-</td><td>018</td></tr>,
    <tr><td>hróme</td><td>018</td></tr>,
    <tr><td>Hrónatan</td><td>018</td></tr>,
    <tr><td>nú-</td><td>018</td></tr>,
    <tr><td>Núnatan</td><td>018</td></tr>,
    <tr><td>orró</td><td>018</td></tr>,
    <tr><td>Varsi</td><td>022</td></tr>,
    <tr><td>elen</td><td>023</td></tr>,
    <tr><td>eldi</td><td>024-5</td></tr>,
    <tr><td>wáya</td><td>034</td></tr>,
    <tr><td>miríma</td><td>037</td></tr>,
    <tr><td>aratá</td><td>039</td></tr>,
    <tr><td>Ithil</td><td>039</td></tr>,
    <tr><td>a</td><td>041</td></tr>,
    <tr><td>al</td><td>041</td></tr>,
    <tr><td>as</td><td>041</td></tr>,
    <tr><td>teñwa</td><td>043</td></tr>,
    <tr><td>teñwa</td><td>044</td></tr>,
    <tr><td>-nya</td><td>046</td></tr>,
    <tr><td>(malat-)</td><td>050-1</td></tr>,
    <tr><td>-da</td><td>051-2</td></tr>,
    <tr><td>-ta</td><td>051-2</td></tr>,
    <tr><td>-ta</td><td>052</td></tr>,
    <tr><td>Eleronde</td><td>056</td></tr>,
    <tr><td>anmelda</td><td>057</td></tr>,
    <tr><td>cari-</td><td>057</td></tr>,
    <tr><td>ilyan</td><td>057</td></tr>,
    <tr><td>ilyar</td><td>057</td></tr>,
    <tr><td>-llatar</td><td>057</td></tr>,
    <tr><td>-ltar(o)</td><td>057</td></tr>,
    <tr><td>-n</td><td>057</td></tr>,
    <tr><td>-s</td><td>057</td></tr>,
    <tr><td>tári or tar</td><td>057</td></tr>,
    <tr><td>lintierya</td><td>058</td></tr>,
    <tr><td>ómetiend-</td><td>058</td></tr>,
    <tr><td>linte</td><td>059</td></tr>,
    <tr><td>-n</td><td>059</td></tr>,
    <tr><td>Naldarielle</td><td>059-60</td></tr>,
    <tr><td>-llor</td><td>062</td></tr>,
    <tr><td>-nnar</td><td>062</td></tr>,
    <tr><td>-sser</td><td>062</td></tr>,
    <tr><td>aldar</td><td>063</td></tr>,
    <tr><td>av</td><td>063</td></tr>,
    <tr><td>oro</td><td>063</td></tr>,
    <tr><td>oromar</td><td>063</td></tr>,
    <tr><td>oronte</td><td>063</td></tr>,
    <tr><td>oronye</td><td>063</td></tr>,
    <tr><td>orto</td><td>063</td></tr>,
    <tr><td>órta-</td><td>063</td></tr>,
    <tr><td>órya</td><td>063</td></tr>,
    <tr><td>Róme</td><td>063</td></tr>,
    <tr><td>ambăr-</td><td>064</td></tr>,
    <tr><td>miruvore</td><td>064</td></tr>,
    <tr><td>núme</td><td>064</td></tr>,
    <tr><td>Númenor</td><td>064</td></tr>,
    <tr><td>Númenore</td><td>064</td></tr>,
    <tr><td>Oiolosse</td><td>064</td></tr>,
    <tr><td>Taniquetil</td><td>064</td></tr>,
    <tr><td>tyalie</td><td>064</td></tr>,
    <tr><td>Andune</td><td>065</td></tr>,
    <tr><td>pala</td><td>065</td></tr>,
    <tr><td>peltacse-</td><td>065</td></tr>,
    <tr><td>queren</td><td>065</td></tr>,
    <tr><td>-s</td><td>065</td></tr>,
    <tr><td>-r</td><td>066</td></tr>,
    <tr><td>airetári-lírinen</td><td>067</td></tr>,
    <tr><td>eldi or analogical eleni</td><td>067</td></tr>,
    <tr><td>-da</td><td>068</td></tr>,
    <tr><td>-na</td><td>068</td></tr>,
    <tr><td>-rya</td><td>069</td></tr>,
    <tr><td>-t</td><td>069</td></tr>,
    <tr><td>tar-</td><td>071</td></tr>,
    <tr><td>Róme</td><td>074</td></tr>,
    <tr><td>Vala</td><td>074</td></tr>,
    <tr><td>Valar</td><td>074</td></tr>,
    <tr><td>máryat</td><td>076</td></tr>,
    <tr><td>tancantealye</td><td>076</td></tr>,
    <tr><td>Tarquesta</td><td>076</td></tr>,
    <tr><td>ómarya</td><td>076</td></tr>,
    <tr><td>nacant</td><td>077</td></tr>,
    <tr><td>nanci-</td><td>077</td></tr>,
    <tr><td>ronye</td><td>077</td></tr>,
    <tr><td>malinorne</td><td>080</td></tr>,
    <tr><td>malinorneli</td><td>080</td></tr>,
    <tr><td>tháne-</td><td>081</td></tr>,
    <tr><td>walass</td><td>084</td></tr>,
    <tr><td>lange</td><td>091</td></tr>,
    <tr><td>lango</td><td>091</td></tr>,
    <tr><td>sen</td><td>091</td></tr>,
    <tr><td>Andúne</td><td>092</td></tr>,
    <tr><td>Calacirya</td><td>092</td></tr>,
    <tr><td>Oiolosse</td><td>092</td></tr>,
    <tr><td>-ta</td><td>093</td></tr>,
    <tr><td>ricir</td><td>093</td></tr>,
    <tr><td>enc-</td><td>095</td></tr>,
    <tr><td>lepen</td><td>095</td></tr>,
    <tr><td>otso</td><td>095</td></tr>,
    <tr><td>ale</td><td>100</td></tr>,
    <tr><td>ne</td><td>100</td></tr>,
    <tr><td>nes-</td><td>100</td></tr>,
    <tr><td>Atani</td><td>101</td></tr>,
    <tr><td>Cormacolindo</td><td>103</td></tr>,
    <tr><td>sundóma</td><td>104</td></tr>,
    <tr><td>-da</td><td>106</td></tr>,
    <tr><td>-mar</td><td>106</td></tr>,
    <tr><td>yulda</td><td>106</td></tr>,
    <tr><td>cauma</td><td>107</td></tr>,
    <tr><td>-ma</td><td>108</td></tr>,
    <tr><td>vanima</td><td>111</td></tr>,
    <tr><td>vanimali</td><td>111</td></tr>,
    <tr><td>ítaril</td><td>112</td></tr>,
    <tr><td>Ñorofinwe</td><td>112</td></tr>,
    <tr><td>cáno</td><td>113</td></tr>,
    <tr><td>Finican</td><td>113</td></tr>,
    <tr><td>Finicáno</td><td>113</td></tr>,
    <tr><td>Finwion</td><td>113</td></tr>,
    <tr><td>Finúcano</td><td>113</td></tr>,
    <tr><td>Ingoldo</td><td>113</td></tr>,
    <tr><td>-orna</td><td>113</td></tr>,
    <tr><td>Turucán</td><td>113</td></tr>,
    <tr><td>Turucáno</td><td>113</td></tr>,
    <tr><td>Ñolotar</td><td>113</td></tr>,
    <tr><td>melec-</td><td>115</td></tr>,
    <tr><td>polna</td><td>115</td></tr>,
    <tr><td>Arató</td><td>117</td></tr>,
    <tr><td>Artanil</td><td>117</td></tr>,
    <tr><td>Arto</td><td>117</td></tr>,
    <tr><td>Artor</td><td>117</td></tr>,
    <tr><td>Artó</td><td>117</td></tr>,
    <tr><td>Feanór</td><td>117</td></tr>,
    <tr><td>Fingoldo</td><td>117</td></tr>,
    <tr><td>Finicáno</td><td>117</td></tr>,
    <tr><td>Finwe</td><td>117</td></tr>,
    <tr><td>Ingoldo</td><td>117</td></tr>,
    <tr><td>Nilarto</td><td>117</td></tr>,
    <tr><td>Ingoldo Finwe</td><td>118</td></tr>,
    <tr><td>Fin-</td><td>119</td></tr>,
    <tr><td>Ancalo</td><td>126</td></tr>,
    <tr><td>Sindarin</td><td>126</td></tr>,
    <tr><td>an sí</td><td>127</td></tr>,
    <tr><td>Avari</td><td>127</td></tr>,
    <tr><td>Eldar</td><td>127</td></tr>,
    <tr><td>Linder</td><td>127</td></tr>,
    <tr><td>Quenya</td><td>127</td></tr>,
    <tr><td>Tuna</td><td>128</td></tr>,
    <tr><td>Túna</td><td>128</td></tr>,
    <tr><td>Noldorin</td><td>129</td></tr>,
    <tr><td>-s</td><td>129</td></tr>,
    <tr><td>Sindarin</td><td>129</td></tr>,
    <tr><td>Vanyarin</td><td>129</td></tr>,
    <tr><td>ve</td><td>130</td></tr>,
    <tr><td>we</td><td>130</td></tr>,
    <tr><td>wi</td><td>130</td></tr>,
    <tr><td>-yat</td><td>130</td></tr>,
    <tr><td>ómëo</td><td>130</td></tr>,
    <tr><td>aldarembina</td><td>135</td></tr>,
    <tr><td>aldaron</td><td>135</td></tr>,
    <tr><td>etye</td><td>135</td></tr>,
    <tr><td>-lye</td><td>135</td></tr>,
    <tr><td>ráma</td><td>135</td></tr>,
    <tr><td>-tye</td><td>135</td></tr>,
    <tr><td>quenda</td><td>137</td></tr>,
    <tr><td>lende</td><td>139</td></tr>,
    <tr><td>Nandor</td><td>139</td></tr>,
    <tr><td>Quende</td><td>139</td></tr>,
    <tr><td>Nandor</td><td>139</td></tr>,
    <tr><td>Quende</td><td>139</td></tr>,
    <tr><td>Noldor</td><td>140</td></tr>,
    <tr><td>Avamanyar</td><td>143</td></tr>,
    <tr><td>vá-</td><td>143</td></tr>,
    <tr><td>wanwa</td><td>143</td></tr>,
    <tr><td>áva</td><td>143</td></tr>,
    <tr><td>Úamanyar</td><td>143</td></tr>,
    <tr><td>vanima</td><td>144</td></tr>,
    <tr><td>úvanima</td><td>144</td></tr>,
    <tr><td>únotima</td><td>144</td></tr>,
    <tr><td>aina</td><td>146</td></tr>,
    <tr><td>lintaciryalíva</td><td>147</td></tr>,
    <tr><td>nin</td><td>147</td></tr>,
    <tr><td>-wa</td><td>147</td></tr>,
    <tr><td>ascalaste</td><td>148</td></tr>,
    <tr><td>auri-</td><td>148</td></tr>,
    <tr><td>Máyar</td><td>149</td></tr>,
    <tr><td>Valie</td><td>149</td></tr>,
    <tr><td>áyan</td><td>149</td></tr>,
    <tr><td>charina</td><td>150</td></tr>,
    <tr><td>Mindi</td><td>150</td></tr>,
    <tr><td>wanya</td><td>150</td></tr>,
    <tr><td>úcharin</td><td>150</td></tr>,
    <tr><td>Amandil</td><td>152</td></tr>,
    <tr><td>Cuiviénen</td><td>152</td></tr>,
    <tr><td>Valandil</td><td>152</td></tr>,
    <tr><td>walca</td><td>154</td></tr>,
    <tr><td>hróva</td><td>155</td></tr>,
    <tr><td>incánu</td><td>155</td></tr>,
    <tr><td>cente</td><td>156</td></tr>,
    <tr><td>combe</td><td>157</td></tr>,
    <tr><td>lauré-</td><td>159</td></tr>,
    <tr><td>lawar</td><td>159</td></tr>,
    <tr><td>lerta</td><td>160</td></tr>,
    <tr><td>lossi-</td><td>161</td></tr>,
    <tr><td>lossé-</td><td>161</td></tr>,
    <tr><td>-nta-ntat</td><td>161</td></tr>,
    <tr><td>-nte</td><td>161</td></tr>,
    <tr><td>ava márie</td><td>162</td></tr>,
    <tr><td>lungamaite</td><td>162</td></tr>,
    <tr><td>Ea</td><td>163</td></tr>,
    <tr><td>umbar</td><td>164</td></tr>,
    <tr><td>míri</td><td>165</td></tr>,
    <tr><td>míri</td><td>165</td></tr>,
    <tr><td>van-</td><td>165</td></tr>,
    <tr><td>wan-</td><td>165</td></tr>,
    <tr><td>atquet</td><td>166</td></tr>,
    <tr><td>nacca</td><td>166</td></tr>,
    <tr><td>otya</td><td>166</td></tr>,
    <tr><td>enda</td><td>167</td></tr>,
    <tr><td>néna</td><td>167</td></tr>,
    <tr><td>nén-talma</td><td>167</td></tr>,
    <tr><td>-r</td><td>167</td></tr>,
    <tr><td>hir</td><td>168</td></tr>,
    <tr><td>ninqui-</td><td>168</td></tr>,
    <tr><td>-nya</td><td>170</td></tr>,
    <tr><td>Manwe</td><td>174</td></tr>,
    <tr><td>Taniquetil</td><td>174</td></tr>,
    <tr><td>Varda</td><td>174</td></tr>,
    <tr><td>canta</td><td>175</td></tr>,
    <tr><td>cenima</td><td>175</td></tr>,
    <tr><td>coa</td><td>175</td></tr>,
    <tr><td>larma</td><td>175</td></tr>,
    <tr><td>nasse</td><td>175</td></tr>,
    <tr><td>Oiolosse</td><td>175</td></tr>,
    <tr><td>Elentári</td><td>176</td></tr>,
    <tr><td>Elwe</td><td>176</td></tr>,
    <tr><td>indemma</td><td>176</td></tr>,
    <tr><td>Nahar</td><td>176</td></tr>,
    <tr><td>Orome</td><td>176</td></tr>,
    <tr><td>Sindicollo</td><td>176</td></tr>,
    <tr><td>Valaróma</td><td>176</td></tr>,
    <tr><td>Arda</td><td>177</td></tr>,
    <tr><td>Ea</td><td>177</td></tr>,
    <tr><td>Ulmo</td><td>177</td></tr>,
    <tr><td>Yavanna</td><td>177</td></tr>,
    <tr><td>Ainu</td><td>178</td></tr>,
    <tr><td>quanta emma</td><td>179</td></tr>,
    <tr><td>indemma</td><td>179</td></tr>,
    <tr><td>afánie</td><td>180</td></tr>,
    <tr><td>Arda</td><td>180</td></tr>,
    <tr><td>fanar</td><td>180</td></tr>,
    <tr><td>fantane</td><td>180</td></tr>,
    <tr><td>Maia</td><td>180</td></tr>,
    <tr><td>Maiar</td><td>180</td></tr>,
    <tr><td>Olórin</td><td>180</td></tr>,
    <tr><td>ñorsús-</td><td>183</td></tr>,
    <tr><td>Sauron</td><td>184</td></tr>,
    <tr><td>taran</td><td>186</td></tr>,
    <tr><td>cáza</td><td>188</td></tr>,
    <tr><td>inno</td><td>189</td></tr>,
    <tr><td>nóre</td><td>189</td></tr>,
    <tr><td>ín</td><td>189</td></tr>,
    <tr><td>Altariel</td><td>190</td></tr>,
    <tr><td>Eruhíni</td><td>190</td></tr>,
    <tr><td>-n</td><td>190</td></tr>,
    <tr><td>Tindómiel</td><td>190</td></tr>,
    <tr><td>yé</td><td>190</td></tr>,
    <tr><td>yó</td><td>190</td></tr>,
    for $ref in $refs
    return (
        <tr source="{$ref/@source}">
            <td>{translate($ref/@v/string(), '´!̆', '’')}</td>
            <td>{substring-after(substring-before($ref/@source, '.'), '/')}</td>
        </tr>,
        if ($ref/deriv/@i1) then <tr source="{$ref/@source}">
            <td>{translate($ref/deriv/@i1/string(), '´!̆', '’')}</td>
            <td>{substring-after(substring-before($ref/@source, '.'), '/')}</td>
        </tr> else (),
        if ($ref/deriv/@i2) then <tr source="{$ref/@source}">
            <td>{translate($ref/deriv/@i2/string(), '´!̆', '’')}</td>
            <td>{substring-after(substring-before($ref/@source, '.'), '/')}</td>
        </tr> else ()
    )
    ) } </table>
let $t1id := <table> {
    for $row in $t1/tr
    return
        <tr id="{local:rowId($row)}" source="{$row/@source}">
            <td>{$row/td[1]/string()}</td>
            <td>{$row/td[2]/string()}</td>
        </tr>
    }</table>
let $t2id := <table> {(
    for $row in $t2/tr
    return
        <tr id="{local:rowId($row)}" source="{$row/@source}">
            <td>{$row/td[1]/string()}</td>
            <td>{$row/td[2]/string()}</td>
        </tr>
    )}</table>
let $joined := $t1id | $t2id
let $t3 :=
    <table> {(
    for $rowId in distinct-values($joined/tr/@id)
    let $t1row := $t1id/tr[@id = $rowId][1]
    let $t2row := $t2id/tr[@id = $rowId][1]
    order by $rowId
    return
        <tr> {(
            if ($t1row/@source = '') then <td bgcolor="black"></td> else 
                if ($t1row) then <td>{$t1row/td[1]/string()}</td>
                else <td bgcolor="yellow"></td>,
            if ($t1row/@source = '') then <td bgcolor="black"></td> else 
                if ($t1row) then <td>PE17:{substring-before(concat($t1row/td[2]/string(), ':'), ':')}</td>
                else <td bgcolor="yellow"></td>,
            if ($t2row/@source = '') then <td bgcolor="black"></td> else 
                if ($t2row) then <td>{$t2row/td[1]/string()}</td>
                else <td bgcolor="yellow"></td>,
            if ($t2row/@source = '') then <td bgcolor="black"></td> else 
                if ($t2row) then <td><a href="../references/ref-PE17.html#{$t2row/@source}">PE17:{$t2row/td[2]/string()}</a></td>
                else <td bgcolor="yellow"></td>
        )} </tr>
    )}</table>
return $t3
}
</body>
</html>
:)

(:

<html>
<body> {
let $refs := //ref[c:get-lang(.)='n'][contains(@v, 'ea')]
return (
    <p><u>{count($refs)}</u></p>,
    let $control := <control show-lang="y" show-link="parent"/>
    for $ref in $refs
    let $word := $ref/..
    order by $word/c:get-lang(.), $word/c:normalize-for-sort(@v) 
    return
        <p>
            {c:print-word($word, $control)}
        </p>
) }
</body>
</html>
:)

(:

<html>
<body> {
for $ref in //ref[example|example-deriv|example-inflect][not(c:get-ref(.))]
return <p>{$ref/@source/string()}</p>
} </body>
</html>

<html>
<body> {
for $word in xdb:key(/*, 'language', 'q')[c:get-speech(.)='adj'][ref/inflect] return
<p>{$word/@v/string()}</p>
} </body>
</html>
:)