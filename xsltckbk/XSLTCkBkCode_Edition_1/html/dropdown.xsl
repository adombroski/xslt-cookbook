<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
	<xsl:template match="/">
		<HTML><BODY>
		<table>
		  <xsl:for-each select="Database/People/Person">
		  <tr>
			<td>Favorite Color</td>
			<td>
			<select>
			  <xsl:for-each select="/Database/Colors/Color">
				<option>
				  <xsl:attribute name="value"><xsl:value-of select="ColorId/text()"/>
				  </xsl:attribute>
				  <xsl:if test=".[context(-1)/ColorId/text() = context(-2)/FavoriteColor/text()]">
				  	<xsl:attribute name="SELECTED"/>
				  </xsl:if>
				</option>
			  <xsl:value-of select="ColorName/text()"/>
			  </xsl:for-each>
			</select>
			</td>
		  </tr>
		  </xsl:for-each>
		</table>
	</BODY></HTML>
  </xsl:template>
</xsl:stylesheet>
