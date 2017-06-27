<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:import href="../util/copy.xslt"/>
  
 <xsl:output method="html"/>

 <xsl:template match="html">
    <xsl:copy>
      <xsl:apply-templates/>
      
        <script type="text/javascript" language="JavaScript">
          <xsl:comment>
              /* Initialize tax for default state */
              setTax(document.customerInfo.billState)
              
              /*Recompute tax when state changes */
        	function setTax(field) 
        	{
        		var value = new String(field.value) 
        		var commaPos = value.indexOf(",") 
        		var taxObj = document.customerInfo.tax
        		var tax = value.substr(commaPos + 1)
        		var subtotalObj = document.customerInfo.subtotal
        		taxObj.value = tax
        		document.customerInfo.total.value = 
        		    parseFloat(subtotalObj.value) + 
        		    (parseFloat(subtotalObj.value) * parseFloat(tax) / 100.00)
        	}
          </xsl:comment>
        </script>
        
      
    </xsl:copy>     
 </xsl:template>
  
 <xsl:template match="select[@name='shipState' or @name='billState']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="document('salesTax.xml')//state">
        <option value="{concat(name,',',tax)}">
          <xsl:value-of select="name"/>
        </option>
      </xsl:for-each>
    </xsl:copy>
 </xsl:template> 

</xsl:stylesheet>
