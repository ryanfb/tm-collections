<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:kml="http://www.opengis.net/kml/2.2">
  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>
 
<xsl:template match="/">
	<xsl:text>count,id,title,longitude,latitude,elevation
</xsl:text>
	<xsl:apply-templates />
</xsl:template>

<!-- don't copy text nodes -->
<xsl:template match="text()" />

<xsl:template match="kml:Placemark">
	<xsl:if test="kml:MultiGeometry/kml:Point/kml:coordinates/text()">
		  <xsl:value-of select="kml:ExtendedData/kml:Data[@name='count']"/>
		  <xsl:text>,</xsl:text>
		  <xsl:value-of select="kml:ExtendedData/kml:Data[@name='id']"/>
		  <xsl:text>,"</xsl:text>
		  <xsl:value-of select="kml:name"/>
		  <xsl:text>",</xsl:text>
		  <xsl:value-of select="kml:MultiGeometry/kml:Point/kml:coordinates/text()"/>
	    <xsl:text>
</xsl:text>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>