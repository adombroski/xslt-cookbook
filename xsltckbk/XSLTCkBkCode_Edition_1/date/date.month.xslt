<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://www.ora.com/XSLTCookbook/NS/dates">

<!-- United States : us -->
<date:month country="us" m="1"  name="January" abbrev="Jan" />
<date:month country="us" m="2"  name="February" abbrev="Feb"/>
<date:month country="us" m="3"  name="March" abbrev="Mar"/>
<date:month country="us" m="4"  name="April" abbrev="Apr"/>
<date:month country="us" m="5"  name="May" abbrev="May"/>
<date:month country="us" m="6"  name="June" abbrev="Jun"/>
<date:month country="us" m="7"  name="July" abbrev="Jul"/>
<date:month country="us" m="8"  name="August" abbrev="Aug"/>
<date:month country="us" m="9"  name="September" abbrev="Sep"/>
<date:month country="us" m="10" name="October" abbrev="Oct"/>
<date:month country="us" m="11" name="November" abbrev="Nov"/>
<date:month country="us" m="12" name="December" abbrev="Dec"/>

<!-- Germany : de -->
<date:month country="de" m="1"  name="Januar" abbrev="Jan"/>
<date:month country="de" m="2"  name="Februar" abbrev="Feb"/>
<date:month country="de" m="3"  name="März" abbrev="Mär"/>
<date:month country="de" m="4"  name="April" abbrev="Apr"/>
<date:month country="de" m="5"  name="Mai" abbrev="Mai"/>
<date:month country="de" m="6"  name="Juni" abbrev="Jun"/>
<date:month country="de" m="7"  name="Juli" abbrev="Jul"/>
<date:month country="de" m="8"  name="August" abbrev="Aug"/>
<date:month country="de" m="9"  name="September" abbrev="Sep"/>
<date:month country="de" m="10" name="Oktober" abbrev="Okt"/>
<date:month country="de" m="11" name="November" abbrev="Nov"/>
<date:month country="de" m="12" name="Dezember" abbrev="Dez"/>
<!-- You get the idea ... -->

<!-- Store element in variable for easy access -->
<xsl:variable name="date:months" select="document('')/*/date:month"/>

</xsl:stylesheet>

