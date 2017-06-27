package com.ora.xsltckbk;
import java.util.Vector ;
import java.util.Enumeration ;
import com.icl.saxon.tree.AttributeCollection;
import com.icl.saxon.*;
import com.icl.saxon.expr.*;
import javax.xml.transform.*;
import com.icl.saxon.output.*;
import com.icl.saxon.trace.TraceListener;
import com.icl.saxon.om.NodeInfo;
import com.icl.saxon.om.NodeEnumeration;
import com.icl.saxon.style.StyleElement;
import com.icl.saxon.style.StandardNames;
import com.icl.saxon.tree.AttributeCollection;
import com.icl.saxon.tree.NodeImpl;

/**
* Handler for XSLT Cookbook templtext elements in stylesheet.<BR>
*/

public class CkBkTemplText extends com.icl.saxon.style.StyleElement
{
  private static final int SCANNING_STATE = 0 ;
  private static final int FOUND1_STATE   = 1 ;
  private static final int EXPR_STATE     = 2 ;
  private static final int FOUND2_STATE   = 3 ;
  private static final int DELIMIT_STATE  = 4 ;

  private class CkBkTemplParam
  {
    public CkBkTemplParam(String prefix)
    {
      m_prefix = prefix ;
    }

    public void process(Context context) throws TransformerException
    {
      if (!m_prefix.equals(""))
      {
          Outputter out = context.getOutputter();
          out.setEscaping(false);
          out.writeContent(m_prefix);
          out.setEscaping(true);
      }
    }


    protected String m_prefix ;
  }

  private class CkBkValueTemplParam extends CkBkTemplParam
  {
    public CkBkValueTemplParam(String prefix, Expression value)
    {
      super(prefix) ;
      m_value = value ;
    }

    public void process(Context context) throws TransformerException
    {
      super.process(context) ;
      Outputter out = context.getOutputter();
      out.setEscaping(false);
      if (m_value != null)
      {
          m_value.outputStringValue(out, context);
      }
      out.setEscaping(true);
    }

    private Expression m_value ;

  }

  private class CkBkListTemplParam extends CkBkTemplParam
  {
    public CkBkListTemplParam(String prefix, Expression list,
                              Expression delimit)
    {
      super(prefix) ;
      m_list = list ;
      m_delimit = delimit ;
    }

    public void process(Context context) throws TransformerException
    {
      super.process(context) ;
      if (m_list != null)
      {
        NodeEnumeration m_listEnum = m_list.enumerate(context, false);

        Outputter out = context.getOutputter();
        out.setEscaping(false);
        while(m_listEnum.hasMoreElements())
        {
          NodeInfo node = m_listEnum.nextElement();
          if (node != null)
          {
            node.copyStringValue(out);
          }
          if (m_listEnum.hasMoreElements() && m_delimit != null)
          {
            m_delimit.outputStringValue(out, context);
          }
        }
        out.setEscaping(true);
      }
    }

    private Expression m_list ;
    private Expression m_delimit ;
  }

    /**
    * Determine whether this node is an instruction.
    * @return true - it is an instruction
    */

    public boolean isInstruction()
    {
        return true;
    }

    /**
    * Determine whether this type of element is allowed to contain a template-body
    * @return true: yes, it may contain a template-body
    */

    public boolean mayContainTemplateBody()
    {
        return true;
    }

    public void prepareAttributes() throws TransformerConfigurationException
    {
 		  StandardNames sn = getStandardNames();
		  AttributeCollection atts = getAttributeList();
		  for (int a=0; a<atts.getLength(); a++)
      {
			  int nc = atts.getNameCode(a);
     		checkUnknownAttribute(nc);
      }
    }

    public void validate() throws TransformerConfigurationException
    {
        checkWithinTemplate();
        NodeImpl node = (NodeImpl)getFirstChild();
        String value ;
        if (node==null)
        {
            value = "";
        }
        else
        {
            value = node.getStringValue();
            while (node!=null)
            {
                if (node.getNodeType()==NodeInfo.ELEMENT)
                {
                    compileError("ckbk:templtext must not have any child elements");
                }
                node = (NodeImpl)node.getNextSibling();
            }
        }

        m_TemplParms = new Vector() ;
        //This state machine parses the text looking for parameters
        int ii = 0 ;
        int len = value.length() ;

        int state = SCANNING_STATE ;
        StringBuffer temp = new StringBuffer("") ;
        StringBuffer expr = new StringBuffer("") ;
        while(ii < len)
        {
          char c = value.charAt(ii++) ;
          switch (state)
          {
            case SCANNING_STATE:
            {
              if (c == '\\')
              {
                state = FOUND1_STATE ;
              }
              else
              {
                temp.append(c) ;
              }
            }
            break ;

            case FOUND1_STATE:
            {
              if (c == '\\')
              {
                temp.append(c) ;
                state = SCANNING_STATE ;
              }
              else
              {
                expr.append(c) ;
                state = EXPR_STATE ;
              }
            }
            break ;

            case EXPR_STATE:
            {
              if (c == '\\')
              {
                state = FOUND2_STATE ;
              }
              else
              {
                expr.append(c) ;
              }
            }
            break ;

            case FOUND2_STATE:
            {
              if (c == '\\')
              {
                state = EXPR_STATE ;
                expr.append(c) ;
              }
              else
              {
                processParam(temp, expr) ;
                state = SCANNING_STATE ;
                temp = new StringBuffer("") ;
				temp.append(c) ;
                expr = new StringBuffer("") ;
              }
            }
            break ;
          }
		}

        if (state == FOUND1_STATE || state == EXPR_STATE)
        {
            compileError("ckbk:templtext dangling \\");
        }
        else
        if (state == FOUND2_STATE)
        {
          processParam(temp, expr) ;
        }
        else
        {
          processParam(temp, new StringBuffer("")) ;
        }
    }

    public void process(Context context) throws TransformerException
    {
      Enumeration iter = m_TemplParms.elements() ;
      while (iter.hasMoreElements())
      {
         CkBkTemplParam param = (CkBkTemplParam) iter.nextElement() ;
         param.process(context) ;
      }
    }

    private void processParam(StringBuffer prefix, StringBuffer expr)
    {
      if (expr.length() == 0)
      {
        m_TemplParms.addElement(new CkBkTemplParam(new String(prefix))) ;
      }
      else
      {
        processParamExpr(prefix, expr) ;
      }
    }

    private void processParamExpr(StringBuffer prefix, StringBuffer expr)
    {
        int ii = 0 ;
        int len = expr.length() ;

        int state = SCANNING_STATE ;
        StringBuffer list = new StringBuffer("") ;
        StringBuffer delimit = new StringBuffer("") ;
        while(ii < len)
        {
          char c = expr.charAt(ii++) ;
          switch (state)
          {
            case SCANNING_STATE:
            {
              if (c == '%')
              {
                state = FOUND1_STATE ;
              }
              else
              {
                list.append(c) ;
              }
            }
            break ;

            case FOUND1_STATE:
            {
              if (c == '%')
              {
                list.append(c) ;
                state = SCANNING_STATE ;
              }
              else
              {
                delimit.append(c) ;
                state = DELIMIT_STATE ;
              }
            }
            break ;

            case DELIMIT_STATE:
            {
              if (c == '%')
              {
                state = FOUND2_STATE ;
              }
              else
              {
                delimit.append(c) ;
              }
            }
            break ;
          }
        }
        try
        {
          if (state == FOUND1_STATE)
          {
              compileError("ckbk:templtext trailing %");
          }
          else
          if (state == FOUND2_STATE)
          {
              compileError("ckbk:templtext extra %");
          }
          else
          if (state == SCANNING_STATE)
          {
            String prefixStr = new String(prefix) ;
            Expression value = makeExpression(new String(list)) ;
            m_TemplParms.addElement(new CkBkValueTemplParam(prefixStr, value)) ;
          }
          else
          {
            String prefixStr = new String(prefix) ;
            Expression listExpr = makeExpression(new String(list)) ;
            Expression delimitExpr = makeExpression(new String(delimit)) ;
            m_TemplParms.addElement(
              new CkBkListTemplParam(prefixStr, listExpr, delimitExpr)) ;
          }
        }
        catch(Exception e)
        {
        }
    }
    //A vector of CBkTemplParms parse form text
    private Vector m_TemplParms ;
 }


