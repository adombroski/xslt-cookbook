<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:pipe="xalan://PipeDocument"
        extension-element-prefixes="pipe">
 
 <xsl:param name="source"/>
 <xsl:param name="target"/>
 <!-- A list of elements to preserve. All others are stripped. -->
 <xsl:param name="preserve-elems"/>
 
 <pipe:pipeDocument   source="{$source}" target="{$target}">
   
   <stylesheet href="strip.xslt">
     <param name="preserve-elems" value="{$preserve-elems}"/>
   </stylesheet>
   
   <stylesheet href="contents.xslt"/>
   
 </pipe:pipeDocument>
 
</xsl:stylesheet>
