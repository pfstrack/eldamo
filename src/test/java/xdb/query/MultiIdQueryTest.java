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
import xdb.query.MultiIdQuery;
import xdb.query.QueryInit;

public class MultiIdQueryTest extends TestCase {

    public MultiIdQueryTest(String testName) {
        super(testName);
    }

    /**
     * Test of init method, of class MultiIdQuery.
     */
    public void testInit() throws Exception {
        String xml = "<multi-id-query entity-type=\"part\" />";
        Element config = parse(xml).getDocumentElement();
        Query instance = QueryInit.init(config, "test-config.xml");
        assertTrue(instance instanceof MultiIdQuery);
    }

    /**
     * Test of query method, of class MultiIdQuery.
     */
    public void testQuery() throws Exception {
        String xml = "<x><a id='1'/><a id='2'/><a id='3'/><b id='4'/><b id='5'/></x>";
        Document doc = parse(xml);
        String[] array = { "1", "3", "5", "7" };
        Map<String, String[]> params = Collections.singletonMap("id", array);
        MultiIdQuery instance = new MultiIdQuery("a");
        List<Node> result = instance.query(doc, params);
        assertEquals(2, result.size());

        NodeList nodeList = doc.getDocumentElement().getChildNodes();
        List<Node> expResult = new LinkedList<Node>();
        expResult.add(nodeList.item(0));
        expResult.add(nodeList.item(2));
        assertEquals(expResult, result);
    }

    /**
     * Test of query method, of class MultiIdQuery.
     */
    public void testQueryWithoutEntityType() throws Exception {
        String configXml = "<multi-id-query />";
        Element config = parse(configXml).getDocumentElement();
        MultiIdQuery instance = MultiIdQuery.init(config);

        String xml = "<x><a id='1'/><a id='2'/><a id='3'/><b id='4'/><b id='5'/></x>";
        Document doc = parse(xml);
        String[] array = { "1", "3", "5", "7" };
        Map<String, String[]> params = Collections.singletonMap("id", array);
        List<Node> result = instance.query(doc, params);
        assertEquals(3, result.size());

        NodeList nodeList = doc.getDocumentElement().getChildNodes();
        List<Node> expResult = new LinkedList<Node>();
        expResult.add(nodeList.item(0));
        expResult.add(nodeList.item(2));
        expResult.add(nodeList.item(4));
        assertEquals(expResult, result);
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
