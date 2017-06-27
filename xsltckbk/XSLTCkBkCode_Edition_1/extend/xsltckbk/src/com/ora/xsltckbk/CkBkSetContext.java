package com.ora.xsltckbk;
import com.icl.saxon.tree.AttributeCollection;
import com.icl.saxon.*;
import com.icl.saxon.expr.*;
import javax.xml.transform.*;

import com.icl.saxon.trace.TraceListener;
import com.icl.saxon.om.NodeInfo;
import com.icl.saxon.om.NodeEnumeration;
import com.icl.saxon.style.StyleElement;
import com.icl.saxon.style.StandardNames;
/**
* Handler for XSLT Cookbook set-context elements in stylesheet.<BR>
*/

public class CkBkSetContext extends com.icl.saxon.style.StyleElement {

    Expression select = null;

    /**
    * Determine whether this node is an instruction.
    * @return true - it is an instruction
    */

    public boolean isInstruction() {
        return true;
    }

    /**
    * Determine whether this type of element is allowed to contain a template-body
    * @return true: yes, it may contain a template-body
    */

    public boolean mayContainTemplateBody() {
        return true;
    }

    public void prepareAttributes() throws TransformerConfigurationException {

		StandardNames sn = getStandardNames();
		AttributeCollection atts = getAttributeList();

		String selectAtt = null;

		for (int a=0; a<atts.getLength(); a++) {
			int nc = atts.getNameCode(a);
			int f = nc & 0xfffff;
			if (f==sn.SELECT) {
        		selectAtt = atts.getValue(a);
        	} else {
        		checkUnknownAttribute(nc);
        	}
        }

        if (selectAtt==null) {
            reportAbsence("select");
        } else {
            select = makeExpression(selectAtt);
        }

    }

    public void validate() throws TransformerConfigurationException {
        checkWithinTemplate();
    }

    public void process(Context context) throws TransformerException
    {
        NodeEnumeration selection = select.enumerate(context, false);
        if (!(selection instanceof LastPositionFinder)) {
            selection = new LookaheadEnumerator(selection);
        }

        Context c = context.newContext();
        c.setLastPositionFinder((LastPositionFinder)selection);
        int position = 1;

        if (context.getController().isTracing()) {
            TraceListener listener = context.getController().getTraceListener();
            if(selection.hasMoreElements()) {
                NodeInfo node = selection.nextElement();
                c.setPosition(position++);
                c.setCurrentNode(node);
                c.setContextNode(node);
                listener.enterSource(null, c);
                processChildren(c);
                listener.leaveSource(null, c);
                context.setReturnValue(c.getReturnValue());
            }
        } else {
            if (selection.hasMoreElements()) {
                NodeInfo node = selection.nextElement();
                c.setPosition(position++);
                c.setCurrentNode(node);
                c.setContextNode(node);
                processChildren(c);
                context.setReturnValue(c.getReturnValue());
            }
        }
    }
}
