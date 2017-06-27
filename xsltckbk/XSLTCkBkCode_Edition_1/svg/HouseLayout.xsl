<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		version="1.0"> 
<xsl:output method="html" version="4"/>

<xsl:template match="/">
<html>
<head>
<title><xsl:value-of select="concat(*/*/Address,*/*/City,*/*/State)"/></title>
<script><![CDATA[

var item_selected = null;

// When the mouse ponter triggers the mouse over event
// This function is called.
// We are using both the SVGDOM and the XML DOM
// to access the document's tree nodes.
// More particularly, this function change elements
// identified by the id attribute.
// Note that to change a style attribute with the SVG DOM does not
// require to know in advance the value of the style attribute.
// In contrast, with the XML DOM you need to know the full content
// of the style attribute.
function on_mouse_over (ID)
{
	if (ID == item_selected)
		return true;

	var obj_name = ID ;
	
	// Change the SVG element's style
	// -------------------------------
	// 1 - get the SVGDOM document element from the Adobe SVG viewer
	// 2 - Then, get the element included in the SVG document and which is
	// referred by the id identifier.
	// 3 - Finally, Get the style attribute from the SVG DOM element node.
	// the getStyle function is particular to the SVG DOM.
	// the get style function returns a style object.
	// We change the 'fill' style attribute with the returned
	// style object. Note that in contrast to the XML DOM
	// we do not need to know in advance the content of the
	// style attribute's value to change one of the CSS attribute.
	var svgdoc = document.figure.getSVGDocument();
	var svgobj = svgdoc.getElementById(obj_name);
	if (svgobj != null)
	{
		var svgStyle = svgobj.getStyle(); 
		svgStyle.setProperty ('fill', 'yellow'); 
	}

	// Here is what we should have if the target browser
	// would fully support the XML DOM
	// --------------------------------------------------
	// Get the element inluded in this HTML document (see in the body
	// section) and which is referred by the identifier.
	///Change the element's style attribute using the
	// XML DOM. Please note that in contrast to the SVG DOM
	// function, the whole style attribute's value is changed and
	// not the value of a single contained CSS attribute.
	// DOES NOT WORK...
	var svgdesc = document.getElementById(obj_name);
	if (svgdesc != null)
		svgdesc.setAttribute("style", "background-color:yellow; cursor:hand");

	// Here is what we do for the IE 5 DHTML DOM
	// -----------------------------------------
	var DHTMLobj = document.all.item(obj_name)
	if (DHTMLobj != null)
		DHTMLobj.style.backgroundColor = "yellow";
	return true;
}

// When the mouse ponter triggers the mouse over event
// This function is called.
// We are using both the SVGDOM and the XML DOM
// to access the document's tree nodes.
// More particularly, this function change elements
// identified by the id attribute.
// Note that to change a style attribute with the SVG DOM does not
// require to know in advance the value of the style attribute.
// In contrast, with the XML DOM you need to know the full content
// of the style attribute.
function on_mouse_out (ID)
{
	if (ID == item_selected)
		return true;

	var obj_name = ID ;
	
	// Change the SVG element's style
	// -------------------------------
	// 1 - get the SVGDOM document element from the Adobe SVG viewer
	// 2 - Then, get the element included in the SVG document and which is
	// referred by the identifier.
	// 3 - Finally, Get the style attribute from the SVG DOM element node.
	// the getStyle function is particular to the SVG DOM.
	// the get style function returns a style object.
	// We change the 'fill' style attribute with the returned
	// style object. Note that in contrast to the XML DOM
	// we do not need to know in advance the content of the
	// style attribute's value to change one of the CSS attribute.
	var svgdoc = document.figure.getSVGDocument();
	var svgobj = svgdoc.getElementById(obj_name);
	if (svgobj != null)
	{
		var svgStyle = svgobj.getStyle(); 
		svgStyle.setProperty ('fill', 'white'); 
		svgStyle.setProperty ('stroke', 'white'); 
	}

	// Here is what we should have if the target browser
	// would fully support the XML DOM
	// --------------------------------------------------
	// Get the element inluded in this HTML document (see in the body
	// section) and which is referred by the identifier. 
	///Change the element's style attribute using the
	// XML DOM. Please note that in contrast to the SVG DOM
	// function, the whole style attribute's value is changed and
	// not the value of a single contained CSS attribute.
	// DOES NOT WORK...
	var svgdesc = document.getElementById(obj_name);
	if (svgdesc != null)
		svgdesc.setAttribute("style", "background-color:white;");

	// Here is what we for the IE 5 DHTML DOM
	// --------------------------------------
	var DHTMLobj = document.all.item(obj_name)
	if (DHTMLobj != null)
		DHTMLobj.style.backgroundColor = "white";

	return true;
}

function on_mouse_click(ID)
{
	var obj_name = ID ;
	
	// reset the color of the previously selected room
	if (item_selected)
	{
		var svgdoc = document.figure.getSVGDocument();
		var svgobj = svgdoc.getElementById(obj_name);
		if (svgobj != null)
		{
			var svgStyle = svgobj.getStyle(); 
			svgStyle.setProperty ('fill', 'white'); 
		}
		var DHTMLobj = document.all.item(obj_name)
		if (DHTMLobj != null)
		{
			DHTMLobj.style.backgroundColor = "white";
			DHTMLobj.style.fontWeight  = "normal";
		}
	}
	// Now select the new room
	if (item_selected != ID)
	{
		var svgdoc = document.figure.getSVGDocument();
		var svgobj = svgdoc.getElementById(obj_name);
		if (svgobj != null)
		{
			var svgStyle = svgobj.getStyle(); 
			svgStyle.setProperty ('fill', '#C0C0C0'); 
		}
		var DHTMLobj = document.all.item(obj_name)
		if (DHTMLobj != null)
		{
			DHTMLobj.style.backgroundColor = "#C0C0C0";
			DHTMLobj.style.fontWeight  = "bolder";
		}
		item_selected = ID;	
	}
	else
		item_selected = null;



	return true;	
}
]]></script>
</head>

<body>
	<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="Layout">
	<div align="center">
		<embed name="figure" width="540" height="540" type="image/svg" pluginspage="http://www.adobe.com/svg/viewer/install/">
		<xsl:attribute name="src"><xsl:value-of select="@figure"/></xsl:attribute>
		</embed>
	</div>
	<table border="0" cellpadding="1" cellspacing="0" width="100%" bgcolor="black">
	<tr>
		<table border="0" cellpadding="5" cellspacing="0" width="100%" bgcolor="white">
			<tr style="background-color:#990033; color:white;">
				<td>Room</td>
				<td align="right">Length</td>
				<td align="right">Width</td>
				<td align="right">Windows</td>
				<td>Miscelaneous</td>
			</tr>
			<xsl:apply-templates/>
		</table>
	</tr>
</table>
</xsl:template>

<xsl:template match="Room">
    <tr id="{@id}" style="'background-color:white;'" 
        onmouseover="on_mouse_over('{@id}')" 
        onmouseout="on_mouse_out('{@id}')" 
        onclick="on_mouse_click('{@id}')">
	<td><xsl:value-of select="Name"/></td>
	<td align="right"><xsl:value-of select="Length"/></td>
	<td align="right"><xsl:value-of select="Width"/></td>
	<td align="right"><xsl:value-of select="Windows"/></td>
	<td><xsl:value-of select="Misc"/></td>
    </tr>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>