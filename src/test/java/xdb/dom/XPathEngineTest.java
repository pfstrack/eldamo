package xdb.dom;

import java.io.StringReader;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import org.w3c.dom.Document;
import junit.framework.TestCase;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import xdb.config.ModelConfigManagerTest;
import xdb.dom.XPathEngine;
import xdb.dom.XmlParser;
import xdb.dom.impl.DocumentImpl;

public class XPathEngineTest extends TestCase {

    public XPathEngineTest(String testName) {
        super(testName);
    }

    public void testQuery() throws Exception {
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Document doc = parse(xml);
        Map<String, String> params = Collections.singletonMap("id", "2");
        List<Node> result = XPathEngine.query(doc, "x/a[@id=$id]", params);
        assertEquals(1, result.size());
    }

    public void testFollowingSibling() throws Exception {
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Document doc = parse(xml);
        List<Node> result = XPathEngine.query(doc, "x/a[@id='2']/following-sibling::a", null);
        Element element = (Element) result.get(0);
        assertEquals("3", element.getAttribute("id"));
    }

    public void testStringQuery() throws Exception {
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Node context = parse(xml);
        String path = "count(//a)";
        Map<String, String> params = Collections.emptyMap();
        String expResult = "3";
        String result = XPathEngine.stringQuery(context, path, params);
        assertEquals(expResult, result);
    }

    public void testGetParametrizedXPath() throws Exception {
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Node context = parse(xml);
        String path = "id($id)/text()";
        Map<String, String> params = new HashMap<String, String>();
        XPathExpression expr = XPathEngine.getParametrizedXPath(path, params);
        params.put("id", "1");
        assertEquals("x", expr.evaluate(context, XPathConstants.STRING));
        params.put("id", "3");
        assertEquals("z", expr.evaluate(context, XPathConstants.STRING));
    }

    public void testXdbKeyFunction() throws Exception {
        ModelConfigManagerTest.init();
        String xml = "<x><product id='1' uuid='aaa'>x</product><product id='2' uuid='bbb'>y</product><product id='3' uuid='aaa'>z</product></x>";
        DocumentImpl context = (DocumentImpl) parse(xml);
        context.buildIndex();
        String path = "xdb:key(., 'uuid', 'aaa')";
        Map<String, String> params = new HashMap<String, String>();
        List<Node> list = XPathEngine.query(context, path, params);
        assertEquals(list.size(), 2);
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
