<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:q="quenya"
    exclude-result-prefixes="q">

    <xsl:output cdata-section-elements="notes cognate source x-ref"/> 
    
    <xsl:template match="*">
       <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
       </xsl:copy>
    </xsl:template>

    <xsl:template match="see[starts-with(@reason, 'obsolete') or starts-with(@reason, 'obselete')]">
       <obsolete>
          <xsl:copy-of select="@*[not(name()='reason')]"/>
          <xsl:apply-templates/>
       </obsolete>
    </xsl:template>

    <xsl:template match="see[starts-with(@reason, 'archaic') or starts-with(@reason, 'archiac')]">
       <archaic>
          <xsl:copy-of select="@*[not(name()='reason')]"/>
          <xsl:apply-templates/>
       </archaic>
    </xsl:template>

    <xsl:template match="see[starts-with(@reason, 'related')]">
       <xsl:copy>
          <xsl:copy-of select="@*[not(name()='reason')]"/>
          <xsl:apply-templates/>
       </xsl:copy>
    </xsl:template>

<!--
    <xsl:template match="deriv|elements|cognates|grammar">
        <xsl:variable name="element" select="translate(name(), 's', '')"/>
        <xsl:for-each select="x-ref">
            <xsl:element name="{$element}">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:if test="not(position() = last())">
                <xsl:text>&#10;      </xsl:text>
                <inflect form="{@form}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
-->

<!--
    <xsl:template match="ref">
       <xsl:copy>
          <xsl:copy-of select="@*[not(name()='form')]"/>
          <xsl:if test="@form">
             <xsl:text>&#10;      </xsl:text>
             <inflect form="{@form}"/>
          </xsl:if>
          <xsl:apply-templates/>
          <xsl:if test="@form and not(*)">
              <xsl:text>&#10;   </xsl:text>
          </xsl:if>
       </xsl:copy>
    </xsl:template>
-->    
</xsl:stylesheet>
