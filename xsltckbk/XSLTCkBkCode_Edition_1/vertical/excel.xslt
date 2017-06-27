<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                         xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                         xmlns:o="urn:schemas-microsoft-com:office:office" 
                         xmlns:x="urn:schemas-microsoft-com:office:excel" 
                         xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
                         
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <!-- The name of the top level element -->
  <xsl:param name="topLevelName" select=" 'Table' "/>
  <!-- The name of each row -->
  <xsl:param name="rowName" select=" 'Row' "/>
  <!-- The namespace to use -->
  <xsl:param name="namespace"/>
  <!-- The namespace prefix to use -->
  <xsl:param name="namespacePrefix"/>
  <!-- The character to use if column names contain white space -->
  <xsl:param name="wsSub" select="'_'"/>
  <!--Determines which row contains the col names-->
  <xsl:param name="colNamesRow" select="1"/>
  <!--Determines which row the data begins -->
  <xsl:param name="dataRowStart" select="2"/>
  <!-- If false then cells with null or whitespace only content will be skipped -->
  <xsl:param name="includeEmpty" select="true()"/>
  <!-- If false then author and creation meta data will not be put into a comment-->
  <xsl:param name="includeComment" select="true()"/>
  
  <!--Normalize the namespacePrefix -->
  <xsl:variable name="nsp">
    <xsl:if test="$namespace">
      <!-- Only use prefix if namespace is specified -->
      <xsl:choose>
        <xsl:when test="contains($namespacePrefix,':')">
          <xsl:value-of select="concat(translate(substring-before($namespacePrefix,':'),' ',''),':')"/>
        </xsl:when>
        <xsl:when test="translate($namespacePrefix,' ','')">
          <xsl:value-of select="concat(translate($namespacePrefix,' ',''),':')"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>
  
  <!--Get the names of all the columns with white space replaced by  -->
  <xsl:variable name="COLS" select="/*/*/*/ss:Row[$colNamesRow]/ss:Cell"/>
  
  <xsl:template match="o:DocumentProperties">
    <xsl:if test="$includeComment">
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment>
       <xsl:text>&#xa;</xsl:text>
        <xsl:if test="normalize-space(o:Company)">
          <xsl:text>Company: </xsl:text>
          <xsl:value-of select="o:Company"/>
          <xsl:text>&#xa;</xsl:text>
        </xsl:if>
        <xsl:text>Author: </xsl:text>
        <xsl:value-of select="o:Author"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>Created on: </xsl:text>
        <xsl:value-of select="translate(o:Created,'TZ',' ')"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>Last Author: </xsl:text>
        <xsl:value-of select="o:LastAuthor"/>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>Saved on:</xsl:text>
        <xsl:value-of select="translate(o:LastSaved,'TZ',' ')"/>
        <xsl:text>&#xa;</xsl:text>
      </xsl:comment>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="ss:Table">
    <xsl:element name="{concat($nsp,translate($topLevelName,' &#x9;&#xA;',$wsSub))}" namespace="{$namespace}">
      <xsl:apply-templates select="ss:Row[position() >= $dataRowStart]"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="ss:Row">
    <xsl:element name="{concat($nsp,translate($rowName,'&#x20;&#x9;&#xA;',$wsSub))}" namespace="{$namespace}">
      <xsl:for-each select="ss:Cell">
        <xsl:variable name="pos" select="position()"/>
   
       <!-- The the correct column name even if there were empty cols in original spreadsheet -->     
        <xsl:variable name="colName">
          <xsl:choose>
            <xsl:when test="@ss:Index and $COLS[@ss:Index = current()/@ss:Index]">
              <xsl:value-of select="$COLS[@ss:Index = current()/@ss:Index]/ss:Data"/>
            </xsl:when>
            <xsl:when test="@ss:Index">
              <xsl:value-of select="$COLS[number(current()/@ss:Index)]/ss:Data"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$COLS[$pos]/ss:Data"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$includeEmpty or translate(ss:Data,'&#x20;&#x9;&#xA;','')">
          <xsl:element name="{concat($nsp,translate($colName,' &#x9;&#xA;',$wsSub))}" namespace="{$namespace}">
            <xsl:value-of select="ss:Data"/>
          </xsl:element>
        </xsl:if>
        
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>
