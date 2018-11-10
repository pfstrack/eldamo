<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    xmlns:xdb="java:xdb.dom.CustomFunctions"
    exclude-result-prefixes="q xdb">
    
    <!--
    <xsl:variable name="merge.xml" select="/.."/>
    <xsl:variable name="merge.xml" select="document('/Users/ps142237/Dropbox/quenya-web/web/data/merge.xml')"/>
    -->
    <xsl:variable name="merge.xml" select="document('data/merge.xml')"/>

    <xsl:key name="on-deriv" match="word[@l='n']" use="ref/deriv/@source"/> 
    <xsl:key name="on-ref" match="word[@l='on']" use="ref/@source"/> 

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
            <xsl:for-each select="$merge.xml/*/word">
                <xsl:variable name="l" select="@l"/>
                <xsl:variable name="v" select="@v"/>
                <xsl:if test="not($main//word[@v=$v and @l=$l])">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word">
        <xsl:variable name="l" select="@l"/>
        <xsl:variable name="v" select="@v"/>
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='mark')]"/>
            <xsl:for-each select="$merge.xml/*/word[@v=$v and @l=$l]">
                <xsl:copy-of select="@vetted"/>
            </xsl:for-each>
            <xsl:for-each select="$merge.xml/*/word[@v=$v and @l=$l]">
                <xsl:copy-of select="@cat"/>
            </xsl:for-each>
            <xsl:copy-of select="@mark"/>
            <xsl:apply-templates select="*[not(name()='word' or name()='ref')]"/>
            <xsl:apply-templates select="*[name()='ref']">
                <xsl:sort select="q:normalize(@source)"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="*[name()='word']">
                <xsl:sort select="concat(if (@l) then (@l) else '1', '::', translate(q:normalize(self::word/@v), ' ', ''))"/>
            </xsl:apply-templates>
            <xsl:for-each select="$merge.xml/*/word[@v=$v and @l=$l]">
                <xsl:copy-of select="ref"/>
            </xsl:for-each>
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

    <xsl:template match="ref[@rule and @from]">
        <xsl:copy>
            <xsl:copy-of select="@*[not(name()='rule')][not(name()='from')][not(name()='rl')]"/>
            <xsl:attribute name="rl" select="../@l"/>
            <xsl:copy-of select="@rule"/>
            <xsl:copy-of select="@from"/>
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
                    'χƕ¹²³⁴⁵⁶⁷⁸⁹ıǝçɟḷḹṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûăĕĭŏŭǣǭχř .-‘’()!̆,`¯̯̥',
                    'hh123456789iecjllmnrrnnaeiouaeiouaeiouaeiouaeiouaeioueoxr'),
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
