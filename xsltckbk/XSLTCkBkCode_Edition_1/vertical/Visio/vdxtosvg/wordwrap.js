/*
 * wordwrap - A script for SVG to emulate Visio's word wrapping.
 * 
 * Visio appears to follow the following wrapping rules:
 * a) lines always break at newlines.
 * b) spaces at the explicit beginning of a line (eg, beginning of string
 *    or after newline) affect alignment.
 * c) spaces at the end do not affect alignment.
 * d) spaces at a line wrap are assumed to all be at the end of the previous
 *    line.
 * e) lines will wrap at hyphens, but the hyphens affect alignment.
 * f) tabs do not cause wraps.
 * g) if a word will not fit, it is wrapped anyway.
 */

var dbgWindow;

function wrap_text(evt, maxWidth, hAlign, vAlign, lspace) {
  textnode = evt.getTarget();
  doc = textnode.getOwnerDocument();
  //alert("In wrap_text:'" + textnode.firstChild.data + "', " + maxWidth);
  //textBBox = textnode.parentNode.getBBox();
  if (!textnode ||
      !textnode.firstChild ||
      (textnode.firstChild.data.search(/\S/) < 0)) {
    // Nothing but whitespace
    return;
  }
  // Array for holding tspans
  tspan_array = new Array();
  // Left and right string indices
  lc = 0;
  rc = textnode.firstChild.data.indexOf("\n");
  done = 0;
  do {
    // Loop over each newline-separated substring
    if (rc < lc) {
      // Use all of remaining string
      rc = textnode.firstChild.data.length;
      done = 1;
    }
    if (textnode.getSubStringLength(lc, rc - lc) <= maxWidth) {
      // It fits without breaking; add line to tspan
      //alert(textnode.firstChild.data.substring(lc, rc) + "(" +
      //textnode.getSubStringLength(lc, rc - lc) + ")");
      tspan = doc.createElement("tspan");
      tspanContent = textnode.firstChild.data.substring(lc, rc);
      tspan.appendChild(doc.createTextNode(tspanContent));
      tspan_array.push(tspan);
    } else {
      // Note that whitespace after a newline is intentionally preserved
      do {
        // Break into chunks less than maxWidth at spaces and hyphens
	mc = lc;
	do {
          // Find word boundary just past maxWidth
	  last_mc = mc;
	  mc = textnode.firstChild.data.substring(last_mc)
            .search(/. |[-\/]/);
          if ((mc < 0) || (mc + last_mc > rc)) {
            // No more boundaries
            mc = rc;
          } else {
            mc += last_mc + 1;
          }
          //alert(textnode.firstChild.data.substring(lc, rc) + "\n" +
          //      lc + ", " + last_mc + ", " + mc + ", " + rc);
	} while ((mc < rc) &&
		 (textnode.getSubStringLength(lc, mc - lc) <= maxWidth));
	if (last_mc == lc) {
          // One big word bigger than maxWidth, break it in the middle
	  // (I suppose a binary search would be more efficient...)
	  last_mc = mc;
	  while ((last_mc > lc + 1) &&
		 (textnode.getSubStringLength(lc, last_mc - lc) > maxWidth)) {
	    last_mc--;
	  }
	} else if (textnode.getSubStringLength(lc, mc - lc) <= maxWidth) {
          last_mc = mc;
        }
        //alert(textnode.firstChild.data.substring(lc, last_mc) + "(" +
        //      textnode.getSubStringLength(lc, last_mc - lc) + ")");
	tspan = doc.createElement("tspan");
	tspanContent = textnode.firstChild.data.substr(lc, last_mc - lc);
	tspan.appendChild(doc.createTextNode(tspanContent));
	tspan_array.push(tspan);
	lc = textnode.firstChild.data.substring(last_mc).search(/[^ ]/);
	if (lc < 0) {
	  lc = rc;
	} else {
	  lc += last_mc;
	}
      } while (lc < rc);
    }
    lc = rc + 1;
    rc = textnode.firstChild.data.indexOf("\n", lc);
  } while (!done);
  xpos = textnode.getAttribute("x");
  // The following was derived through trial and error and a little
  // numerical analysis.
  if (vAlign == 0) {
    // Align at top
    dy = 0;
    bshift = (lspace*0.75).toString() + "em";
  } else if (vAlign == 2) {
    // Align at bottom
    // Analysis shows the baseline shift may actually be
    //   -0.25*lspace + 0.4em
    // but this seems to work, so I won't change it right now.
    dy = (tspan_array.length - 1) * lspace;
    bshift = (-lspace*0.5).toString() + "ex";
  } else {
    // Align at center
    dy = (tspan_array.length - 1) * 0.5 * lspace;
    bshift = (lspace*0.25).toString() + "em";
  }
  dbgstr = "";
  for (var i in tspan_array) {
    if (tspan_array[i].firstChild.data.search(/\S/) < 0) {
      // Nothing but whitespace, just increment dy (SVG apparently
      // compresses <tspan>s with whitespace)
      dy += -lspace;
    } else {
      tspan_array[i].setAttribute("x", textnode.getAttribute("x"));
      tspan_array[i].setAttribute("dy", dy.toString() + "em");
      tspan_array[i].setAttribute("baseline-shift", bshift);
      textnode.appendChild(tspan_array[i]);
      // Set dy for next <tspan>
      dy = -lspace;
      dbgstr += "'" + tspan_array[i].firstChild.data + "'(" +
        tspan_array[i].getComputedTextLength() + ")\n";
    }
  }
  textnode.removeChild(textnode.firstChild);
  //alert("Leaving wrap_text\n" + dbgstr);
}

/* Playing around... */
function test_js(evt) {
  textnode = evt.getTarget();
  doc = textnode.getOwnerDocument();
  textnode.firstChild.data += "(1)";
  // First line
  tspan = doc.createElement("tspan");
  tspan.setAttribute("x", textnode.getAttribute("x"));
  tspan.setAttribute("dy", "1em");
  tspanContent = textnode.getComputedTextLength().toString();
  tspan.appendChild(doc.createTextNode(tspanContent));
  textnode.appendChild(tspan);
  // Second line
  tspan = doc.createElement("tspan");
  tspan.setAttribute("x", textnode.getAttribute("x"));
  tspan.setAttribute("dy", "1em");
  textBBox = textnode.parentNode.getBBox();
  tspanContent = textBBox.width.toString() + "," + textBBox.height.toString();
  tspan.appendChild(doc.createTextNode(tspanContent));
  textnode.appendChild(tspan);
}

/* Debugging aids */
/* NOTE: these don't work in Mozilla.  I haven't figured out why yet. */
function dbg_msg(s) {
  dbgWindow.document.write(s);
}

function dbg_init() {
  document.write("Test");
  dbgWindow = window.open(
    "","dbgWindow",
    "menubar=yes,scrollbars=yes,status=yes,width=300,height=300");
  dbgWindow.document.write("<head><title>Message window<\/title><\/head>");
}
