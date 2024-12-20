<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    exclude-result-prefixes="q">

    <xsl:variable name="working" select="'PE23'"/>

    <xsl:key name="ref" match="ref" use="concat(@v, '::', @source)"/>
    <xsl:param name="old-data"/>
    <xsl:variable name="new-data.xml" select="/"/>
    <xsl:variable name="old-data.xml" select="document($old-data)"/>
    <!--
    <xsl:variable name="deleted" select="$old-data.xml//ref[not(key('ref', concat(@v, '::', @source), $new-data.xml))]"/>
    <xsl:variable name="added" select="$new-data.xml//ref
        [not(starts-with(@source, $working))]
        [not(key('ref', concat(@v, '::', @source), $old-data.xml))]"/>
    <xsl:variable name="changed" select="$new-data.xml//ref[not(deep-equal(., key('ref', concat(@v, '::', @source), $old-data.xml)))]"/>
    -->
    <xsl:template match="/*">
<html>
<head>
<title>Eldamo : Compare Refs</title>
</head>
<body>
<p><a href="../accept-refs.jsp">Accept</a></p>
<!--
<xsl:if test="$deleted">
    <hr/>
    <h2>Deleted</h2>
    <xsl:for-each select="$deleted">
        <xsl:sort select="q:normalize(@source)"/>
        <pre>
            <xsl:if test="not(starts-with(@source, $working))">
                <xsl:attribute name="style">background:red</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="." mode="print"/>
        </pre>
    </xsl:for-each>
</xsl:if>
-->
    <xsl:for-each select="$new-data.xml//ref | $old-data.xml//ref[not(key('ref', concat(@v, '::', @source), $new-data.xml))]">
        <xsl:sort select="q:normalize(@source)"/>
        <xsl:variable name="new">
            <xsl:apply-templates select="key('ref', concat(@v, '::', @source), $new-data.xml)" mode="print"/>
        </xsl:variable>
        <xsl:variable name="old">
            <xsl:apply-templates select="key('ref', concat(@v, '::', @source), $old-data.xml)" mode="print"/>
        </xsl:variable>
        <xsl:if test="not($new = $old)">
            <hr/>
            <xsl:if test="$new='' and not($old='')"><p>xxxx</p></xsl:if>
            <pre>
                <xsl:if test="not(starts-with(@source, $working))">
                    <xsl:attribute name="style">background:red</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$old"/>
            </pre>
            <xsl:if test="not($new='') and not($old='')"><p>&gt;&gt;</p></xsl:if>
            <xsl:if test="not($new='') and $old=''"><p>++++</p></xsl:if>
            <pre>
                <xsl:if test="not(starts-with(@source, $working))">
                    <xsl:attribute name="style">background:red</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$new"/>
            </pre>
        </xsl:if>
    </xsl:for-each>
<!--
<xsl:if test="$added">
    <hr/>
    <h2>Added</h2>
    <xsl:for-each select="$added">
        <xsl:sort select="q:normalize(@source)"/>
        <pre>
            <xsl:if test="not(starts-with(@source, $working))">
                <xsl:attribute name="style">background:red</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="." mode="print"/>
        </pre>
    </xsl:for-each>
</xsl:if>
-->
</body>
</html>
    </xsl:template>
    
    <xsl:template match="*" mode="print">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>="</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>"</xsl:text>
        </xsl:for-each>
        <xsl:if test="not(*[not(starts-with(name(), 'rule-'))]) and not(normalize-space())"> /</xsl:if>
        <xsl:text>&gt;</xsl:text>
        <xsl:if test="not(*)"><xsl:value-of select="normalize-space()"/></xsl:if>
        <xsl:if test="*[not(starts-with(name(), 'rule-'))] or normalize-space()">
            <xsl:for-each select="*">
               <xsl:text>&#10;&#160;&#160;&#160;&#160;</xsl:text>
               <xsl:apply-templates select="." mode="print"/>
            </xsl:for-each>
            <xsl:if test="*">&#160;&#10;</xsl:if>
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:function name="q:normalize">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word!=''">
                <xsl:value-of select="normalize-space(replace(replace(replace(replace(replace(replace(translate(lower-case($word), 
                    '¹²³⁴⁵⁶⁷⁸⁹ıǝçɟḷḹṣṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûăĕĭŏŭǣǭ .-‘’()!̆,`¯̯',
                    '123456789iecjllsmnrṝnnaeiouaeiouaeiouaeiouaeiouaeioueo'),
                                        'ð', 'dh'),
                                        'þ', 'th'),
                                        'θ', 'th'),
                                        'ʒ', 'h'),
                                        'χ', 'h'),
                                        'ř', 'r'))"/>
            </xsl:when>
            <xsl:otherwise>zzzzzzzzzzz</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
