<?xml version="1.0"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:template name="format-date-time">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="time" select="substring-after($date-time,'T')"/>
    <xsl:param name="year" select="substring-before($date,'-')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="day" select="substring-after(substring-after($date,'-'),'-')"/>
    <xsl:param name="hour" select="substring-before($time,':')"/>
    <xsl:param name="minute" select="substring-before(substring-after($time,':'),':')"/>
    <xsl:param name="second" select="substring-after(substring-after($time,'-'),'-')"/>
    <xsl:param name="time-zone"/>
    <xsl:param name="format" select="'%Y-%m-%dT%H:%M:%S%z'"/>

    <xsl:value-of select="substring-before($format, '%')"/>

    <xsl:variable name="code" select="substring(substring-after($format, '%'), 1, 1)"/>

    <xsl:choose>

      <!-- Abbreviated weekday name -->
      <xsl:when test="$code='a'">
        <xsl:variable name="day-of-the-week">
          <xsl:call-template name="calculate-day-of-the-week">
            <xsl:with-param name="year" select="$year"/>
            <xsl:with-param name="month" select="$month"/>
            <xsl:with-param name="day" select="$day"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="get-day-of-the-week-abbreviation">
          <xsl:with-param name="day-of-the-week" select="$day-of-the-week"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Full weekday name -->
      <xsl:when test="$code='A'">
        <xsl:variable name="day-of-the-week">
          <xsl:call-template name="calculate-day-of-the-week">
            <xsl:with-param name="year" select="$year"/>
            <xsl:with-param name="month" select="$month"/>
            <xsl:with-param name="day" select="$day"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="get-day-of-the-week-name">
          <xsl:with-param name="day-of-the-week" select="$day-of-the-week"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Abbreviated month name -->
      <xsl:when test="$code='b'">
        <xsl:call-template name="get-month-abbreviation">
          <xsl:with-param name="month" select="$month"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Full month name -->
      <xsl:when test="$code='B'">
        <xsl:call-template name="get-month-name">
          <xsl:with-param name="month" select="$month"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Date and time representation appropriate for locale -->
      <xsl:when test="$code='c'">
        <xsl:text>[not implemented]</xsl:text>
      </xsl:when>

      <!-- Day of month as decimal number (01 - 31) -->
      <xsl:when test="$code='d'">
        <xsl:if test="$day &lt; 10">0</xsl:if>
        <xsl:value-of select="number($day)"/>
      </xsl:when>

      <!-- Hour in 24-hour format (00 - 23) -->
      <xsl:when test="$code='H'">
        <xsl:if test="$hour &lt; 10">0</xsl:if>
        <xsl:value-of select="number($hour)"/>
      </xsl:when>

      <!-- Hour in 12-hour format (01 - 12) -->
      <xsl:when test="$code='I'">
        <xsl:choose>
          <xsl:when test="$hour = 0">12</xsl:when>
          <xsl:when test="$hour &lt; 10">0<xsl:value-of select="$hour - 0"/></xsl:when>
          <xsl:when test="$hour &lt; 13"><xsl:value-of select="$hour - 0"/></xsl:when>
          <xsl:when test="$hour &lt; 22">0<xsl:value-of select="$hour - 12"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$hour - 12"/></xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- Day of year as decimal number (001 - 366) -->
      <xsl:when test="$code='j'">
        <xsl:text>[not implemented]</xsl:text>
      </xsl:when>

      <!-- Month as decimal number (01 - 12) -->
      <xsl:when test="$code='m'">
        <xsl:if test="$month &lt; 10">0</xsl:if>
        <xsl:value-of select="number($month)"/>
      </xsl:when>

      <!-- Minute as decimal number (00 - 59) -->
      <xsl:when test="$code='M'">
        <xsl:if test="$minute &lt; 10">0</xsl:if>
        <xsl:value-of select="number($minute)"/>
      </xsl:when>

      <!-- Current locale's A.M./P.M. indicator for 12-hour clock -->
      <xsl:when test="$code='p'">
        <xsl:choose>
          <xsl:when test="$hour &lt; 12">AM</xsl:when>
          <xsl:otherwise>PM</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- Second as decimal number (00 - 59) -->
      <xsl:when test="$code='S'">
        <xsl:if test="$second &lt; 10">0</xsl:if>
        <xsl:value-of select="number($second)"/>
      </xsl:when>

      <!-- Week of year as decimal number, with Sunday as first day of week (00 - 53) -->
      <xsl:when test="$code='U'">
        <!-- add 1 to day -->
        <xsl:call-template name="calculate-week-number">
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="day" select="$day + 1"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Weekday as decimal number (0 - 6; Sunday is 0) -->
      <xsl:when test="$code='w'">
        <xsl:call-template name="calculate-day-of-the-week">
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="day" select="$day"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Week of year as decimal number, with Monday as first day of week (00 - 53) -->
      <xsl:when test="$code='W'">
        <xsl:call-template name="calculate-week-number">
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="day" select="$day"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Date representation for current locale -->
      <xsl:when test="$code='x'">
        <xsl:text>[not implemented]</xsl:text>
      </xsl:when>

      <!-- Time representation for current locale -->
      <xsl:when test="$code='X'">
        <xsl:text>[not implemented]</xsl:text>
      </xsl:when>

      <!-- Year without century, as decimal number (00 - 99) -->
      <xsl:when test="$code='y'">
        <xsl:text>[not implemented]</xsl:text>
      </xsl:when>

      <!-- Year with century, as decimal number -->
      <xsl:when test="$code='Y'">
        <xsl:value-of select="concat(substring('000', string-length(number($year))), $year)"/>
      </xsl:when>

      <!-- Time-zone name or abbreviation; no characters if time zone is unknown -->
      <xsl:when test="$code='z'">
        <xsl:value-of select="$time-zone"/>
      </xsl:when>

      <!-- Percent sign -->
      <xsl:when test="$code='%'">
        <xsl:text>%</xsl:text>
      </xsl:when>

    </xsl:choose>

    <xsl:variable name="remainder" select="substring(substring-after($format, '%'), 2)"/>

    <xsl:if test="$remainder">
      <xsl:call-template name="format-date-time">
        <xsl:with-param name="year" select="$year"/>
        <xsl:with-param name="month" select="$month"/>
        <xsl:with-param name="day" select="$day"/>
        <xsl:with-param name="hour" select="$hour"/>
        <xsl:with-param name="minute" select="$minute"/>
        <xsl:with-param name="second" select="$second"/>
        <xsl:with-param name="time-zone" select="$time-zone"/>
        <xsl:with-param name="format" select="$remainder"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="calculate-day-of-the-week">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="year" select="substring-before($date,'-')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="day" select="substring-after(substring-after($date,'-'),'-')"/>
    
    <xsl:variable name="a" select="floor((14 - $month) div 12)"/>
    <xsl:variable name="y" select="$year - $a"/>
    <xsl:variable name="m" select="$month + 12 * $a - 2"/>

    <xsl:value-of select="($day + $y + floor($y div 4) - floor($y div 100) + floor($y div 400) + floor((31 * $m) div 12)) mod 7"/>

  </xsl:template>

  <xsl:template name="get-day-of-the-week-name">
    <xsl:param name="day-of-the-week"/>

    <xsl:choose>
      <xsl:when test="$day-of-the-week = 0">Sunday</xsl:when>
      <xsl:when test="$day-of-the-week = 1">Monday</xsl:when>
      <xsl:when test="$day-of-the-week = 2">Tuesday</xsl:when>
      <xsl:when test="$day-of-the-week = 3">Wednesday</xsl:when>
      <xsl:when test="$day-of-the-week = 4">Thursday</xsl:when>
      <xsl:when test="$day-of-the-week = 5">Friday</xsl:when>
      <xsl:when test="$day-of-the-week = 6">Saturday</xsl:when>
      <xsl:otherwise>error: <xsl:value-of select="$day-of-the-week"/></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="get-day-of-the-week-abbreviation">
    <xsl:param name="day-of-the-week"/>

    <xsl:choose>
      <xsl:when test="$day-of-the-week = 0">Sun</xsl:when>
      <xsl:when test="$day-of-the-week = 1">Mon</xsl:when>
      <xsl:when test="$day-of-the-week = 2">Tue</xsl:when>
      <xsl:when test="$day-of-the-week = 3">Wed</xsl:when>
      <xsl:when test="$day-of-the-week = 4">Thu</xsl:when>
      <xsl:when test="$day-of-the-week = 5">Fri</xsl:when>
      <xsl:when test="$day-of-the-week = 6">Sat</xsl:when>
      <xsl:otherwise>error: <xsl:value-of select="$day-of-the-week"/></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="get-month-name">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    
    <xsl:choose>
      <xsl:when test="$month = 1">January</xsl:when>
      <xsl:when test="$month = 2">February</xsl:when>
      <xsl:when test="$month = 3">March</xsl:when>
      <xsl:when test="$month = 4">April</xsl:when>
      <xsl:when test="$month = 5">May</xsl:when>
      <xsl:when test="$month = 6">June</xsl:when>
      <xsl:when test="$month = 7">July</xsl:when>
      <xsl:when test="$month = 8">August</xsl:when>
      <xsl:when test="$month = 9">September</xsl:when>
      <xsl:when test="$month = 10">October</xsl:when>
      <xsl:when test="$month = 11">November</xsl:when>
      <xsl:when test="$month = 12">December</xsl:when>
      <xsl:otherwise>error: <xsl:value-of select="$month"/></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="get-month-abbreviation">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    
    <xsl:choose>
      <xsl:when test="$month = 1">Jan</xsl:when>
      <xsl:when test="$month = 2">Feb</xsl:when>
      <xsl:when test="$month = 3">Mar</xsl:when>
      <xsl:when test="$month = 4">Apr</xsl:when>
      <xsl:when test="$month = 5">May</xsl:when>
      <xsl:when test="$month = 6">Jun</xsl:when>
      <xsl:when test="$month = 7">Jul</xsl:when>
      <xsl:when test="$month = 8">Aug</xsl:when>
      <xsl:when test="$month = 9">Sep</xsl:when>
      <xsl:when test="$month = 10">Oct</xsl:when>
      <xsl:when test="$month = 11">Nov</xsl:when>
      <xsl:when test="$month = 12">Dec</xsl:when>
      <xsl:otherwise>error: <xsl:value-of select="$month"/></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="date-to-julian-day">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="year" select="substring-before($date,'-')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="day" select="substring-after(substring-after($date,'-'),'-')"/>
    
    <xsl:variable name="a" select="floor((14 - $month) div 12)"/>
    <xsl:variable name="y" select="$year + 4800 - $a"/>
    <xsl:variable name="m" select="$month + 12 * $a - 3"/>

    <xsl:value-of select="$day + floor((153 * $m + 2) div 5) + 365 * $y + floor($y div 4) - floor($y div 100) + floor($y div 400) - 32045"/>

  </xsl:template>

  <xsl:template name="julian-date-to-julian-day">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="year" select="substring-before($date,'-')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="day" select="substring-after(substring-after($date,'-'),'-')"/>
    
    <xsl:variable name="a" select="floor((14 - $month) div 12)"/>
    <xsl:variable name="y" select="$year + 4800 - $a"/>
    <xsl:variable name="m" select="$month + 12 * $a - 3"/>

    <xsl:value-of select="$day + floor((153 * $m + 2) div 5) + 365 * $y + floor($y div 4) - 32083"/>

  </xsl:template>


  <xsl:template name="format-julian-day">
    <xsl:param name="julian-day"/>
    <xsl:param name="format" select="'%Y-%m-%d'"/>

    <xsl:variable name="a" select="$julian-day + 32044"/>
    <xsl:variable name="b" select="floor((4 * $a + 3) div 146097)"/>
    <xsl:variable name="c" select="$a - floor(($b * 146097) div 4)"/>

    <xsl:variable name="d" select="floor((4 * $c + 3) div 1461)"/>
    <xsl:variable name="e" select="$c - floor((1461 * $d) div 4)"/>
    <xsl:variable name="m" select="floor((5 * $e + 2) div 153)"/>

    <xsl:variable name="day" select="$e - floor((153 * $m + 2) div 5) + 1"/>
    <xsl:variable name="month" select="$m + 3 - 12 * floor($m div 10)"/>
    <xsl:variable name="year" select="$b * 100 + $d - 4800 + floor($m div 10)"/>

    <xsl:call-template name="format-date-time">
      <xsl:with-param name="year" select="$year"/>
      <xsl:with-param name="month" select="$month"/>
      <xsl:with-param name="day" select="$day"/>
      <xsl:with-param name="format" select="$format"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="calculate-week-number">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>

    <xsl:variable name="J">
      <xsl:call-template name="date-to-julian-day">
        <xsl:with-param name="year" select="$year"/>
        <xsl:with-param name="month" select="$month"/>
        <xsl:with-param name="day" select="$day"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="d4" select="($J + 31741 - ($J mod 7)) mod 146097 mod 36524 mod 1461"/>
    <xsl:variable name="L" select="floor($d4 div 1460)"/>
    <xsl:variable name="d1" select="(($d4 - $L) mod 365) + $L"/>

    <xsl:value-of select="floor($d1 div 7) + 1"/>

  </xsl:template>

<!-- These are adapted from Rheingold, et. al. -->

<xsl:template name="last-day-of-month">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="year" select="substring-before($date,'-')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    
	<xsl:choose>
		<xsl:when test="$month = 2 and not($year mod 4) and ($year mod 100 or not($year mod 400))">
			<xsl:value-of select="29"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring('312831303130313130313031',2 * $month - 1,2)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="julian-day-to-absolute-day">
	<xsl:param name="j-day"/>
	<xsl:value-of select="$j-day - 1721425"/>
</xsl:template>

<xsl:template name="absolute-day-to-julian-day">
	<xsl:param name="abs-day"/>
	<xsl:value-of select="$abs-day + 1721425"/>
</xsl:template>

<xsl:template name="date-to-absolute-day">
    <xsl:param name="date-time"/>
    <xsl:param name="date" select="substring-before($date-time,'T')"/>
    <xsl:param name="year" select="substring-before($date,'-')"/>
    <xsl:param name="month" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="day" select="substring-after(substring-after($date,'-'),'-')"/>
    
    <xsl:call-template name="julian-day-to-absolute-day">
      <xsl:with-param name="j-day">
        <xsl:call-template name="date-to-julian-day">
          <xsl:with-param name="year" select="$year"/>
          <xsl:with-param name="month" select="$month"/>
          <xsl:with-param name="day" select="$day"/>
        </xsl:call-template>
      </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="absolute-day-to-date">
  <xsl:param name="abs-day"/>
  
  <xsl:call-template name="julian-day-to-date">
  	<xsl:with-param name="j-day">
  		<xsl:call-template name="absolute-day-to-julian-day">
  			<xsl:with-param name="abs-day" select="$abs-day"/>
  		</xsl:call-template>
  	</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="k-day-on-or-before-abs-day">
	<xsl:param name="abs-day"/>
	<xsl:param name="k"/>
	<xsl:value-of select="$abs-day - (($abs-day - $k) mod 7)"/>
</xsl:template>

<xsl:template name="iso-date-to-absolute-day">
	<xsl:param name="iso-week"/>
	<xsl:param name="iso-day"/>
	<xsl:param name="iso-year"/>
	
	<xsl:variable name="a">
		<xsl:call-template name="date-to-absolute-day">
			<xsl:with-param name="year" select="$iso-year"/>
			<xsl:with-param name="month" select="1"/>
			<xsl:with-param name="day" select="4"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="days-in-prior-yrs">
		<xsl:call-template name="k-day-on-or-before-abs-day">
			<xsl:with-param name="abs-day" select="$a"/>
			<xsl:with-param name="k" select="1"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="days-in-prior-weeks-this-yr"	select="7 * ($iso-week - 1)"/>

	<xsl:variable name="prior-days-this-week"	select="$iso-day - 1"/>

	<xsl:value-of select="$days-in-prior-yrs + $days-in-prior-weeks-this-yr + $prior-days-this-week"/>	
</xsl:template>


<xsl:template name="absolute-day-to-iso-date">
	<xsl:param name="abs-day"/>
	
	<xsl:variable name="d">
		<xsl:call-template name="absolute-day-to-date">
			<xsl:with-param name="abs-day" select="$abs-day - 3"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="approx" select="substring-before($d,'/')"/>
	
	<xsl:variable name="iso-year">
		<xsl:variable name="a">
			<xsl:call-template name="iso-date-to-absolute-day">
				<xsl:with-param name="iso-week" select="1"/>
				<xsl:with-param name="iso-day" select="1"/>
				<xsl:with-param name="iso-year" select="$approx + 1"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$abs-day >= $a">
				<xsl:value-of select="$approx + 1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$approx"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="iso-week">
		<xsl:variable name="a">
			<xsl:call-template name="iso-date-to-absolute-day">
				<xsl:with-param name="iso-week" select="1"/>
				<xsl:with-param name="iso-day" select="1"/>
				<xsl:with-param name="iso-year" select="$iso-year"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="1 + floor(($abs-day - $a) div 7)"/>
	</xsl:variable>
	
	<xsl:variable name="iso-day">
		<xsl:variable name="a" select="$abs-day mod 7"/>
		<xsl:choose>
			<xsl:when test="not($a)">
				<xsl:value-of select="7"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$a"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:value-of select="concat($iso-year,'/W',$iso-week,'/',$iso-day)"/>
		
</xsl:template>

<xsl:template name="last-day-of-julian-month">
	<xsl:param name="month"/>
	<xsl:param name="year"/>
	<xsl:choose>
		<xsl:when test="$month = 2 and not($year mod 4)">
			<xsl:value-of select="29"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring('312831303130313130313031',2 * $month - 1,2)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="julian-date-to-absolute-day">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>
    
    <xsl:call-template name="julian-day-to-absolute-day">
		<xsl:with-param name="j-day">
			<xsl:call-template name="julian-date-to-julian-day">
			    <xsl:with-param name="year" select="$year"/>
			    <xsl:with-param name="month" select="$month"/>
			    <xsl:with-param name="day" select="$day"/>
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="julian-day-to-julian-date">
	<xsl:param name="j-day"/>

	<xsl:call-template name="julian-or-gregorian-date-elem">
		<xsl:with-param name="b" select="0"/>
		<xsl:with-param name="c" select="$j-day + 32082"/>
	</xsl:call-template>

</xsl:template>

<xsl:template name="julian-day-to-date">
	<xsl:param name="j-day"/>

	<xsl:variable name="a" select="$j-day + 32044"/>
	<xsl:variable name="b" select="floor((4 * $a + 3) div 146097)"/>
	<xsl:variable name="c" select="$a - floor((146097 * $b) div 4)"/>

	<xsl:call-template name="julian-or-gregorian-date-elem">
		<xsl:with-param name="b" select="$b"/>
		<xsl:with-param name="c" select="$c"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="julian-or-gregorian-date-elem">
	<xsl:param name="b"/>
	<xsl:param name="c"/>

	<xsl:variable name="d" select="floor((4 * $c + 3) div 1461)"/>
	<xsl:variable name="e" select="$c - floor((1461 * $d) div 4)"/>
	<xsl:variable name="m" select="floor((5 * $e + 2) div 153)"/>

	<xsl:variable name="day" 
		select="$e - floor((153 * $m + 2) div 5) + 1"/>

	<xsl:variable name="month" 
		select="$m + 3 - (12 * floor($m div 10))"/>

	<xsl:variable name="year" 
		select="100 * $b + $d - 4800 + floor($m div 10)"/>

	<xsl:value-of select="concat($year,'/',$month,'/',$day)"/>
	
</xsl:template>

<!-- ISLAMIC CALENDAR -->

<xsl:template name="last-day-of-islamic-month">
	<xsl:param name="month"/>
	<xsl:param name="year"/>
	
	<xsl:variable name="islamic-leap-year" select="(11 * $year + 14) mod 30 &lt; 11"/>
	
	<xsl:choose>
		<xsl:when test="$month mod 2 or ($month = 12 and $islamic-leap-year)">
			<xsl:value-of select="30"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="29"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="islamic-date-to-absolute-day">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>
    
    <xsl:value-of select="$day + 29 * ($month - 1) + floor($month div 2) + 354 * ($year - 1) + floor((11 * $year + 3) div 30) + 227014"/>
</xsl:template>

<xsl:template name="absolute-day-to-islamic-date">
    <xsl:param name="abs-day"/>

	
	<xsl:variable name="year" select="floor(($abs-day - 227014) div 354.36667) + 1"/>
	
	<xsl:variable name="month">
		<xsl:variable name="a" select="$abs-day - 227014 - floor((11 * $year + 3) div 30) -  354 * ($year - 1)"/>
		<xsl:variable name="approx" select="floor($a div 29.53056)+1"/>
		<xsl:choose>
			<xsl:when test="(29 * ($approx - 1) + floor($approx div 2)) - $a = 0">
				<xsl:value-of select="$approx - 1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$approx"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="day">
		<xsl:variable name="a">
			<xsl:call-template name="islamic-date-to-absolute-day">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="1"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$abs-day - $a + 1"/>
	</xsl:variable>
	
	<xsl:value-of select="concat($year,'/',$month,'/',$day)"/>
	
</xsl:template>

<!--HEBREW CALENDAR -->

<xsl:template name="last-month-of-hebrew-year">
	<xsl:param name="year"/>
	<xsl:choose>
		<xsl:when test="(7 * $year + 1) mod 19 &lt; 7">
			<xsl:value-of select="13"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="12"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="hebrew-calendar-ellapsed-days">
	<xsl:param name="year"/>

	<xsl:variable name="hebrew-leap-year" select="(7 * $year + 1) mod 19 &lt; 7"/>
	<xsl:variable name="hebrew-leap-year-last-year" select="(7 * ($year - 1) + 1) mod 19 &lt; 7"/>
	
	<xsl:variable name="months-ellapsed" select="235 * floor(($year -1) div 19) +
												12 * (($year -1) mod 19) +
												floor((7 * (($year - 1) mod 19) + 1) div 19)"/>
												
	<xsl:variable name="parts-ellapsed" select="13753 * $months-ellapsed + 5604"/>

	<xsl:variable name="day" select="1 + 29 * $months-ellapsed + floor($parts-ellapsed div 25920)"/>

	<xsl:variable name="parts" select="$parts-ellapsed mod 25920"/>
	
	<xsl:variable name="alternative-day">
		<xsl:choose>
			<xsl:when test="$parts >= 19440">
				<xsl:value-of select="$day + 1"/>
			</xsl:when>
			<xsl:when test="$day mod 7 = 2 and $parts >= 9924 and not($hebrew-leap-year)">
				<xsl:value-of select="$day + 1"/>
			</xsl:when>
			<xsl:when test="$day mod 7 = 1 and $parts >= 16789 and $hebrew-leap-year-last-year">
				<xsl:value-of select="$day + 1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$day"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$alternative-day mod 7 = 0">
			<xsl:value-of select="$alternative-day + 1"/>
		</xsl:when>
		<xsl:when test="$alternative-day mod 7 =3">
			<xsl:value-of select="$alternative-day + 1"/>
		</xsl:when>
		<xsl:when test="$alternative-day mod 7 = 5">
			<xsl:value-of select="$alternative-day + 1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$alternative-day"/>
		</xsl:otherwise>
	</xsl:choose>		 
	
</xsl:template>

<xsl:template name="days-in-hebrew-year">
	<xsl:param name="year"/>
	
	<xsl:variable name="e1">
		<xsl:call-template name="hebrew-calendar-ellapsed-days">
			<xsl:with-param name="year" select="$year + 1"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="e2">
		<xsl:call-template name="hebrew-calendar-ellapsed-days">
			<xsl:with-param name="year" select="$year"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:value-of select="$e1 - $e2"/>
</xsl:template>

<xsl:template name="long-heshvan">
	<xsl:param name="year"/>
	
	<xsl:variable name="days">
		<xsl:call-template name="days-in-hebrew-year">
			<xsl:with-param name="year" select="$year"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:if test="$days mod 10 = 5">
		<xsl:value-of select="true()"/>
	</xsl:if>
</xsl:template>

<xsl:template name="short-kislev">
	<xsl:param name="year"/>

	<xsl:variable name="days">
		<xsl:call-template name="days-in-hebrew-year">
			<xsl:with-param name="year" select="$year"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:if test="$days mod 10 = 3">
		<xsl:value-of select="true()"/>
	</xsl:if>
</xsl:template>


<xsl:template name="last-day-of-hebrew-month">
	<xsl:param name="month"/>
	<xsl:param name="year"/>
	
	<xsl:variable name="hebrew-leap-year" 
		select="(7 * $year + 1) mod 19 &lt; 7"/>
	
	<xsl:variable name="long-heshvan">
	  <xsl:call-template name="long-heshvan">
	    <xsl:with-param name="year" select="$year"/>
	  </xsl:call-template>
	</xsl:variable>

	<xsl:variable name="short-kislev">
	  <xsl:call-template name="short-kislev">
	    <xsl:with-param name="year" select="$year"/>
	  </xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
	  <xsl:when test="$month=12 and $hebrew-leap-year">
	    <xsl:value-of select="30"/>
	  </xsl:when>
	  <xsl:when test="$month=8 and string($long-heshvan)">
	    <xsl:value-of select="30"/>
	  </xsl:when>
	  <xsl:when test="$month=9 and string($short-kislev)">
	    <xsl:value-of select="29"/>
	  </xsl:when>
	  <xsl:when test="$month=13">
	    <xsl:value-of select="29"/>
	  </xsl:when>
	  <xsl:when test="$month mod 2 = 0">
	    <xsl:value-of select="29"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="30"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="sum-last-day-in-hebrew-months">
       <xsl:param name="year"/>
	<xsl:param name="from-month"/>
	<xsl:param name="to-month"/>
	<xsl:param name="accum" select="0"/>

	<xsl:choose>
		<xsl:when test="$from-month &lt;= $to-month">
			<xsl:call-template name="sum-last-day-in-hebrew-months">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="from-month" select="$from-month+1"/>
				<xsl:with-param name="to-month" select="$to-month"/>
				<xsl:with-param name="accum">
					<xsl:variable name="temp">
						<xsl:call-template name="last-day-of-hebrew-month">
							<xsl:with-param name="year" select="$year"/>
							<xsl:with-param name="month" select="$from-month"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$temp + $accum"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$accum"/>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>

<xsl:template name="hebrew-date-to-absolute-day">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>

	<xsl:variable name="prior-months-days">
		<xsl:choose>
			<xsl:when test="7 > $month"> <!-- before Tishri -->
				<xsl:variable name="last-month-of-year">
					<xsl:call-template name="last-month-of-hebrew-year">
						<xsl:with-param name="year" select="$year"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- Add days before and after Nisan -->
				<xsl:variable name="days-before-nisan">
					<xsl:call-template name="sum-last-day-in-hebrew-months">
						<xsl:with-param name="year" select="$year"/>
						<xsl:with-param name="from-month" select="7"/>
						<xsl:with-param name="to-month" select="$last-month-of-year"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="sum-last-day-in-hebrew-months">
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="from-month" select="1"/>
					<xsl:with-param name="to-month" select="$month - 1"/>
					<xsl:with-param name="accum" select="$days-before-nisan"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- days in prior months this year-->
				<xsl:call-template name="sum-last-day-in-hebrew-months">
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="from-month" select="7"/>
					<xsl:with-param name="to-month" select="$month - 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>    
	</xsl:variable>
	
	<xsl:variable name="days-in-prior-years">
		<xsl:call-template name="hebrew-calendar-ellapsed-days">
			<xsl:with-param name="year" select="$year"/>
		</xsl:call-template>
	</xsl:variable>

	<!-- 	1373429 days before absolute day 1 -->
	<xsl:value-of select="$day + $prior-months-days + $days-in-prior-years - 1373429"/>
</xsl:template>

<xsl:template name="fixup-hebrew-year">
	<xsl:param name="start-year"/>
	<xsl:param name="abs-day"/>

	<xsl:param name="accum" select="0"/>

	<xsl:variable name="next">
		<xsl:call-template name="hebrew-date-to-absolute-day">
			<xsl:with-param name="month" select="7"/>
			<xsl:with-param name="day" select="1"/>
			<xsl:with-param name="year" select="$start-year + 1"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$abs-day >= $next">
			<xsl:call-template name="fixup-hebrew-year">
				<xsl:with-param name="start-year" select="$start-year+1"/>
				<xsl:with-param name="abs-day" select="$abs-day"/>
				<xsl:with-param name="accum" select="$accum + 1"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$accum"/>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>

<xsl:template name="fixup-hebrew-month">
	<xsl:param name="year"/>
	<xsl:param name="start-month"/>
	<xsl:param name="abs-day"/>


	<xsl:param name="accum" select="0"/>

	<xsl:variable name="next">
		<xsl:call-template name="hebrew-date-to-absolute-day">
			<xsl:with-param name="month" select="$start-month"/>
			<xsl:with-param name="day">
				<xsl:call-template name="last-day-of-hebrew-month">
					<xsl:with-param name="month" select="$start-month"/>
					<xsl:with-param name="year" select="$year"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="year" select="$year"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$abs-day > $next">
			<xsl:call-template name="fixup-hebrew-month">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="start-month" select="$start-month + 1"/>
				<xsl:with-param name="abs-day" select="$abs-day"/>
				<xsl:with-param name="accum" select="$accum + 1"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$accum"/>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>


<xsl:template name="absolute-day-to-hebrew-date">
    <xsl:param name="abs-day"/>

	<xsl:variable name="year">
		<xsl:variable name="approx" select="floor(($abs-day + 1373429) div 366)"/>
		<xsl:variable name="fixup">
			<xsl:call-template name="fixup-hebrew-year">
				<xsl:with-param name="start-year" select="$approx"/>
				<xsl:with-param name="abs-day" select="$abs-day"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$approx + $fixup"/>
	</xsl:variable>

	<xsl:variable name="month">
		<xsl:variable name="first-day-of-year">
			<xsl:call-template name="hebrew-date-to-absolute-day">
				<xsl:with-param name="month" select="1"/>
				<xsl:with-param name="day" select="1"/>
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="approx">
			<xsl:choose>
				<xsl:when test="$abs-day &lt; $first-day-of-year">
					<xsl:value-of select="7"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fixup">
			<xsl:call-template name="fixup-hebrew-month">
				<xsl:with-param name="year" select="$year"/>
				<xsl:with-param name="start-month" select="$approx"/>
				<xsl:with-param name="abs-day" select="$abs-day"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$approx + $fixup"/>
	</xsl:variable>

	<xsl:variable name="day">
		<xsl:variable name="days-to-first-of-month">
			<xsl:call-template name="hebrew-date-to-absolute-day">
				<xsl:with-param name="month" select="$month"/>
				<xsl:with-param name="day" select="1"/>
				<xsl:with-param name="year" select="$year"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$abs-day - ($days-to-first-of-month - 1)"/>
	</xsl:variable>

	<xsl:value-of select="concat($year,'-',$month,'-',$day)"/>
		
</xsl:template>

<!-- Holidays -->

<xsl:template name="independence-day">
	<xsl:param name="year"/>
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="month" select="7"/>
		<xsl:with-param name="day" select="4"/>
		<xsl:with-param name="year" select="$year"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="n-th-k-day">
	<xsl:param name="n"/> <!-- Postive n counts from beginning of month; negative from end. -->
	<xsl:param name="k"/>
	<xsl:param name="month"/>
	<xsl:param name="year"/>

	<xsl:choose>
		<xsl:when test="$n > 0">
			<xsl:variable name="k-day-on-or-before">
				<xsl:variable name="abs-day">
					<xsl:call-template name="date-to-absolute-day">
						<xsl:with-param name="month" select="$month"/>
						<xsl:with-param name="day" select="7"/>
						<xsl:with-param name="year" select="$year"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="k-day-on-or-before-abs-day">
					<xsl:with-param name="abs-day" select="$abs-day"/>
					<xsl:with-param name="k" select="$k"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$k-day-on-or-before + 7 * ($n - 1)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="k-day-on-or-before">
				<xsl:variable name="abs-day">
					<xsl:call-template name="date-to-absolute-day">
						<xsl:with-param name="month" select="$month"/>
						<xsl:with-param name="day">
							<xsl:call-template name="last-day-of-month">
								<xsl:with-param name="month" select="$month"/>
								<xsl:with-param name="year" select="$year"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="year" select="$year"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="k-day-on-or-before-abs-day">
					<xsl:with-param name="abs-day" select="$abs-day"/>
					<xsl:with-param name="k" select="$k"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$k-day-on-or-before + 7 * ($n + 1)"/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>


<xsl:template match="/" priority="-1000">
<results>
<!--
	<result>
	<xsl:call-template name="julian-day-to-date">
		<xsl:with-param name="j-day" select="0"/>
	</xsl:call-template>
	</result>
	
	<result>
	April 11, 2002
	<xsl:call-template name="date-to-julian-day">
		<xsl:with-param name="year" select="2002"/>
		<xsl:with-param name="month" select="4"/>
		<xsl:with-param name="day" select="11"/>
	</xsl:call-template>
	</result>

	<result>
	January 4, 2004 
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="year" select="2004"/>
		<xsl:with-param name="month" select="1"/>
		<xsl:with-param name="day" select="4"/>
	</xsl:call-template>
	</result>

	<result>
	December 29, 2003
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="year" select="2003"/>
		<xsl:with-param name="month" select="12"/>
		<xsl:with-param name="day" select="29"/>
	</xsl:call-template>
	</result>

	<result>
	731578 ?
	<xsl:call-template name="k-day-on-or-before-abs-day">
		<xsl:with-param name="abs-day" select="731584"/>
		<xsl:with-param name="k" select="1"/>
	</xsl:call-template>
	</result>
	
	<result>
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="year" select="2002"/>
		<xsl:with-param name="month" select="2"/>
		<xsl:with-param name="day" select="28"/>
	</xsl:call-template>
	</result>
	
	<result>
	absolute-day-to-date 
	<xsl:call-template name="absolute-day-to-date">
		<xsl:with-param name="abs-day" select="730909"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-iso-date 
	<xsl:call-template name="absolute-day-to-iso-date">
		<xsl:with-param name="abs-day" select="730909"/>
	</xsl:call-template>
	</result>
	
	<result>
	<xsl:call-template name="julian-day-to-julian-date">
		<xsl:with-param name="j-day" select="0"/>
	</xsl:call-template>
	</result>
	
	<result>
	<xsl:call-template name="last-day-of-month">
		<xsl:with-param name="month" select="2"/>
		<xsl:with-param name="year" select="2000"/>
	</xsl:call-template>
	</result>
	
	<result>
	<xsl:call-template name="last-day-of-month">
		<xsl:with-param name="month" select="2"/>
		<xsl:with-param name="year" select="1999"/>
	</xsl:call-template>
	</result>
	
	<result>
	<xsl:call-template name="last-day-of-month">
		<xsl:with-param name="month" select="2"/>
		<xsl:with-param name="year" select="2100"/>
	</xsl:call-template>
	</result>
	
	<result>
	<xsl:call-template name="last-day-of-month">
		<xsl:with-param name="month" select="12"/>
		<xsl:with-param name="year" select="2000"/>
	</xsl:call-template>
	</result>
	
	<result>
	islamic-date-to-absolute-day
	<xsl:call-template name="islamic-date-to-absolute-day">
		<xsl:with-param name="year" select="2001"/>
		<xsl:with-param name="month" select="1"/>
		<xsl:with-param name="day" select="30"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-islamic-date
	<xsl:call-template name="absolute-day-to-islamic-date">
		<xsl:with-param name="abs-day" select="935748"/>
	</xsl:call-template>
	</result>


	<result>
	absolute-day-to-islamic-date
	<xsl:call-template name="absolute-day-to-islamic-date">
		<xsl:with-param name="abs-day" select="935777"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-islamic-date
	<xsl:call-template name="absolute-day-to-islamic-date">
		<xsl:with-param name="abs-day" select="935778"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-islamic-date
	<xsl:call-template name="absolute-day-to-islamic-date">
		<xsl:with-param name="abs-day" select="935807"/>
	</xsl:call-template>
	</result>


	<result>
	absolute-day-to-islamic-date
	<xsl:call-template name="absolute-day-to-islamic-date">
		<xsl:with-param name="abs-day" select="227015"/>
	</xsl:call-template>
	</result>

	<result>
	date-to-absolute-day
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="year" select="2002"/>
		<xsl:with-param name="month" select="4"/>
		<xsl:with-param name="day" select="12"/>
	</xsl:call-template>
	</result>

	<result>
	hebrew-date-to-absolute-day
	<xsl:call-template name="hebrew-date-to-absolute-day">
		<xsl:with-param name="year" select="5762"/>
		<xsl:with-param name="month" select="1"/>
		<xsl:with-param name="day" select="30"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-hebrew-date
	<xsl:call-template name="absolute-day-to-hebrew-date">
		<xsl:with-param name="abs-day" select="730952"/>
	</xsl:call-template>
	</result>
-->

	<result>
	date-to-julian-day -4713-11-25
	<xsl:call-template name="date-to-julian-day">
		<xsl:with-param name="year" select="-4713"/>
		<xsl:with-param name="month" select="11"/>
		<xsl:with-param name="day" select="25"/>
	</xsl:call-template>
	</result>

	<result>
	julian-day-to-date 1
	<xsl:call-template name="julian-day-to-date">
		<xsl:with-param name="j-day" select="1"/>
	</xsl:call-template>
	</result>

	<result>
	date-to-julian-day 1901-1-1
	<xsl:call-template name="date-to-julian-day">
		<xsl:with-param name="year" select="1901"/>
		<xsl:with-param name="month" select="1"/>
		<xsl:with-param name="day" select="1"/>
	</xsl:call-template>
	</result>

	<result>
	julian-day-to-date 2415386
	<xsl:call-template name="julian-day-to-date">
		<xsl:with-param name="j-day" select="2415386"/>
	</xsl:call-template>
	</result>


	<result>
	date-to-absolute-day 1902-1-1
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="year" select="1902"/>
		<xsl:with-param name="month" select="1"/>
		<xsl:with-param name="day" select="1"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-date 693961
	<xsl:call-template name="absolute-day-to-date">
		<xsl:with-param name="abs-day" select="693961"/>
	</xsl:call-template>
	</result>

	<result>
	hebrew-date-to-absolute-day 5662-10-22
	<xsl:call-template name="hebrew-date-to-absolute-day">
		<xsl:with-param name="year" select="5662"/>
		<xsl:with-param name="month" select="10"/>
		<xsl:with-param name="day" select="22"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-hebrew-date 693961
	<xsl:call-template name="absolute-day-to-hebrew-date">
		<xsl:with-param name="abs-day" select="693961"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-hebrew-date -1373427                       1373429
	<xsl:call-template name="absolute-day-to-hebrew-date">
		<xsl:with-param name="abs-day" select="-1373427"/>
	</xsl:call-template>
	</result>

	<result>
	date-to-absolute-day 2001-1-1
	<xsl:call-template name="date-to-absolute-day">
		<xsl:with-param name="year" select="2001"/>
		<xsl:with-param name="month" select="1"/>
		<xsl:with-param name="day" select="1"/>
	</xsl:call-template>
	</result>

	<result>
	absolute-day-to-date 2001-1-1
	<xsl:call-template name="absolute-day-to-date">
		<xsl:with-param name="abs-day" select="730486"/>
	</xsl:call-template>
	</result>


	<result>
	hebrew-date-to-absolute-day 5761-10-6
	<xsl:call-template name="hebrew-date-to-absolute-day">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="10"/>
		<xsl:with-param name="day" select="6"/>
	</xsl:call-template>
	</result>

	<result>
	last-day-of-hebrew-month 5761-7
	<xsl:call-template name="last-day-of-hebrew-month">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="7"/>
	</xsl:call-template>
	</result>

	<result>
	long-heshvan 5761
	<xsl:variable name="test">
		<xsl:call-template name="long-heshvan">
			<xsl:with-param name="year" select="5761"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="string($test)">long-heshvan</xsl:if>
	</result>


	<result>
	last-day-of-hebrew-month 5761-8
	<xsl:call-template name="last-day-of-hebrew-month">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="8"/>
	</xsl:call-template>
	</result>

	<result>
	last-day-of-hebrew-month 5761-9
	<xsl:call-template name="last-day-of-hebrew-month">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="9"/>
	</xsl:call-template>
	</result>

	<result>
	last-day-of-hebrew-month 5761-10
	<xsl:call-template name="last-day-of-hebrew-month">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="10"/>
	</xsl:call-template>
	</result>

	<result>
	last-day-of-hebrew-month 5761-11
	<xsl:call-template name="last-day-of-hebrew-month">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="11"/>
	</xsl:call-template>
	</result>

	<result>
	last-day-of-hebrew-month 5761-12
	<xsl:call-template name="last-day-of-hebrew-month">
		<xsl:with-param name="year" select="5761"/>
		<xsl:with-param name="month" select="12"/>
	</xsl:call-template>
	</result>
	
	
</results>	

</xsl:template>
  
</xsl:stylesheet>
