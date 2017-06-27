<?xml version="1.0"?>

<!--
   Trace utility, modifies a stylesheet to produce trace messages
   Version 0.2
   GPL (c) Oliver Becker, 2002-02-13
   obecker@informatik.hu-berlin.de
-->

<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:trace="http://www.obqo.de/XSL/Trace"
  xmlns:alias="http://www.w3.org/TransformAlias"
  exclude-result-prefixes="alias">
  
  <xsl:namespace-alias stylesheet-prefix="alias" result-prefix="xsl" />

  <!-- <xsl:output indent="yes" /> -->

  <!-- XSLT root element -->
  <xsl:template match="xsl:stylesheet | xsl:transform">
    <xsl:copy>
      <!-- We need the trace namespace for names and modes -->
      <xsl:copy-of select="document('')/*/namespace::trace" />
      <!-- dito: perhaps a namespace was used only as attribute value -->
      <xsl:copy-of select="namespace::*|@*" />
      <xsl:apply-templates />
      <!-- append utility templates -->
      <xsl:copy-of 
           select="document('')/*/xsl:template
                                  [@mode='trace:getCurrent' or 
                                   @name='trace:getPath']" />
      <!-- compute the lowest priority and add a default template with 
           a lower priority for element nodes -->
      <xsl:variable name="priority" 
                    select="xsl:template/@priority
                            [not(. &gt; current()/xsl:template/@priority)]" />
      <xsl:variable name="newpri">
        <xsl:choose>
          <xsl:when test="$priority &lt; -1">
            <xsl:value-of select="$priority - 1" />
          </xsl:when>
          <!-- in case there's only a greater or no priority at all -->
          <xsl:otherwise>-2</xsl:otherwise> 
        </xsl:choose>
      </xsl:variable>
      <!-- copy the contents only -->
      <alias:template match="*" priority="{$newpri}">
        <xsl:copy-of select="document('')/*/xsl:template
                             [@name='trace:defaultRule']/node()" />
      </alias:template>
    </xsl:copy>
  </xsl:template>


  <!-- XSLT templates -->
  <xsl:template match="xsl:template">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <!-- first: copy parameters -->
      <xsl:apply-templates select="xsl:param" />
      <alias:param name="trace:callstack" />
      <xsl:choose>
        <xsl:when test="@name">
          <alias:variable name="trace:current"
                          select="concat($trace:callstack,'/{@name}')" />
        </xsl:when>
        <xsl:otherwise>
          <alias:variable name="trace:current"
                 select="concat($trace:callstack,
                         '/{count(preceding-sibling::xsl:template)+1}')" />
        </xsl:otherwise>
      </xsl:choose>

      <!-- emit a message -->
      <alias:message>
        <alias:call-template name="trace:getPath" />
        <alias:text>&#xA;   stack: </alias:text>
        <alias:value-of select="$trace:current" />
        <xsl:if test="@match or @mode">
          <alias:text> (</alias:text>
          <xsl:if test="@match">
            <alias:text>match="<xsl:value-of select="@match" />"</alias:text>
            <xsl:if test="@mode">
              <alias:text><xsl:text> </xsl:text></alias:text>
            </xsl:if>
          </xsl:if>
          <xsl:if test="@mode">
            <alias:text>mode="<xsl:value-of select="@mode" />"</alias:text>
          </xsl:if>
          <alias:text>)</alias:text>
        </xsl:if>
        <xsl:apply-templates select="xsl:param" mode="traceParams" />
      </alias:message>

      <!-- process children except parameters -->
      <xsl:apply-templates select="node()[not(self::xsl:param)]" />
    </xsl:copy>
  </xsl:template>


  <!-- add the callstack parameter for apply-templates and call-template -->
  <xsl:template match="xsl:apply-templates | xsl:call-template">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <alias:with-param name="trace:callstack" select="$trace:current" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>


  <!-- output parameter values -->
  <xsl:template match="xsl:param" mode="traceParams">
    <alias:text>&#xA;   param: name="<xsl:value-of select="@name" />" value="</alias:text>
    <alias:value-of select="${@name}" />" <alias:text />
    <!--
    <alias:copy-of select="${@name}" />" <alias:text />
    -->
  </xsl:template>

  <!-- output variable values -->
  <xsl:template match="xsl:variable">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
    <xsl:if test="ancestor::xsl:template">
      <alias:message>   variable: name="<xsl:value-of select="@name" />" value="<alias:text />
      <alias:value-of select="${@name}" />" </alias:message>
    </xsl:if>
  </xsl:template>

  <!-- copy every unprocessed node -->
  <xsl:template match="*|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>


  <!-- ******************************************************************* -->
  <!-- The following templates will be copied into the modified stylesheet -->
  <!-- ******************************************************************* -->

  <!-- 
   | trace:getPath
   | compute the absolute path of the context node 
   +-->
  <xsl:template name="trace:getPath">
    <xsl:text>node: </xsl:text>
    <xsl:for-each select="ancestor::*">
      <xsl:value-of 
           select="concat('/', name(), '[', 
           count(preceding-sibling::*[name()=name(current())])+1, ']')" />
    </xsl:for-each>      
    <xsl:apply-templates select="." mode="trace:getCurrent" />
  </xsl:template>


  <!-- 
   | trace:getCurrent
   | compute the last step of the location path, depending on the
   | node type
   +-->
  <xsl:template match="*" mode="trace:getCurrent">
    <xsl:value-of 
         select="concat('/', name(), '[', 
         count(preceding-sibling::*[name()=name(current())])+1, ']')" />
  </xsl:template>

  <xsl:template match="@*" mode="trace:getCurrent">
    <xsl:value-of select="concat('/@', name())" />
  </xsl:template>

  <xsl:template match="text()" mode="trace:getCurrent">
    <xsl:value-of 
         select="concat('/text()[', count(preceding-sibling::text())+1, ']')" />
  </xsl:template>

  <xsl:template match="comment()" mode="trace:getCurrent">
    <xsl:value-of 
         select="concat('/comment()[', 
                        count(preceding-sibling::comment())+1, ']')" />
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="trace:getCurrent">
    <xsl:value-of 
         select="concat('/processing-instruction()[', 
         count(preceding-sibling::processing-instruction())+1, ']')" />
  </xsl:template>


  <!-- 
   | trace:defaultRule
   | default rule with parameter passing 
   +-->
  <xsl:template name="trace:defaultRule">
    <xsl:param name="trace:callstack" />
    <xsl:message>
      <xsl:call-template name="trace:getPath" />
      <xsl:text>&#xA;   default rule applied</xsl:text>
    </xsl:message>
    <xsl:apply-templates>
      <xsl:with-param name="trace:callstack" select="$trace:callstack" />
    </xsl:apply-templates>
  </xsl:template>

</xsl:transform>
