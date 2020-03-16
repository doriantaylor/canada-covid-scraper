<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:x="urn:x-dummy"
                exclude-result-prefixes="html x">

<xsl:output method="text" media-type="application/json" encoding="utf-8"/>

<xsl:key name="tables" match="html:table[../html:div][contains(@class, 'table-responsive')]|html:table[contains(@class, 'table-bordered')]" use="''"/>

<xsl:template match="/">
  <xsl:variable name="tables" select="key('tables', '')"/>
<xsl:text>{
  </xsl:text>
  <xsl:apply-templates select="$tables[1]" mode="current-status"/>
<xsl:text>
}
</xsl:text>
</xsl:template>

<x:months>
  <x:month>January</x:month>
  <x:month>February</x:month>
  <x:month>March</x:month>
  <x:month>April</x:month>
  <x:month>May</x:month>
  <x:month>June</x:month>
  <x:month>July</x:month>
  <x:month>August</x:month>
  <x:month>September</x:month>
  <x:month>October</x:month>
  <x:month>November</x:month>
  <x:month>December</x:month>
</x:months>

<!-- this will only format the dates as scraped from this page -->
<xsl:template name="text-date-to-iso8601">
  <xsl:param name="date"/>

  <xsl:variable name="md" select="normalize-space(substring-before($date, ','))"/>
  <xsl:message>md: <xsl:value-of select="$md"/></xsl:message>
  <xsl:variable name="year">
    <xsl:variable name="_" select="normalize-space(substring-after($date, ','))"/>
    <xsl:choose>
      <xsl:when test="contains($_, ',')">
        <xsl:value-of select="normalize-space(substring-before($_, ','))"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$_"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="month">
    <xsl:variable name="_" select="document('')/xsl:stylesheet/x:months/x:month[normalize-space(.) = substring-before($md, ' ')]"/>
    <!--<xsl:message>md <xsl:value-of select="contains($md, ' ')"/></xsl:message>-->
    <xsl:if test="$_">
      <xsl:value-of select="format-number(count($_/preceding-sibling::*) + 1, '00')"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="day" select="format-number(substring-after($md, ' '), '00')"/>

  <xsl:value-of select="concat($year, '-', $month, '-', $day)"/>
</xsl:template>

<xsl:template name="quote-text">
  <xsl:param name="text" select="''"/>

  <xsl:text>"</xsl:text>

  <xsl:value-of select="$text"/>

  <xsl:text>"</xsl:text>

</xsl:template>

<xsl:template match="html:table" mode="current-status">
  <xsl:variable name="raw-date">
    <xsl:choose>
      <xsl:when test="contains(html:caption, 'as of')">
        <xsl:value-of select="normalize-space(substring-after(html:caption, 'as of'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="_" select="normalize-space(translate(../preceding-sibling::html:p[1], '&#xa0;', ' '))"/>
        <xsl:value-of select="normalize-space(concat(substring-before(substring-after($_, 'As of'), '2020'), ' 2020'))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="date">
    <xsl:call-template name="text-date-to-iso8601">
      <xsl:with-param name="date" select="$raw-date"/>
    </xsl:call-template>
  </xsl:variable>

    <xsl:text>"date": "</xsl:text>
    <xsl:value-of select="$date"/>
    <xsl:text>",
  "locality": {</xsl:text>
      <xsl:for-each select="html:tbody/html:tr">
      <xsl:text>
    </xsl:text>
        <xsl:call-template name="quote-text">
          <xsl:with-param name="text" select="normalize-space(html:td[1])"/>
        </xsl:call-template>
        <xsl:text>: </xsl:text>
        <xsl:choose>
          <xsl:when test="count(html:td) = 3">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="normalize-space(html:td[3])"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="normalize-space(html:td[2])"/>
            <xsl:text>]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(html:td[2])"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if> 
     </xsl:for-each>
    <xsl:text>
  }</xsl:text>

  <xsl:variable name="results" select="key('tables', '')[2]"/>
  <xsl:choose>
    <xsl:when test="$results">
    <xsl:text>,
  </xsl:text>
    <xsl:apply-templates select="$results" mode="test-results"/>
    </xsl:when>
    <xsl:otherwise>
<xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="html:table" mode="test-results">
  <xsl:variable name="td" select="html:tbody/html:tr[1]/html:td"/>
<xsl:text>"tests": {
    "negative": </xsl:text>
    <xsl:value-of select="normalize-space($td[1]/text())"/>
    <xsl:text>,
    "positive": </xsl:text>
    <xsl:value-of select="normalize-space($td[2]/text())"/>
    <xsl:text>,
    "total": </xsl:text>
    <xsl:value-of select="normalize-space($td[3]/text())"/>
    <xsl:text>
  }</xsl:text>
</xsl:template>

</xsl:stylesheet>
