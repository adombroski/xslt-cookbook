<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://exslt.org/math" extension-element-prefixes="math">

<!--Important Constants -->
<math:constant name="PI" 					whole-len='2'>3.141592653589793</math:constant>
<math:constant name="E" 					whole-len='2'>2.718281828459045</math:constant>
<math:constant name="SQRRT2" 			whole-len='2'>1.414213562373095</math:constant>
<math:constant name="LN2" 					whole-len='2'>0.693147180559945</math:constant>
<math:constant name="LN10" 				whole-len='2'>2.302585092994046</math:constant>
<math:constant name="LOG2E" 				whole-len='2'>1.442695040888963</math:constant>
<math:constant name="SQRT1_2" 			whole-len='2'>0.707106781186548</math:constant>

<!-- Convenience variables when full precision is needed -->
<xsl:variable name="math:PI" select="number(document('')/*/math:constant[@name='PI'])"/>
<xsl:variable name="math:E" select="number(document('')/*/math:constant[@name='E'])"/>
<xsl:variable name="math:SQRRT2" select="number(document('')/*/math:constant[@name='SQRRT2'])"/>
<xsl:variable name="math:LN2" select="number(document('')/*/math:constant[@name='LN2'])"/>
<xsl:variable name="math:LOG2E" select="number(document('')/*/math:constant[@name='LOG2E'])"/>
<xsl:variable name="math:SQRT1_2" select="number(document('')/*/math:constant[@name='SQRT1_2'])"/>

</xsl:stylesheet>

