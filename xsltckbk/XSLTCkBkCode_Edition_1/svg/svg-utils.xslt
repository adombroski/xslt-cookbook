<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:emath="http://www.exslt.org/math" 
  xmlns:Math="java:java.lang.Math" extension-element-prefixes="Math" exclude-result-prefixes="svgu">
  
  <xsl:script implements-prefix="Math"
                   xmlns:Math="java:java.lang.Math"
                   language="java"
                   src="java:java.lang.Math"/>

  <xsl:include href="../math/math.max.xslt"/>
  <xsl:include href="../math/math.min.xslt"/>

  <svgu:color>red</svgu:color>    
  <svgu:color>orange</svgu:color>    
  <svgu:color>yellow</svgu:color>    
  <svgu:color>green</svgu:color>    
  <svgu:color>blue</svgu:color>    
  <svgu:color>lime</svgu:color>    
  <svgu:color>aqua</svgu:color>    
  <svgu:color>teal</svgu:color>    
  <svgu:color>brown</svgu:color>    
  <svgu:color>black</svgu:color>    

  <xsl:variable name="svgu:pi" select="3.1415927"/>
  
  <xsl:template name="svgu:pieSlice">
    <xsl:param name="cx" select="100"/>  <!-- Center x -->
    <xsl:param name="cy" select="100"/>  <!-- Center y -->
    <xsl:param name="r" select="50"/>       <!-- Radius -->
    <xsl:param name="theta" select="0"/>  <!-- Beginning angle in degrees-->
    <xsl:param name="delta" select="90"/>  <!-- Arc extent in degrees -->
    <xsl:param name="phi" select="0"/>  <!-- x-axis rotation angle -->
    <xsl:param name="style" select=" 'fill: red;' "/> 
    <xsl:param name="num"/>
    <xsl:param name="context"/>
  
    <!--Convert angles to radians -->
    <xsl:variable name="theta1" select="$theta * $svgu:pi div 180"/>
    <xsl:variable name="theta2" select="($delta + $theta) * $svgu:pi div 180"/>
    <xsl:variable name="phi_r" select="$phi * $svgu:pi div 180"/>

    <!--Figure out begin and end coordinates -->  
    <xsl:variable name="x0"   select="$cx + Math:cos($phi_r) * $r * Math:cos($theta1) +
                                                           Math:sin(-$phi_r) * $r * Math:sin($theta1)"/>
    <xsl:variable name="y0"   select="$cy + Math:sin($phi_r) * $r * Math:cos($theta1) +
                                                           Math:cos($phi_r) * $r * Math:sin($theta1)"/>
  
    <xsl:variable name="x1"   select="$cx + Math:cos($phi_r) * $r * Math:cos($theta2) +
                                                           Math:sin(-$phi_r) * $r * Math:sin($theta2)"/>
    <xsl:variable name="y1"   select="$cy + Math:sin($phi_r) * $r * Math:cos($theta2) +
                                                           Math:cos($phi_r) * $r * Math:sin($theta2)"/>
    
    <xsl:variable name="large-arc" select="($delta > 180) * 1"/>
    <xsl:variable name="sweep" select="($delta > 0) * 1"/>
  
    <svg:path style="{$style}" id="{$context}_pieSlice_{$num}">
      <xsl:attribute name="d">
        <xsl:value-of select="concat('M ', $x0,' ',$y0,
                                                       ' A ', $r,' ',$r,',',
                                                       $phi,',',
                                                       $large-arc,',',
                                                       $sweep,',',
                                                       $x1,' ',$y1,
                                                       ' L ',$cx,' ',$cy,
                                                       ' L ', $x0,' ',$y0)"/>
       
      </xsl:attribute>
    </svg:path>
  </xsl:template>

  <xsl:template name="svgu:pieSliceLabel">
    <xsl:param name="label" />                   <!-- Label -->
    <xsl:param name="cx" select="100"/>  <!-- Center x -->
    <xsl:param name="cy" select="100"/>  <!-- Center y -->
    <xsl:param name="r" select="50"/>       <!-- Radius -->
    <xsl:param name="theta" select="0"/>  <!-- Beginning angle in degrees-->
    <xsl:param name="delta" select="90"/>  <!-- Arc extent in degrees -->
    <xsl:param name="style" select=" 'font-size: 18;' "/> 
    <xsl:param name="num"/>
    <xsl:param name="context"/>
  
    <!--Convert angles to radians -->
    <xsl:variable name="theta2" select="(($delta + $theta) mod 360 + 360) mod 360"/> <!-- normalize angles -->
    <xsl:variable name="theta2_r" select="$theta2 * $svgu:pi div 180"/>
    <xsl:variable name="x"   select="$cx + $r * Math:cos($theta2_r)"/>
    <xsl:variable name="y"   select="$cy + $r * Math:sin($theta2_r)"/>
    
    
    <xsl:variable name="anchor">
      <xsl:choose>
        <xsl:when test="contains($style,'text-anchor')"></xsl:when>
        <xsl:when test="$theta2 >= 0 and $theta2 &lt;= 45">start</xsl:when>
        <xsl:when test="$theta2 > 45 and $theta2 &lt;= 135">middle</xsl:when>
        <xsl:when test="$theta2 > 135 and $theta2 &lt;= 225">end</xsl:when>
        <xsl:when test="$theta2 > 225 and $theta2 &lt;= 315">middle</xsl:when>
        <xsl:otherwise>start</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <svg:text x="{$x}" 
                    y="{$y}" 
                   style="text-anchor:{$anchor};{$style}"
                   id="{$context}_pieSliceLabel_{$num}">
       <xsl:value-of select="$label"/>
    </svg:text>
  </xsl:template>

  <xsl:template name="svgu:pie">
    <xsl:param name="data" select="/.."/>  <!-- Node set of numbers to chart -->
    <xsl:param name="cx" select="100"/>  <!-- Center x -->
    <xsl:param name="cy" select="100"/>  <!-- Center y -->
    <xsl:param name="r" select="50"/>       <!-- Radius -->
    <xsl:param name="theta" select="-90"/>  <!-- Beginning angle for first slice in degrees-->
    <xsl:param name="context"/>               <!-- User data to identify this invocation --> 

    <xsl:call-template name="svgu:pieImpl">
      <xsl:with-param name="data" select="$data"/>  
      <xsl:with-param name="cx" select="$cx"/>  
      <xsl:with-param name="cy" select="$cy"/>  
      <xsl:with-param name="r" select="$r"/>       
      <xsl:with-param name="theta" select="$theta"/>  
      <xsl:with-param name="sum" select="sum($data)"/>   
      <xsl:with-param name="context" select="$context"/> 
    </xsl:call-template>  
  
  </xsl:template>


  <xsl:template name="svgu:pieImpl">
    <xsl:param name="data" />  
    <xsl:param name="cx" />  
    <xsl:param name="cy" />  
    <xsl:param name="r" />       
    <xsl:param name="theta"/>  
    <xsl:param name="sum"/>   
    <xsl:param name="context"/> 
    <xsl:param name="i" select="1"/>
    
    <xsl:if test="count($data) >= $i">
      <xsl:variable name="delta" select="($data[$i] * 360) div $sum"/>

      <!-- Draw slice of pie -->
      <xsl:call-template name="svgu:pieSlice">
        <xsl:with-param name="cx" select="$cx"/>  
        <xsl:with-param name="cy" select="$cy"/>  
        <xsl:with-param name="r" select="$r"/>       
        <xsl:with-param name="theta" select="$theta"/>  
        <xsl:with-param name="delta" select="$delta"/>  
        <xsl:with-param name="style">
          <xsl:call-template name="svgu:pieSliceStyle">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:with-param> 
        <xsl:with-param name="num" select="$i"/>
        <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
        
      <!-- Recursive call for next slice -->
        <xsl:call-template name="svgu:pieImpl">
          <xsl:with-param name="data" select="$data"/>  
          <xsl:with-param name="cx" select="$cx"/>  
          <xsl:with-param name="cy" select="$cy"/>  
          <xsl:with-param name="r" select="$r"/>       
          <xsl:with-param name="theta" select="$theta + $delta"/>  
          <xsl:with-param name="sum" select="$sum"/>   
          <xsl:with-param name="context" select="$context"/> 
          <xsl:with-param name="i" select="$i + 1"/>
        </xsl:call-template>
    </xsl:if>
      
  </xsl:template>  


  <xsl:template name="svgu:pieLabels">
    <xsl:param name="data" select="/.."/>          <!-- Node set of numbers that determine slices -->
    <xsl:param name="labels" select="$data"/>  <!-- Node set of labels to chart. Defaults to data -->
    <xsl:param name="cx" select="100"/>          <!-- Center x -->
    <xsl:param name="cy" select="100"/>          <!-- Center y -->
    <xsl:param name="r" select="50"/>               <!-- Radius -->
    <xsl:param name="theta" select="-90"/>       <!-- Beginning angle for first slice in degrees-->
    <xsl:param name="context"/>                        <!-- User data to identify this invocation --> 

    <xsl:call-template name="svgu:pieLabelsImpl">
      <xsl:with-param name="data" select="$data"/>  
      <xsl:with-param name="labels" select="$labels"/>  
      <xsl:with-param name="cx" select="$cx"/>  
      <xsl:with-param name="cy" select="$cy"/>  
      <xsl:with-param name="r" select="$r"/>       
      <xsl:with-param name="theta" select="$theta"/>  
      <xsl:with-param name="sum" select="sum($data)"/>   
      <xsl:with-param name="context" select="$context"/> 
    </xsl:call-template>  
  
  </xsl:template>

  <xsl:template name="svgu:pieLabelsImpl">
    <xsl:param name="data" />  
    <xsl:param name="labels"/>  
    <xsl:param name="cx" />  
    <xsl:param name="cy" />  
    <xsl:param name="r" />       
    <xsl:param name="theta"/>  
    <xsl:param name="sum"/>   
    <xsl:param name="context"/> 
    <xsl:param name="i" select="1"/>
    
    <xsl:if test="count($data) >= $i">
      <xsl:variable name="delta" select="($data[$i] * 360) div $sum"/>

      <!-- Draw slice of pie -->
      <xsl:call-template name="svgu:pieSliceLabel">
        <xsl:with-param name="label" select="$labels[$i]"/>
        <xsl:with-param name="cx" select="$cx"/>  
        <xsl:with-param name="cy" select="$cy"/>  
        <xsl:with-param name="r" select="$r"/>       
        <xsl:with-param name="theta" select="$theta"/>  
        <xsl:with-param name="delta" select="$delta div 2"/>  
        <xsl:with-param name="style">
          <xsl:call-template name="svgu:pieSliceLabelStyle">
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="value" select="$data[$i]"/>
            <xsl:with-param name="label" select="$labels[$i]"/>
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:with-param> 
        <xsl:with-param name="num" select="$i"/>
        <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
        
      <!-- Recursive call for next slice label -->
        <xsl:call-template name="svgu:pieLabelsImpl">
          <xsl:with-param name="data" select="$data"/>  
          <xsl:with-param name="labels" select="$labels"/>  
          <xsl:with-param name="cx" select="$cx"/>  
          <xsl:with-param name="cy" select="$cy"/>  
          <xsl:with-param name="r" select="$r"/>       
          <xsl:with-param name="theta" select="$theta + $delta"/>  
          <xsl:with-param name="sum" select="$sum"/>   
          <xsl:with-param name="context" select="$context"/> 
          <xsl:with-param name="i" select="$i + 1"/>
        </xsl:call-template>
    </xsl:if>
      
  </xsl:template>  

  <xsl:template name="svgu:pieSliceStyle">
    <xsl:param name="i"/>
    <xsl:param name="context"/>
    <xsl:variable name="colors" select="document('')/*/svgu:color"/>
    <xsl:value-of select="concat('stroke:black;stroke-width:0.5;fill: ',$colors[($i - 1 ) mod count($colors) + 1])"/>
  </xsl:template>

  <xsl:template name="svgu:pieSliceLabelStyle">
    <xsl:param name="i"/>
    <xsl:param name="value"/>
    <xsl:param name="label" />
    <xsl:param name="context"/>
    <xsl:text>font-size: 16;</xsl:text>
  </xsl:template>
  
  <xsl:template name="svgu:bars">
    <xsl:param name="data" select="/.."/>            <!-- Node set of numbers to chart -->
    <xsl:param name="width" select=" '500' "/>
    <xsl:param name="height" select=" '500' "/>
    <xsl:param name="orientation" select=" '0' "/>
    <xsl:param name="barWidth" select=" '5' "/> 
    <xsl:param name="offsetX" select="0"/>
    <xsl:param name="offsetY" select="0"/>
    <xsl:param name="boundingBox" select="false()"/>
    <xsl:param name="barLabel" select="false()"/>
    <xsl:param name="max">
     <xsl:call-template name="emath:max">
       <xsl:with-param name="nodes" select="$data"/>
     </xsl:call-template>
    </xsl:param>
    <xsl:param name="context"/>
  
    
   <xsl:variable name="numBars" select="count($data)"/>
    <xsl:variable name="spacing" select="$width div ($numBars + 1)"/>

  <xsl:if test="$boundingBox">
    <svg:g transform="translate({$offsetX},{$offsetY}) translate({$width div 2},{$height div 2}) rotate({$orientation - 180}) translate({-$width div 2},{-$height div 2})">
       <svg:rect x="0" y="0" height="{$height}" width="{$width}" style="stroke: black;stroke-width:0.5;stroke-opacity:0.5;fill:none"/>
     </svg:g>
   </xsl:if>

    <xsl:variable name="data-order">
      <xsl:choose>
        <xsl:when test="$orientation mod 360 >= 180">ascending</xsl:when>
        <xsl:otherwise>descending</xsl:otherwise>
      </xsl:choose>
    </xsl:variable> 

    
    <svg:g transform="translate({$offsetX},{$offsetY}) 
                            translate({$width div 2},{$height div 2}) 
                            rotate({$orientation - 180}) 
                            translate({-$width div 2},{-$height div 2}) 
                            scale(1,{$height div $max})">
                            
      <xsl:for-each select="$data">
        <xsl:sort select="position()" data-type="number" order="{$data-order}"/>
        
        <xsl:variable name="pos" select="position()"/>
        
        <svg:line x1="{$spacing * $pos}" 
                y1="0" 
                x2="{$spacing * $pos}"  
                y2="{current()}" id="{$context}_bar_{$pos}">
           <xsl:attribute name="style">
             <xsl:value-of select="concat('stroke-width: ',$barWidth,'; ')"/>
             <xsl:call-template name="svgu:barStyle">
               <xsl:with-param name="pos" select="$pos"/>
               <xsl:with-param name="context" select="$context"/>
             </xsl:call-template>
           </xsl:attribute>         
        </svg:line>  
         
        <xsl:if test="$barLabel">
          <svg:text x="{$spacing * $pos}" 
                   y="{current() * ($height div $max)}" 
                   transform="scale(1,{$max div $height}) 
                                      translate(0,10) 
                                      translate({$spacing * $pos},{current() * ($height div $max)}) 
                                      rotate({180 - $orientation}) 
                                      translate({-$spacing * $pos},{-current() * ($height div $max)})"
                  id="{$context}_barLabel_{$pos}">
                  <xsl:attribute name="style">
                   <xsl:call-template name="svgu:barLabelStyle">
                     <xsl:with-param name="pos" select="$pos"/>
                     <xsl:with-param name="context" select="$context"/>
                   </xsl:call-template>
                  </xsl:attribute>         
                  <xsl:value-of select="."/>
          </svg:text>
        </xsl:if>        
      </xsl:for-each>
    </svg:g>
  
  </xsl:template>	

   <xsl:template name="svgu:barStyle">
     <xsl:param name="pos"/>
     <xsl:param name="context"/>
     <xsl:variable name="colors" select="document('')/*/svgu:color"/>
      <xsl:value-of select="concat('stroke: ',$colors[($pos - 1 ) mod count($colors) + 1])"/>
   </xsl:template>

   <xsl:template name="svgu:barLabelStyle">
     <xsl:param name="pos"/>
     <xsl:param name="context"/>
     <xsl:value-of select=" 'text-anchor: middle' "/>
   </xsl:template>


  <xsl:template name="svgu:xyPlot">
    <xsl:param name="dataX" select="/.."/>     <!-- X values -->
    <xsl:param name="dataY" select="/.."/>    <!-- Y values -->
    <xsl:param name="offsetX" select="0"/>   <!-- X offset of origin placement -->
    <xsl:param name="offsetY" select="0"/>   <!-- Y offset of origin placement -->
    <xsl:param name="width" select="500"/>  <!-- Width of plot area -->
    <xsl:param name="height" select="500"/>  <!-- Height of plot area -->
    <xsl:param name="boundingBox" select="false()"/> <!--Bounding box around plot area -->
    <xsl:param name="minX">                         <!-- Min X data value (defaults to actual min) -->
     <xsl:choose>
      <xsl:when test="not($dataX)">0</xsl:when>
      <xsl:otherwise>
       <xsl:call-template name="emath:min">
         <xsl:with-param name="nodes" select="$dataX"/>
       </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose> 
    </xsl:param>
    <xsl:param name="minY">                        <!-- Min Y data value (defaults to actual min) -->
     <xsl:call-template name="emath:min">
       <xsl:with-param name="nodes" select="$dataY"/>
     </xsl:call-template>
    </xsl:param>
    <xsl:param name="maxX">                         <!-- Max X data value (defaults to actual max) -->
     <xsl:choose>
      <xsl:when test="not($dataX)">
        <xsl:value-of select="count($dataY) - 1"/>
      </xsl:when>
      <xsl:otherwise>
     <xsl:call-template name="emath:max">
       <xsl:with-param name="nodes" select="$dataX"/>
     </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose> 
    </xsl:param>
    <xsl:param name="maxY">                        <!-- Max Y data value (defaults to actual max) -->
     <xsl:call-template name="emath:max">
       <xsl:with-param name="nodes" select="$dataY"/>
     </xsl:call-template>
    </xsl:param>
    <xsl:param name="context"/>                    <!-- A user defined context indicator for formatting template calls -->  

   
    <!-- Compute ranges --> 
    <xsl:variable name="rangeX" select="$maxX - $minX"/>
    <xsl:variable name="rangeY" select="$maxY - $minY"/>
   
    <!-- Scale based on X range -->
    <xsl:variable name="scaleX" select="$width div $rangeX"/>

    <!-- Scale based on Y range -->
    <xsl:variable name="scaleY" select="$height div $rangeY"/>

    <!-- Max scale for path stroke width adjustment -->
    <xsl:variable name="scale" select="Math:max($scaleX,$scaleY)"/>


    <xsl:if test="$boundingBox">
      <svg:g transform="translate({$offsetX},{$offsetY})">
       <svg:rect x="0" y="0" height="{$height}" width="{$width}" style="stroke: black;stroke-width:0.5;stroke-opacity:0.5;fill:none"/>
     </svg:g>
    </xsl:if>    
    
    <svg:path transform="translate({$offsetX},{$height + $offsetY})    
                                scale({$scaleX},{-$scaleY})
                                translate({$minX},{-$minY})"
                     id="{$context}_xyPlot">
                                
      <xsl:attribute name="d">
        <xsl:for-each select="$dataY">
          <xsl:variable name="pos" select="position()"/>

          <xsl:variable name="x">
            <xsl:choose>
              <xsl:when test="$dataX">
                <xsl:value-of select="$dataX[$pos]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$pos - 1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable> 
         
          <xsl:variable name="y" select="current()"/>
          
          <xsl:choose>
            <xsl:when test="$pos = 1">
              <xsl:text>M </xsl:text>
            </xsl:when>
            <xsl:otherwise> L </xsl:otherwise>
          </xsl:choose>  
          <xsl:value-of select="$x"/>,<xsl:value-of select="$y"/>
        </xsl:for-each>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:call-template name="svgu:xyPlotStyle">
            <xsl:with-param name="scale" select="$scale"/>
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:attribute>
    </svg:path>
  </xsl:template>  

   <xsl:template name="svgu:xyPlotStyle">
     <xsl:param name="context"/>
     <xsl:param name="scale"/>
     <xsl:value-of select="concat('fill: none; stroke: black; stroke-width:',1 div $scale,'; ')"/>
   </xsl:template>
  
<!-- Draw a graduated X-Axis -->
  <xsl:template name="svgu:xAxis">
    <xsl:param name="min" 
                       select="0"/>  <!-- Min x coordinate -->
    <xsl:param name="max" 
                       select="100"/>  <!-- Max x coordinate -->
    <xsl:param name="offsetX" 
                       select="0"/>      <!-- X offset of axis placment -->
    <xsl:param name="offsetY"
                       select="0"/>      <!-- Y offset of axis placment -->
    <xsl:param name="width"
                       select="500"/>  <!-- Width of the physical plotting area -->
    <xsl:param name="height"
                       select="500"/>  <!-- Height of the physical plotting area -->  
    <xsl:param name="majorTicks"
                       select="10"/>    <!-- Number of major axis divisions -->
    <xsl:param name="majorBottomExtent" 
                       select="4"/>      <!-- Length of the major tick mark from axis downward -->
    <xsl:param name="majorTopExtent"
                       select="$majorBottomExtent"/> <!-- Length of the major tick mark from axis upward -->
    <xsl:param name="labelMajor"
                       select="true()"/> <!-- Label the major tick marks if true -->
    <xsl:param name="minorTicks"
                       select="4"/>      <!-- Number of minor axis divisions per major division-->
    <xsl:param name="minorBottomExtent"
                       select="2"/> <!-- Length of the minor tick mark from axis downward -->
    <xsl:param name="minorTopExtent"
                       select="$minorBottomExtent"/> <!-- Length of the minor tick mark from axis upward -->
    <xsl:param name="labelMinor"
                       select="false()"/> <!-- Label the minor tick marks if true -->
    <xsl:param name="context"/> <!-- A user defined context indicator for formatting template calls -->
    
    <!-- Compute the range and scaling factors -->
    <xsl:variable name="range" select="$max - $min"/>
    <xsl:variable name="scale" select="$width div $range"/>
    
    <!-- Establish a Cartesion coordinate system with correct offset and scaling -->
    <svg:g transform="translate({$offsetX},{$offsetY+$height}) scale({$scale},-1) translate({$min},0)">
      <!-- Draw a line for the axis -->
      <svg:line x1="{$min}" y1="0" x2="{$max}"  y2="0" id="{$context}_xaxis">
        <xsl:attribute name="style">
         <!-- Call a template that can be overridden to determine the axis style -->
          <xsl:call-template name="xAxisStyle">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:attribute>
      </svg:line>

      <!-- Draw the tick marks and labels -->
      <xsl:call-template name="svgu:ticks">
        <xsl:with-param name="xMajor1" select="$min"/>
        <xsl:with-param name="yMajor1" select="$majorTopExtent"/>
        <xsl:with-param name="xMajor2" select="$min"/>
        <xsl:with-param name="yMajor2" select="-$majorBottomExtent"/>
        <xsl:with-param name="labelMajor" select="$labelMajor"/>
        <xsl:with-param name="freq" select="$minorTicks"/>
        <xsl:with-param name="xMinor1" select="$min"/>
        <xsl:with-param name="yMinor1" select="$minorTopExtent"/>
        <xsl:with-param name="xMinor2" select="$min"/>
        <xsl:with-param name="yMinor2" select="-$minorBottomExtent"/>
        <xsl:with-param name="nTicks" select="$majorTicks * $minorTicks + 1"/>
        <xsl:with-param name="xIncr" select="($max - $min) div ($majorTicks * $minorTicks)"/>
        <xsl:with-param name="scale" select="1 div $scale"/>
      </xsl:call-template>
    </svg:g>
    
   </xsl:template>

  <xsl:template name="svgu:yAxis">
    <xsl:param name="min" select="0"/>
    <xsl:param name="max" select="100"/>
    <xsl:param name="offsetX" select="0"/>
    <xsl:param name="offsetY" select="0"/>
    <xsl:param name="width" select="500"/>
    <xsl:param name="height" select="500"/>
    <xsl:param name="majorTicks" select="10"/>
    <xsl:param name="majorLeftExtent" select="4"/>
    <xsl:param name="majorRightExtent" select="$majorLeftExtent"/>
    <xsl:param name="labelMajor" select="true()"/>
    <xsl:param name="minorTicks" select="4"/>
    <xsl:param name="minorLeftExtent" select="2"/>
    <xsl:param name="minorRightExtent" select="$minorLeftExtent"/>
    <xsl:param name="labelMinor" select="false()"/>
    <xsl:param name="context"/> 
    
    <xsl:variable name="range" select="$max - $min"/>
    <xsl:variable name="scale" select="$height div $range"/>

    
    <svg:g transform="translate({$offsetX},{$offsetY+$height}) scale(1,{-$scale}) translate(0,{-$min})">
      <svg:line x1="0" y1="{$min}" x2="0"  y2="{$max}">
        <xsl:attribute name="style">
          <xsl:call-template name="yAxisStyle">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
        </xsl:attribute>
      </svg:line>

      <xsl:call-template name="svgu:ticks">
        <xsl:with-param name="xMajor1" select="-$majorLeftExtent"/>
        <xsl:with-param name="yMajor1" select="$min"/>
        <xsl:with-param name="xMajor2" select="$majorRightExtent"/>
        <xsl:with-param name="yMajor2" select="$min"/>
        <xsl:with-param name="labelMajor" select="$labelMajor"/>
        <xsl:with-param name="freq" select="$minorTicks"/>
        <xsl:with-param name="xMinor1" select="-$minorLeftExtent"/>
        <xsl:with-param name="yMinor1" select="$min"/>
        <xsl:with-param name="xMinor2" select="$minorRightExtent"/>
        <xsl:with-param name="yMinor2" select="$min"/>
        <xsl:with-param name="nTicks" select="$majorTicks * $minorTicks + 1"/>
        <xsl:with-param name="yIncr" select="($max - $min) div ($majorTicks * $minorTicks)"/>
        <xsl:with-param name="scale" select="1 div $scale"/>
        <xsl:with-param name="context" select="$context"/> 
      </xsl:call-template>
    </svg:g>
    
   </xsl:template>


    <xsl:template name="svgu:ticks">
      <xsl:param name="xMajor1" />
      <xsl:param name="yMajor1" />
      <xsl:param name="xMajor2" />
      <xsl:param name="yMajor2" />
      <xsl:param name="labelMajor"/>
      <xsl:param name="freq" />
      <xsl:param name="xMinor1" />
      <xsl:param name="yMinor1" />
      <xsl:param name="xMinor2" />
      <xsl:param name="yMinor2" />
      <xsl:param name="nTicks" select="0"/>
      <xsl:param name="xIncr" select="0"/> 
      <xsl:param name="yIncr" select="0"/> 
      <xsl:param name="i" select="0"/>
      <xsl:param name="scale"/>
      <xsl:param name="context"/>
      
      <xsl:if test="$i &lt; $nTicks">
        <xsl:choose>
          <xsl:when test="$i mod $freq = 0">
            <svg:line x1="{$xMajor1}" y1="{$yMajor1}" x2="{$xMajor2}" y2="{$yMajor2}">
            </svg:line>
            <xsl:if test="$labelMajor">
              <xsl:choose>
                <xsl:when test="$xIncr > 0">
                  <svg:text x="{$xMajor1}" y="{$yMajor2}" 
                           transform="translate({$xMajor1},{$yMajor2}) scale({$scale},-1) translate({-$xMajor1},{-$yMajor2})">
                           <xsl:attribute name="style">
                             <xsl:call-template name="xAxisLabelStyle">
                               <xsl:with-param name="context" select="$context"/>
                             </xsl:call-template>
                           </xsl:attribute>
                           <xsl:attribute name="dy">
                             <xsl:call-template name="xAxisLabelYOffset">
                               <xsl:with-param name="context" select="$context"/>
                             </xsl:call-template>
                           </xsl:attribute>
                    <xsl:value-of select="format-number($xMajor1,'#0.0')"/>
                  </svg:text>
                </xsl:when>
                <xsl:otherwise>
                  <svg:text  y="{$yMajor1}" 
                           transform="translate({$xMajor1},{$yMajor1}) scale(1,{-$scale}) translate({-$xMajor1},{-$yMajor1})">
                       <xsl:attribute name="style">
                         <xsl:call-template name="yAxisLabelStyle">
                           <xsl:with-param name="context" select="$context"/>
                         </xsl:call-template>
                       </xsl:attribute>
                       <xsl:attribute name="x">
                         <xsl:variable name="xMajorOffset">
                           <xsl:call-template name="yAxisLabelXOffset">
                             <xsl:with-param name="context" select="$context"/>
                           </xsl:call-template>
                         </xsl:variable>
                          <xsl:value-of select="$xMajor1 + $xMajorOffset"/>
                       </xsl:attribute>
                      <xsl:value-of select="format-number($yMajor1,'#0.0')"/>
                  </svg:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <svg:line x1="{$xMinor1}" y1="{$yMinor1}" x2="{$xMinor2}" y2="{$yMinor2}">
            </svg:line>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="svgu:ticks">
          <xsl:with-param name="xMajor1" select="$xMajor1 + $xIncr"/>
          <xsl:with-param name="yMajor1" select="$yMajor1 + $yIncr"/>
          <xsl:with-param name="xMajor2" select="$xMajor2 + $xIncr"/>
          <xsl:with-param name="yMajor2" select="$yMajor2 + $yIncr"/>
          <xsl:with-param name="labelMajor" select="$labelMajor"/>
          <xsl:with-param name="freq" select="$freq"/>
          <xsl:with-param name="xMinor1" select="$xMinor1 + $xIncr"/>
          <xsl:with-param name="yMinor1" select="$yMinor1 + $yIncr"/>
          <xsl:with-param name="xMinor2" select="$xMinor2 + $xIncr"/>
          <xsl:with-param name="yMinor2" select="$yMinor2 + $yIncr"/>
          <xsl:with-param name="nTicks" select="$nTicks"/>
          <xsl:with-param name="xIncr" select="$xIncr"/> 
          <xsl:with-param name="yIncr" select="$yIncr"/> 
          <xsl:with-param name="i" select="$i + 1"/>
          <xsl:with-param name="scale" select="$scale"/>
          <xsl:with-param name="context" select="$context"/>
        </xsl:call-template>
      </xsl:if>
      
    </xsl:template>

   <xsl:template name="xAxisStyle">
     <xsl:param name="context"/>
      <xsl:text>stroke-width:0.5;stroke:black</xsl:text>
   </xsl:template>

   <xsl:template name="yAxisStyle">
     <xsl:param name="context"/>
      <xsl:text>stroke-width:0.5;stroke:black</xsl:text>
   </xsl:template>

   <xsl:template name="xAxisLabelStyle">
     <xsl:param name="context"/>
     <xsl:text>text-anchor:middle;font-size:8;baseline-shift:-110%</xsl:text>
   </xsl:template>

   <xsl:template name="yAxisLabelStyle">
     <xsl:param name="context"/>
     <xsl:text>text-anchor:end;font-size:8;baseline-shift:-50%</xsl:text>
   </xsl:template>

   <xsl:template name="xAxisLabelYOffset">0</xsl:template>

   <xsl:template name="yAxisLabelXOffset">0</xsl:template>


<!-- Open - Hi - Lo - Close -->
  <xsl:template name="svgu:openHiLoClose">
    <xsl:param name="openData" select="/.."/>            
    <xsl:param name="hiData" select="/.."/>            
    <xsl:param name="loData" select="/.."/>            
    <xsl:param name="closeData" select="/.."/>            
    <xsl:param name="width" select=" '500' "/>
    <xsl:param name="height" select=" '500' "/>
    <xsl:param name="offsetX" select="0"/>
    <xsl:param name="offsetY" select="0"/>
    <xsl:param name="openCloseExtent" select="4"/>
    <xsl:param name="max">
     <xsl:call-template name="emath:max">
       <xsl:with-param name="nodes" select="$hiData"/>
     </xsl:call-template>
    </xsl:param>
    <xsl:param name="min">
     <xsl:call-template name="emath:min">
       <xsl:with-param name="nodes" select="$loData"/>
     </xsl:call-template>
    </xsl:param>
    <xsl:param name="context"/>
  
    <xsl:variable name="hiCount" select="count($hiData)"/>
    <xsl:variable name="loCount" select="count($loData)"/>
    <xsl:variable name="openCount" select="count($openData)"/>
    <xsl:variable name="closeCount" select="count($closeData)"/>
    
    <xsl:variable name="numBars" select="Math:min($hiCount, $loCount)"/>
    
    <xsl:variable name="spacing" select="$width div ($numBars + 1)"/>
    
    <xsl:variable name="range" select="$max - $min"/>
    <xsl:variable name="scale" select="$height div $range"/>

    <svg:g transform="translate({$offsetX},{$offsetY+$height}) 
                            scale(1,{-$scale})
                            translate(0,{-$min})">
                            
      <xsl:for-each select="$hiData">
        <xsl:variable name="pos" select="position()"/>

        <!--draw hi-lo line -->        
        <svg:line x1="{$spacing * $pos}" 
                y1="{$loData[$pos]}" 
                x2="{$spacing * $pos}"  
                y2="{current()}" id="{$context}_highLow_{$pos}">
           <xsl:attribute name="style">
             <xsl:call-template name="svgu:hiLoBarStyle">
               <xsl:with-param name="pos" select="$pos"/>
               <xsl:with-param name="context" select="$context"/>
             </xsl:call-template>
           </xsl:attribute>         
        </svg:line>  

        <!--draw open mark if opening data present -->        
        <xsl:if test="$openCount >= $pos">
          <svg:line x1="{$spacing * $pos - $openCloseExtent}" 
                  y1="{$openData[$pos]}" 
                  x2="{$spacing * $pos}"  
                  y2="{$openData[$pos]}"
                  id="{$context}_open_{$pos}">
             <xsl:attribute name="style">
               <xsl:call-template name="svgu:openCloseBarStyle">
                 <xsl:with-param name="pos" select="$pos"/>
                 <xsl:with-param name="scale" select="$scale"/>
                 <xsl:with-param name="context" select="$context"/>
               </xsl:call-template>
             </xsl:attribute>         
          </svg:line>  
        </xsl:if>      

        <!--draw close mark if closing data present -->        
        <xsl:if test="$closeCount >= $pos">
          <svg:line x1="{$spacing * $pos}" 
                  y1="{$closeData[$pos]}" 
                  x2="{$spacing * $pos +  $openCloseExtent}"  
                  y2="{$closeData[$pos]}" 
                  id="{$context}_close_{$pos}">
             <xsl:attribute name="style">
               <xsl:call-template name="svgu:openCloseBarStyle">
                 <xsl:with-param name="pos" select="$pos"/>
                 <xsl:with-param name="scale" select="$scale"/>
                 <xsl:with-param name="context" select="$context"/>
               </xsl:call-template>
             </xsl:attribute>         
          </svg:line>  
        </xsl:if>      
       
      </xsl:for-each>
    </svg:g>
  
  </xsl:template>	

   <xsl:template name="svgu:hiLoBarStyle">
     <xsl:param name="pos"/>
     <xsl:param name="context"/>
     <xsl:text>stroke: black; stroke-width: 1 </xsl:text>
   </xsl:template>

   <xsl:template name="svgu:openCloseBarStyle">
     <xsl:param name="pos"/>
     <xsl:param name="scale"/>
     <xsl:param name="context"/>
     <xsl:text>stroke: black; stroke-width: </xsl:text><xsl:value-of select="2 div $scale"/>
   </xsl:template>
  
</xsl:stylesheet>
