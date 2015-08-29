<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    exclude-result-prefixes="q">

    <xsl:key name="on-deriv" match="word[@l='n']" use="ref/deriv/@source"/> 
    <xsl:key name="on-ref" match="word[@l='on']" use="ref/@source"/> 

    <xsl:output cdata-section-elements="notes cognate source x-ref element deriv" indent="yes"/> 
    
    <xsl:template match="/*">
        <all-refs>
            <xsl:for-each select=".//ref">
                <xsl:sort select="q:normalize(@source)" />
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </all-refs>
    </xsl:template>

    <xsl:function name="q:normalize">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word!=''">
                <xsl:value-of select="normalize-space(replace(replace(replace(replace(replace(replace(translate(lower-case($word), 
                    '¹²³⁴⁵⁶⁷⁸⁹ṃṇñŋᴬᴱᴵᴼᵁáéíóúäëïöüāēīōūâêîôûăĕĭŏŭǣǭ-()', '123456789mnnnaeiouaeiouaeiouaeiouaeiouaeioueo '),
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
