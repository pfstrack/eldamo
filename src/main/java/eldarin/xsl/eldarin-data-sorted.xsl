<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    exclude-result-prefixes="q">

    <xsl:output cdata-section-elements="notes cognate source x-ref"/> 
    
    <xsl:template match="/*">
        <xsl:text>&#10;</xsl:text>
        <xsl:copy>
            <xsl:text>&#10;</xsl:text>
            <xsl:for-each select="source">
                <xsl:sort select="q:normalize(@prefix)" />
                <xsl:copy-of select="."/>
	            <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
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
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*">
                <xsl:sort select="q:normalize(@source)"/>
            </xsl:apply-templates>
            <xsl:text>&#10;</xsl:text>
        </xsl:copy>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="ref">
        <xsl:text>&#10;   </xsl:text>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="*">
                <xsl:text>&#10;      </xsl:text>
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:if test="* or text()">
                <xsl:text>&#10;   </xsl:text>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" priority="-1">
        <xsl:text>&#10;   </xsl:text>
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:function name="q:normalize">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word!=''">
                <xsl:value-of select="replace(replace(replace(replace(translate(lower-case($word), 'ñŋáéíóúäëïöüāēīōūâêîôûăĕĭŏŭǣǭ-()', 'nnaeiouaeiouaeiouaeiouaeioueo '),
                                        'ð', 'dh'),
                                        'þ', 'th'),
                                        'θ', 'th'),
                                        'ʒ', 'gz')"/>
            </xsl:when>
            <xsl:otherwise>zzzzzzzzzzz</xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="q:normalize-lang">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word='n'">s</xsl:when>
            <xsl:when test="$word='ilk'">s</xsl:when>
            <xsl:when test="$word='dor'">s</xsl:when>
            <xsl:when test="$word='fal'">s</xsl:when>
            <xsl:when test="$word='on'">so</xsl:when>
            <xsl:when test="$word='os'">so</xsl:when>
            <xsl:otherwise><xsl:value-of select="$word"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
