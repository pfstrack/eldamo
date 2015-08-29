package xdb.query;

import java.io.StringReader;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import xdb.control.Query;
import xdb.dom.XmlParser;
import xdb.query.QueryInit;
import xdb.query.XPathQuery;

public class XPathQueryTest extends TestCase {

    public XPathQueryTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        String xml = "<xpath-query xpath=\"id($id)\" />";
        Element config = parse(xml).getDocumentElement();
        Query instance = QueryInit.init(config, "test-config.xml");
        assertTrue(instance instanceof XPathQuery);
    }

    public void testQuery() throws Exception {
        String xml = "<x><a id='1'/><a id='2'/><a id='3'/><b id='4'/><b id='5'/></x>";
        Document doc = parse(xml);
        XPathQuery instance = new XPathQuery("id($id)");

        String[] array = { "3" };
        Map<String, String[]> params = Collections.singletonMap("id", array);
        List<Node> result = instance.query(doc, params);
        NodeList nodeList = doc.getDocumentElement().getChildNodes();
        List<Node> expResult = new LinkedList<Node>();
        expResult.add(nodeList.item(2));
        assertEquals(expResult, result);
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
