<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    xmlns:xdb="java:xdb.dom.CustomFunctions"
    exclude-result-prefixes="q xdb">

    <xsl:output cdata-section-elements="notes phonetics words names grammar phrases cognate source x-ref element deriv inflect cite related before" indent="yes"/> 
    
    <xsl:template match="/">
<xsl:comment>
© 2008 -<xsl:copy-of select="concat(xdb:currentYear(), ',')"/>Paul Strack.
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
</xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:key name="word" match="word" use="@v"/> 

    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word/deriv | word/element | word/related">
        <xsl:copy>
            <xsl:if test="not(@l)">
               <xsl:variable name="word" select="key('word', @v)"/>
               <xsl:variable name="lang" select="ancestor-or-self::word[@l][1]/@l"/>
               <xsl:choose>
                  <xsl:when test="@v='?'">
                     <xsl:attribute name="l" select="$lang"/>
                  </xsl:when>
                  <xsl:when test="count($word)=1">
                     <xsl:attribute name="l" select="$word/@l"/>
                  </xsl:when>
                  <xsl:when test="count($word[@l=$lang])=1">
                     <xsl:attribute name="l" select="$word[@l=$lang]/@l"/>
                  </xsl:when>
               </xsl:choose>
            </xsl:if>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="word">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:if test="not(@l)">
               <xsl:copy-of select="ancestor::word[@l][1]/@l"/>
            </xsl:if>
            <xsl:if test="not(@speech)">
               <xsl:copy-of select="ancestor::word[@speech][1]/@speech"/>
            </xsl:if>
            <xsl:if test="not(@gloss)">
                <xsl:choose>
                    <xsl:when test="ref[not(change)][not(correction)]/@gloss">
                       <xsl:copy-of select="ref[not(change)][not(correction)][1]/@gloss"/>
                    </xsl:when>
                    <xsl:when test="ref[not(correction)]/@gloss">
                       <xsl:copy-of select="ref[not(correction)][1]/@gloss"/>
                    </xsl:when>
                    <xsl:when test="word/@gloss">
                       <xsl:copy-of select="word[1]/@gloss"/>
                    </xsl:when>
                    <xsl:when test="word[ref[not(change)][not(correction)]]/@gloss">
                       <xsl:copy-of select="word[ref[not(change)][not(correction)]][1]/ref[not(change)][not(correction)][1]/@gloss"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:attribute name="page-id" select="xdb:hashcode(.)"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="notes[parent::ref]"/>
</xsl:stylesheet>

