package com.ora.xsltckbk;
import com.icl.saxon.style.ExtensionElementFactory;
import org.xml.sax.SAXException;

/**
  * Class CkBkElementFactory. <br>
  * A "Factory" for XSLT Cookbook extension nodes in the stylesheet tree. <br>
  */

public class CkBkElementFactory implements ExtensionElementFactory {

	public CkBkElementFactory() {
	}

    /**
    * Identify the class to be used for stylesheet elements with a given local name.
    * The returned class must extend com.icl.saxon.style.StyleElement
    * @return null if the local name is not a recognised element type in this
    * namespace.
    */

    public Class getExtensionClass(String localname)  {
        if (localname.equals("set-context")) return CkBkSetContext.class;
        if (localname.equals("templtext")) return CkBkTemplText.class;
        return null;
    }

}

