package xdb.dom.impl;

import java.io.StringReader;
import java.util.List;
import junit.framework.TestCase;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import xdb.config.ModelConfigManagerTest;
import xdb.dom.XmlParser;
import xdb.dom.impl.DocumentImpl;

public class DocumentImplTest extends TestCase {

    public DocumentImplTest(String testName) {
        super(testName);
    }

    public void testGetCanonicalName() throws Exception {
        String xml = "<xml />";
        DocumentImpl instance = parse(xml);
        String name = instance.getCanonicalName("xml");
        Element element = instance.getDocumentElement();
        assertTrue(name == element.getNodeName());
    }

    public void testBuildIndex() throws Exception {
        ModelConfigManagerTest.init();
        String xml = "<x><product id='1' uuid='aaa'>x</product><product id='2' uuid='bbb'>y</product><product id='3' uuid='aaa'>z</product></x>";
        DocumentImpl instance = parse(xml);
        instance.buildIndex();
    }

    public void testGetElementsFromKey() throws Exception {
        ModelConfigManagerTest.init();
        String xml = "<x><product id='1' uuid='aaa'>x</product><product id='2' uuid='bbb'>y</product><product id='3' uuid='aaa'>z</product></x>";
        DocumentImpl instance = parse(xml);
        instance.buildIndex();
        List<Node> list = instance.getElementsFromKey("uuid", "aaa");
        assertEquals(2, list.size());
    }

    public void testParentKey() throws Exception {
        ModelConfigManagerTest.init();
        String xml = "<x><product id='1'><children><part-ref idref='2'/></children></product><part id='2' /></x>";
        DocumentImpl instance = parse(xml);
        instance.buildIndex();
        List<Node> list = instance.getElementsFromKey("parent", "2");
        assertEquals(1, list.size());
    }

    public void testParentWithEmbeddedChild() throws Exception {
        ModelConfigManagerTest.init();
        String xml = "<x><category id='1'><children><product id='2'/></children></category></x>";
        DocumentImpl instance = parse(xml);
        instance.buildIndex();
        List<Node> list = instance.getElementsFromKey("parent", "2");
        assertEquals(1, list.size());
    }

    public static DocumentImpl parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return (DocumentImpl) new XmlParser().parse(is);
    }
}
