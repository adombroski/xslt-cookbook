import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;

public class Transform
{

  public static void main(String[] args) throws Exception
  {
    if (args.length != 2)
    {
      System.err.println(
        "Usage: java Transform [xmlfile] [xsltfile]");
      System.exit(1);
    }

    //Open the source and style sheet files
    File xmlFile = new File(args[0]);
    File xsltFile = new File(args[1]);

    //JAXP uses a Source interface to read data
    Source xmlSource = new StreamSource(xmlFile);
    Source xsltSource = new StreamSource(xsltFile);

    //Factory classes allow the specific XSLT processor
    //to be hidden from the application by returning a
    //standard Transformer interface
    TransformerFactory transFact =
      TransformerFactory.newInstance();
    Transformer trans = transFact.newTransformer(xsltSource);

    //Applies the stylesheet to the source document
    trans.transform(xmlSource, new StreamResult(System.out));
 }
}

