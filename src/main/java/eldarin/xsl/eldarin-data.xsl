<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:q="quenya"
    exclude-result-prefixes="xs q">


    <xsl:output cdata-section-elements="notes source"/> 
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*|text()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word-data" priority="10">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*|text()"/>
            <!--
                        <xsl:when test="@ad">Ad. </xsl:when>
                        <xsl:when test="@dan">Dan. </xsl:when>
                        <xsl:when test="@dor">Dor. </xsl:when>
                        <xsl:when test="@ilk">Ilk. </xsl:when>
                        <xsl:when test="@n">N. </xsl:when>
                        <xsl:when test="@nan">Nan. </xsl:when>
                        <xsl:when test="@on">ON. </xsl:when>
                        <xsl:when test="@os">OS. </xsl:when>
                        <xsl:when test="@oss">Oss. </xsl:when>
                        <xsl:when test="@s">S. </xsl:when>
                        <xsl:when test="@t">T. </xsl:when>
                        <xsl:when test="@v">V. </xsl:when>
            -->
            <xsl:for-each select="word/ref/cognate">
                <xsl:sort select="q:normalize(@*[not(name()='mark')][not(name()='gloss')][not(name()='source')]/name())"/>
                <xsl:sort select="../q:normalize-source(@source)"/>
                <word l="{@*[not(name()='mark')][not(name()='gloss')][not(name()='source')]/name()}"
                      v="{@*[not(name()='mark')][not(name()='gloss')][not(name()='source')]}"
                      speech="{../../@speech}">
                    <xsl:copy-of select="../@gloss"/>
                    <xsl:copy-of select="@gloss"/>
                    <xsl:text>&#10;   </xsl:text>
                    <ref l="{@*[not(name()='mark')][not(name()='gloss')][not(name()='source')]/name()}"
                         v="{@*[not(name()='mark')][not(name()='gloss')][not(name()='source')]}"
                         source="{../q:normalize-source(@source)}">
                        <xsl:copy-of select="../@mark"/>
                        <xsl:copy-of select="../@form"/>
                        <xsl:copy-of select="../@gloss"/>
                        <xsl:copy-of select="@gloss"/>
                        <xsl:if test="normalize-space(.) != ''">
                            <xsl:text>&#10;      </xsl:text>
                            <notes><xsl:value-of select="normalize-space(.)"/></notes>
                            <xsl:text>&#10;   </xsl:text>
                        </xsl:if>
                    </ref>
                    <xsl:text>&#10;</xsl:text>
                </word>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="word/ref[@p]">
                <xsl:sort select="q:normalize(@p)"/>
                <xsl:sort select="q:normalize-source(@source)"/>
                <word l="p" v="{@p}" speech="{../@speech}">
                    <xsl:if test="@p-gloss"><xsl:attribute name="gloss" select="@p-gloss"/></xsl:if>
                    <xsl:text>&#10;   </xsl:text>
                    <ref l="p" v="{@p}" source="{q:normalize-source(@source)}">
                        <xsl:copy-of select="@mark"/>
                        <xsl:copy-of select="@form"/>
                        <xsl:if test="@p-gloss"><xsl:attribute name="gloss" select="@p-gloss"/></xsl:if>
                        <xsl:if test="normalize-space(.) != ''">
                            <xsl:text>&#10;      </xsl:text>
                            <notes><xsl:value-of select="normalize-space(.)"/></notes>
                            <xsl:text>&#10;   </xsl:text>
                        </xsl:if>
                    </ref>
                    <xsl:text>&#10;</xsl:text>
                </word>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="word/ref[@p2]">
                <xsl:sort select="q:normalize(@p2)"/>
                <xsl:sort select="q:normalize-source(@source)"/>
                <word l="p" v="{@p2}" speech="{../@speech}">
                    <xsl:if test="@p2-gloss"><xsl:attribute name="gloss" select="@p2-gloss"/></xsl:if>
                    <xsl:text>&#10;   </xsl:text>
                    <ref l="p" v="{@p2}" source="{q:normalize-source(@source)}">
                        <xsl:copy-of select="@mark"/>
                        <xsl:copy-of select="@form"/>
                        <xsl:if test="@p2-gloss"><xsl:attribute name="gloss" select="@p2-gloss"/></xsl:if>
                        <xsl:if test="normalize-space(.) != ''">
                            <xsl:text>&#10;      </xsl:text>
                            <notes><xsl:value-of select="normalize-space(.)"/></notes>
                            <xsl:text>&#10;   </xsl:text>
                        </xsl:if>
                    </ref>
                    <xsl:text>&#10;</xsl:text>
                </word>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="word/ref[@r]">
                <xsl:sort select="q:normalize(@r)"/>
                <xsl:sort select="q:normalize-source(@source)"/>
                <word l="r" v="{@r}" speech="root">
                    <xsl:if test="@r-gloss"><xsl:attribute name="gloss" select="@r-gloss"/></xsl:if>
                    <xsl:text>&#10;   </xsl:text>
                    <ref l="r" v="{@r}" source="{q:normalize-source(@source)}">
                        <xsl:copy-of select="@mark"/>
                        <xsl:if test="@r-gloss"><xsl:attribute name="gloss" select="@r-gloss"/></xsl:if>
                        <xsl:attribute name="source" select="q:normalize-source(@source)"/>
                        <xsl:if test="normalize-space(.) != ''">
                            <xsl:text>&#10;      </xsl:text>
                            <notes><xsl:value-of select="normalize-space(.)"/></notes>
                            <xsl:text>&#10;   </xsl:text>
                        </xsl:if>
                    </ref>
                    <xsl:text>&#10;</xsl:text>
                </word>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word" priority="10">
        <xsl:copy>
            <xsl:attribute name="l" select="'q'"/>
            <xsl:attribute name="v" select="if (@also) then concat(@q, '/', @also) else @q"/>
            <xsl:copy-of select="@*[not(name()='q')][not(name()='also')]"/>
            <xsl:apply-templates select="*|text()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ref" priority="10">
        <xsl:copy>
            <xsl:attribute name="l" select="'q'"/>
            <xsl:attribute name="v" select="if (@also) then concat(@q, '/', @also) else @q"/>
            <xsl:attribute name="source" select="q:normalize-source(@source)"/>
            <xsl:copy-of select="@*[not(name()='q')][not(name()='also')][not(name()='source')]
                                   [not(name()='p')][not(name()='p-gloss')]
                                   [not(name()='p2')][not(name()='p2-gloss')]
                                   [not(name()='r')][not(name()='r-gloss')]"/>
            <xsl:if test="@p | @p2 | @r">
               <xsl:text>&#10;      </xsl:text>
               <deriv>
                  <xsl:if test="@p">
                      <xsl:text>&#10;         </xsl:text>
                      <x-ref v="{@p}" source="{q:normalize-source(@source)}"/>
                  </xsl:if>
                  <xsl:if test="@p2">
                      <xsl:text>&#10;         </xsl:text>
                      <x-ref v="{@p2}" source="{q:normalize-source(@source)}"/>
                  </xsl:if>
                  <xsl:if test="@r">
                      <xsl:text>&#10;         </xsl:text>
                      <x-ref v="{@r}" source="{q:normalize-source(@source)}"/>
                  </xsl:if>
                  <xsl:text>&#10;      </xsl:text>
               </deriv>
            </xsl:if>
            <xsl:if test="element">
               <xsl:text>&#10;      </xsl:text>
               <elements>
                  <xsl:for-each select="element">
                      <xsl:text>&#10;         </xsl:text>
                      <x-ref v="{@r|@p|@q}" source="???"/>
                  </xsl:for-each>
               <xsl:text>&#10;      </xsl:text>
               </elements>
            </xsl:if>
            <xsl:if test="cognate">
               <xsl:text>&#10;      </xsl:text>
               <cognates>
                  <xsl:for-each select="cognate">
                      <xsl:text>&#10;         </xsl:text>
                      <x-ref v="{@*[not(name()='mark')][not(name()='gloss')][not(name()='source')]}" source="{q:normalize-source(../@source)}"/>
                  </xsl:for-each>
               <xsl:text>&#10;      </xsl:text>
               </cognates>
            </xsl:if>
            <xsl:if test="notes">
               <xsl:text>&#10;      </xsl:text>
               <xsl:apply-templates select="notes"/>
            </xsl:if>
            <!-- <xsl:apply-templates select="*[not(name()='cognate')][not(name()='element')]|text()"/> -->
            <xsl:if test="* | @p | @p2 | @r">
                <xsl:text>&#10;   </xsl:text>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="q:normalize">
        <xsl:param name="word"/>
        <xsl:value-of select="replace(translate(lower-case($word), 'ñáéíóúäëïöüāēīōūâêîôû-()', 'naeiouaeiouaeiouaeiou'), 'ʒ', 'gz')"/>
    </xsl:function>
    
    <xsl:function name="q:normalize-source">
        <xsl:param name="word"/>
        <xsl:variable name="src" select="substring-before($word, ':')"/>
        <xsl:variable name="ref" select="substring-after($word, ':')"/>
        <xsl:variable name="page" select="substring-before($ref, '.')"/>
        <xsl:variable name="position" select="substring-after($ref, '.')"/>
        <xsl:choose>
            <xsl:when test="number($page) ge 100">
                <xsl:value-of select="concat($src, ':', $page, '.', $position)"/>
            </xsl:when>
            <xsl:when test="number($page) ge 10">
                <xsl:value-of select="concat($src, ':0', $page, '.', $position)"/>
            </xsl:when>
            <xsl:when test="number($page)">
                <xsl:value-of select="concat($src, ':00', $page, '.', $position)"/>
            </xsl:when>
            <xsl:when test="number($ref) ge 100">
                <xsl:value-of select="concat($src, ':', $ref)"/>
            </xsl:when>
            <xsl:when test="number($ref) ge 10">
                <xsl:value-of select="concat($src, ':0', $ref)"/>
            </xsl:when>
            <xsl:when test="number($ref)">
                <xsl:value-of select="concat($src, ':00', $ref)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$word"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
