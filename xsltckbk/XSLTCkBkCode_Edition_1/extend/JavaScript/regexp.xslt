<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:regex="http://www.ora.com/XSLTCookbook/extend/regex">
  
<xsl:output method="text"/>

<xalan:component prefix="regex" functions="match leftContext rightContext getParenMatch makeRegExp">
  <xalan:script lang="javascript">

    function Matcher(pattern)
    {
      this.re = new RegExp(pattern) ;
      this.re.compile(pattern) ;
      this.result="" ;
      this.left="" ;
      this.right="" ;
    } 

    function match(matcher, input)
    {
      matcher.result = matcher.re.exec(input) ;
      matcher.left = RegExp.leftContext ;
      matcher.right = RegExp.rightContext ;
      return matcher.result[0] ;
    }
           
    function leftContext(matcher) 
    {
      return matcher.left ;
    }

    function rightContext(matcher) 
    {
      return matcher.right ;
    }

    function getParenMatch(matcher, which)
    {
      return matcher.result[which] ;
    }
    
    function makeRegExp(pattern)
    {
      return new Matcher(pattern) ;
    }
    
  </xalan:script>
</xalan:component>

<xsl:template match="/">
  <xsl:variable name="dateParser" 
                select="regex:makeRegExp('(\d\d?)[/-](\d\d?)[/-](\d{4}|\d{2})')"/>
  Match: <xsl:value-of 
               select="regex:match($dateParser, 
                       'I was born on 05/03/1964 in New York City.')"/>
  Left: <xsl:value-of select="regex:leftContext($dateParser)"/>
  Right: <xsl:value-of select="regex:rightContext($dateParser)"/>
  Month: <xsl:value-of select="regex:getParenMatch($dateParser, 1)"/>
  Day: <xsl:value-of select="regex:getParenMatch($dateParser,2)"/>
  Year: <xsl:value-of select="regex:getParenMatch($dateParser,3)"/>
</xsl:template>
	
</xsl:stylesheet>
