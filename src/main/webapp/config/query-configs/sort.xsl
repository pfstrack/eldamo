<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    xmlns:xdb="java:xdb.dom.CustomFunctions"
    exclude-result-prefixes="q xdb">

    <xsl:key name="on-deriv" match="word[@l='n']" use="ref/deriv/@source"/> 
    <xsl:key name="on-ref" match="word[@l='on']" use="ref/@source"/> 
    <xsl:variable name="ordered-words" select="//word[@order]"/>

    <xsl:output cdata-section-elements="notes phonetics words names grammar phrases cognate source x-ref element deriv inflect cite related before vocabulary neologisms deprecations" indent="yes"/> 
    
    <xsl:template match="/*">
        <xsl:variable name="main" select="/"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="language-cat">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="source">
                <xsl:sort select="q:normalize(@prefix)" />
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:copy-of select="cats"/>
            <xsl:apply-templates select="word">
                <xsl:sort select="q:normalize-lang(@l)" />
                <xsl:sort select="q:normalize(@v)" />
                <xsl:sort select="@v" />
                <xsl:sort select="q:normalize(@gloss)" />
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')][not(name()='order')]"/>
            <xsl:if test="@order != ''">
	            <xsl:variable name="word" select="."/>
                <xsl:attribute name="order" select="format-number(count($ordered-words
                    [@l=$word/@l]
                    [@speech=$word/@speech]
                    [@order lt $word/@order]
                ) * 100 + 100, '00000')"/>
            </xsl:if>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="notes"/>
            <xsl:apply-templates select="*[not(name()='notes' or name()='word' or name()='ref')]"/>
            <xsl:apply-templates select="*[name()='ref']">
                <xsl:sort select="q:normalize(@source)"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="*[name()='word']">
                <xsl:sort select="concat(if (@l) then (@l) else '1', '::', translate(q:normalize(self::word/@v), ' ', ''))"/>
            </xsl:apply-templates>
            <xsl:variable name="l" select="@l"/>
            <xsl:variable name="v" select="@v"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ref">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')]"/>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="*"/>
            <xsl:if test="* or text()">
            </xsl:if>
        </xsl:copy>
    </xsl:template>

<!--
        <xsl:variable name="single-gloss" select="count(.//*[@gloss]) = 1 and .//@gloss = @gloss"/>
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')][not($single-gloss and name()='gloss')]"/>
            <xsl:copy-of select="@mark"/>

    <xsl:template match="archaic">
        <xsl:copy>
            <xsl:copy-of select="@l[not(.=../../@l)]"/>
            <xsl:copy-of select="@*[not(name()='l')]"/>
            <xsl:copy-of select="node()"/>
        </xsl:copy>
    </xsl:template>
-->

    <xsl:template match="*" priority="-1">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:function name="q:normalize">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word!=''">
                <xsl:value-of select="normalize-space(replace(replace(replace(replace(replace(translate(lower-case($word), 
                    'χƕ¹²³⁴⁵⁶⁷⁸⁹ıǝçɟḷḹṣṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûăĕĭŏŭǣǭχř .-‘’()!̆,`¯̯̥',
                    'hh123456789iecjllsmnrrnnaeiouaeiouaeiouaeiouaeiouaeioueoxr'),
                                        'ð', 'dzz'),
                                        'þ', 'tzz'),
                                        'θ', 'tzz'),
                                        'ʒ', 'hzz'),
                                        'ɣ', 'hzz'))"/>
            </xsl:when>
            <xsl:otherwise>zzzzzzzzzzz</xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="q:normalize-lang">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word='dan'">nan</xsl:when>
            <xsl:when test="$word='g'">s</xsl:when>
            <xsl:when test="$word='en'">s</xsl:when>
            <xsl:when test="$word='n'">s</xsl:when>
            <xsl:when test="$word='ln'">s</xsl:when>
            <xsl:when test="$word='ns'">s</xsl:when>
            <xsl:when test="$word='norths'">s</xsl:when>
            <xsl:when test="$word='ilk'">ilk</xsl:when>
            <xsl:when test="$word='dor'">ilk</xsl:when>
            <xsl:when test="$word='fal'">ilk</xsl:when>
            <xsl:when test="$word='lon'">so</xsl:when>
            <xsl:when test="$word='on'">so</xsl:when>
            <xsl:when test="$word='os'">so</xsl:when>
            <xsl:when test="$word='eon'">os</xsl:when>
            <xsl:when test="$word='eoq'">aq</xsl:when>
            <xsl:when test="$word='eilk'">ilk</xsl:when>
            <xsl:when test="$word='at'">t</xsl:when>
            <xsl:when test="$word='mt'">t</xsl:when>
            <xsl:when test="$word='et'">t</xsl:when>
            <xsl:when test="$word='aq'">q</xsl:when>
            <xsl:when test="$word='mq'">q</xsl:when>
            <xsl:when test="$word='eq'">q</xsl:when>
            <xsl:when test="$word='nq'">q</xsl:when>
            <xsl:when test="$word='mp'">p</xsl:when>
            <xsl:when test="$word='ep'">p</xsl:when>
            <xsl:when test="$word='np'">p</xsl:when>
            <xsl:when test="$word='pad'">ad</xsl:when>
            <xsl:when test="$word='?'">zzz</xsl:when>
            <xsl:otherwise><xsl:value-of select="$word"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>

<!--
    
    <xsl:template match="ref[xdb:key(., 'example-inflect', @source)]">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')]"/>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="*"/>
            <xsl:for-each select="xdb:distinct(xdb:key(., 'example-inflect', @source))">
                <xsl:sort select="@source"/>
                <example-inflect v="{@v}" source="{@source}"/>
            </xsl:for-each>
            <xsl:if test="* or text()">
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="example-inflect"/>

    <xsl:template match="word[@l='r']">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')]"/>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="*[not(name()='word' or name()='ref')]"/>
            <xsl:apply-templates select="ref[not(starts-with(@source, 'Ety-AC:') or
                                                 starts-with(@source, 'Ety:') or
                                                 starts-with(@source, 'LR:') or
                                                 starts-with(@source, 'FS:') or
                                                 starts-with(@source, 'LRI:') or
                                                 starts-with(@source, 'LT1:') or
                                                 starts-with(@source, 'LT2:') or
                                                 starts-with(@source, 'LT1I:') or
                                                 starts-with(@source, 'LT2I:'))]">
                <xsl:sort select="q:normalize(@source)"/>
            </xsl:apply-templates>
            <xsl:if test="ref[starts-with(@source, 'Ety-AC:') or
                              starts-with(@source, 'Ety:') or
                              starts-with(@source, 'FS:') or
                              starts-with(@source, 'LR:') or
                              starts-with(@source, 'LRI:') or
                              starts-with(@source, 'LT1:') or
                              starts-with(@source, 'LT2:') or
                              starts-with(@source, 'LT1I:') or
                              starts-with(@source, 'LT2I:')]">
                <word test="test" l="mr" v="{@v}">
                    <xsl:apply-templates select="ref[starts-with(@source, 'Ety-AC:') or
                                                     starts-with(@source, 'Ety:') or
                                                     starts-with(@source, 'FS:') or
                                                     starts-with(@source, 'LR:') or
                                                     starts-with(@source, 'LRI:')]">
                        <xsl:sort select="q:normalize(@source)"/>
                    </xsl:apply-templates>
                    <xsl:if test="ref[starts-with(@source, 'LT1:') or
                                      starts-with(@source, 'LT2:') or
                                      starts-with(@source, 'LT1I:') or
                                      starts-with(@source, 'LT2I:')]">
                        <word l="er" v="{@v}">
                            <xsl:apply-templates select="ref[starts-with(@source, 'LT1:') or
                                                             starts-with(@source, 'LT2:') or
                                                             starts-with(@source, 'LT1I:') or
                                                             starts-with(@source, 'LT2I:')]">
                                <xsl:sort select="q:normalize(@source)"/>
                            </xsl:apply-templates>
                        </word>
                    </xsl:if>
                </word>
            </xsl:if>
            <xsl:apply-templates select="word">
                <xsl:sort select="translate(q:normalize(self::word/@v), ' ', '')"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word[@l='p']">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')]"/>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="*[not(name()='word' or name()='ref')]"/>
            <xsl:apply-templates select="ref[not(starts-with(@source, 'Ety-AC:') or
                                                 starts-with(@source, 'Ety:') or
                                                 starts-with(@source, 'LR:') or
                                                 starts-with(@source, 'FS:') or
                                                 starts-with(@source, 'LRI:') or
                                                 starts-with(@source, 'LT1:') or
                                                 starts-with(@source, 'LT2:') or
                                                 starts-with(@source, 'LT1I:') or
                                                 starts-with(@source, 'LT2I:'))]">
                <xsl:sort select="q:normalize(@source)"/>
            </xsl:apply-templates>
            <xsl:if test="ref[starts-with(@source, 'Ety-AC:') or
                              starts-with(@source, 'Ety:') or
                              starts-with(@source, 'FS:') or
                              starts-with(@source, 'LR:') or
                              starts-with(@source, 'LRI:') or
                              starts-with(@source, 'LT1:') or
                              starts-with(@source, 'LT2:') or
                              starts-with(@source, 'LT1I:') or
                              starts-with(@source, 'LT2I:')]">
                <word test="test" l="mp" v="{@v}">
                    <xsl:apply-templates select="ref[starts-with(@source, 'Ety-AC:') or
                                                     starts-with(@source, 'Ety:') or
                                                     starts-with(@source, 'FS:') or
                                                     starts-with(@source, 'LR:') or
                                                     starts-with(@source, 'LRI:')]">
                        <xsl:sort select="q:normalize(@source)"/>
                    </xsl:apply-templates>
                    <xsl:if test="ref[starts-with(@source, 'LT1:') or
                                      starts-with(@source, 'LT2:') or
                                      starts-with(@source, 'LT1I:') or
                                      starts-with(@source, 'LT2I:')]">
                        <word l="ep" v="{@v}">
                            <xsl:apply-templates select="ref[starts-with(@source, 'LT1:') or
                                                             starts-with(@source, 'LT2:') or
                                                             starts-with(@source, 'LT1I:') or
                                                             starts-with(@source, 'LT2I:')]">
                                <xsl:sort select="q:normalize(@source)"/>
                            </xsl:apply-templates>
                        </word>
                    </xsl:if>
                </word>
            </xsl:if>
            <xsl:apply-templates select="word">
                <xsl:sort select="translate(q:normalize(self::word/@v), ' ', '')"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word[@l='q'][ends-with(@speech, 'name')][not(ref)][count(word)=1]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="word/@*"/>
            <xsl:copy-of select="*[not(name()='word')]"/>
            <xsl:copy-of select="word/*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word[@l='q']">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')]"/>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="*[not(name()='word' or name()='ref')]"/>
            <xsl:apply-templates select="ref[not(starts-with(@source, 'Ety-AC:') or
                                                 starts-with(@source, 'Ety:') or
                                                 starts-with(@source, 'PE18:') or
                                                 starts-with(@source, 'LR:') or
                                                 starts-with(@source, 'FS:') or
                                                 starts-with(@source, 'LRI:') or
                                                 starts-with(@source, 'LT1:') or
                                                 starts-with(@source, 'LT2:') or
                                                 starts-with(@source, 'LT1I:') or
                                                 starts-with(@source, 'LT2I:'))]">
                <xsl:sort select="q:normalize(@source)"/>
            </xsl:apply-templates>
            <xsl:if test="ref[starts-with(@source, 'Ety-AC:') or
                              starts-with(@source, 'Ety:') or
                              starts-with(@source, 'PE18:') or
                              starts-with(@source, 'FS:') or
                              starts-with(@source, 'LR:') or
                              starts-with(@source, 'LRI:') or
                              starts-with(@source, 'LT1:') or
                              starts-with(@source, 'LT2:') or
                              starts-with(@source, 'LT1I:') or
                              starts-with(@source, 'LT2I:')]">
                <word test="test" l="mq" v="{translate(@v, 'ëc', 'ek')}">
                    <xsl:apply-templates select="ref[starts-with(@source, 'Ety-AC:') or
                                                     starts-with(@source, 'Ety:') or
                                                     starts-with(@source, 'PE18:') or
                                                     starts-with(@source, 'FS:') or
                                                     starts-with(@source, 'LR:') or
                                                     starts-with(@source, 'LRI:')]">
                        <xsl:sort select="q:normalize(@source)"/>
                    </xsl:apply-templates>
                    <xsl:if test="ref[starts-with(@source, 'LT1:') or
                                      starts-with(@source, 'LT2:') or
                                      starts-with(@source, 'LT1I:') or
                                      starts-with(@source, 'LT2I:')]">
                        <word l="eq" v="{translate(@v, 'ëc', 'ek')}">
                            <xsl:apply-templates select="ref[starts-with(@source, 'LT1:') or
                                                             starts-with(@source, 'LT2:') or
                                                             starts-with(@source, 'LT1I:') or
                                                             starts-with(@source, 'LT2I:')]">
                                <xsl:sort select="q:normalize(@source)"/>
                            </xsl:apply-templates>
                        </word>
                    </xsl:if>
                </word>
            </xsl:if>
            <xsl:apply-templates select="word">
                <xsl:sort select="translate(q:normalize(self::word/@v), ' ', '')"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word[@l='n'][ref/deriv/key('on-ref', @source)]">
        <xsl:copy-of select="."/>
        <xsl:for-each select="ref/deriv/key('on-ref', @source)">
           <word test="true" l="on" v="{@v}">
              <xsl:copy-of select="*"/>
           </word>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="word[@l='on'][ref/key('on-deriv', @source)]"/>

    <xsl:template match="word[@l='s'][ends-with(@speech, 'name')][not(ref)][count(word)=1]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="word/@*"/>
            <xsl:copy-of select="*[not(name()='word')]"/>
            <xsl:copy-of select="word/*"/>
        </xsl:copy>
    </xsl:template>
-->
