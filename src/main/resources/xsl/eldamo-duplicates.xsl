<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:q="quenya"
    exclude-result-prefixes="xs q">
    
    <xsl:param name="doc-root" />
    
    <xsl:variable name="data" select="/*"/>

    <xsl:key name="word.key" match="word" use="q:derive-id(@l, @v, @gloss)" />
    <xsl:function name="q:get-word">
        <xsl:param name="id" />
        <xsl:sequence select="key('word.key', $id, $data)" />
    </xsl:function>

    <xsl:template match="/">
<html>
    <head>
        <title>Reference Index</title>
    </head>
    <body>
        <h1>Reference Index</h1>
        <xsl:apply-templates select="/*/word"/>
    </body>
</html>
    </xsl:template>
    
    <xsl:template match="word">
		<xsl:variable name="matches" select="q:get-word(q:derive-id(@l, @v, @gloss))"/>
        <xsl:if test="count($matches) gt 1">
           <p>l="<xsl:value-of select="@l"/>" v="<xsl:value-of select="@v"/>"</p>
        </xsl:if>
    </xsl:template>

    <xsl:function name="q:derive-id">
        <xsl:param name="l" />
        <xsl:param name="v" />
        <xsl:param name="gloss" />
        <xsl:value-of select="concat($l, '@', q:normalize-lang($v), '@', if ($l='q') then $gloss else '')" />
    </xsl:function>

    <xsl:function name="q:normalize-lang">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word='s'">s</xsl:when>
            <xsl:when test="$word='n'">s</xsl:when>
            <xsl:when test="$word='on'">so</xsl:when>
            <xsl:when test="$word='os'">so</xsl:when>
            <xsl:when test="$word='ilk'">ilk</xsl:when>
            <xsl:when test="$word='dor'">ilk</xsl:when>
            <xsl:when test="$word='fal'">ilk</xsl:when>
            <xsl:otherwise><xsl:value-of select="$word"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
