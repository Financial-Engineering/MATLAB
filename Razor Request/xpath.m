function nodes = xpath(xml, path)
 
    import java.io.StringReader;
    import javax.xml.parsers.DocumentBuilder;
    import javax.xml.parsers.DocumentBuilderFactory;
    import javax.xml.xpath.XPath;
    import javax.xml.xpath.XPathConstants;
    import javax.xml.xpath.XPathExpression;
    import javax.xml.xpath.XPathFactory;

    import org.w3c.dom.Document;
    import org.w3c.dom.NodeList;
    import org.xml.sax.InputSource;
    
    domFactory = DocumentBuilderFactory.newInstance();
    domFactory.setNamespaceAware(true); 
    builder = domFactory.newDocumentBuilder();

    doc = builder.parse(InputSource(StringReader(xml)));

    xpath = XPathFactory.newInstance().newXPath();

    expr = xpath.compile(path);

    nodes = expr.evaluate(doc, XPathConstants.NODESET);

end

