<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
Convert the sample document from "partlist" format to "parttree" format (see DTD section for definitions). In the result document, part containment is represented by containment of one <part> element inside another. Each part that is not part of any other part should appear as a separate top-level element in the output document. 

Solution in XQuery:

define function one_level (element $p) returns element
{
    <part partid={ $p/@partid } 
          name={ $p/@name } >
        {
            for $s in document("data/parts-data.xml")//part
            where $s/@partof = $p/@partid
            return one_level($s)
        }
    </part>
}

<parttree>
  {
    for $p in document("data/parts-data.xml")//part[empty(@partof)]
    return one_level($p)
  }
</parttree>
-->

<xsl:template match="partlist">
  <parttree>
    <xsl:apply-templates select="part[not(@partof)]"/>
  </parttree>
</xsl:template>

<xsl:template match="part">
  <part partid="{@partid}" name="{@name}">
    <xsl:apply-templates select="../part[@partof = current()/@partid]"/>
  </part>
</xsl:template>

</xsl:stylesheet>
