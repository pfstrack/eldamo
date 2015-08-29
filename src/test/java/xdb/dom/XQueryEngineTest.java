package xdb.dom;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import junit.framework.TestCase;
import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.om.NodeInfo;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import xdb.config.ModelConfigManagerTest;
import xdb.dom.XQueryEngine;
import xdb.dom.XmlParser;
import xdb.dom.impl.DocumentImpl;
import xdb.util.XmlUtil;

public class XQueryEngineTest extends TestCase {

    public XQueryEngineTest(String testName) {
        super(testName);
    }

    public void testQuery() throws Exception {
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Document doc = parse(xml);
        Map<String, String> params = Collections.singletonMap("id", "2");
        TestWriter writer = new TestWriter();
        XQueryEngine.query(doc, "declare variable $id external; /x/a[@id=$id]", params, writer,
            "xml");
        assertEquals("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<a id=\"2\">y</a>",
            writer.toString());
    }

    public void testStaticFunctions() throws Exception {
        String declaration = "declare namespace test=\"java:" + getClass().getName() + "\";";
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Document doc = parse(xml);
        Map<String, String> params = Collections.singletonMap("id", "2");
        TestWriter writer = new TestWriter();
        XQueryEngine.query(doc, declaration + " test:functionTest('X')", params, writer, "text");
        assertEquals("x", writer.toString());
    }

    public static String functionTest(String value) {
        return value.toLowerCase();
    }

    public void testStaticElementFunctions() throws Exception {
        String declaration = "declare namespace test=\"java:" + getClass().getName() + "\";";
        String xml = "<x test='The Test' />";
        Document doc = parse(xml);
        Map<String, String> params = Collections.singletonMap("id", "2");
        TestWriter writer = new TestWriter();
        XQueryEngine.query(doc, declaration + " test:elementFunctionTest(/x)", params, writer,
            "text");
        assertEquals("The Test", writer.toString());
    }

    public static String elementFunctionTest(Element element) {
        if (element instanceof NodeOverNodeInfo) {
            NodeOverNodeInfo wrapper = (NodeOverNodeInfo) element;
            element = (Element) wrapper.getUnderlyingNodeInfo();
        }
        return element.getAttribute("test");
    }

    public void testStaticNodeReturnTest() throws Exception {
        String declaration = "declare namespace test=\"java:" + getClass().getName() + "\";";
        String xml = "<x><a/><a/><a/></x>";
        Document doc = parse(xml);
        Map<String, String> params = Collections.singletonMap("id", "2");
        TestWriter writer = new TestWriter();
        XQueryEngine.query(doc, declaration + " count(test:nodeReturnTest(/x))", params, writer,
            "text");
        assertEquals("3", writer.toString());
    }

    public static List<NodeInfo> nodeReturnTest(Element element) {
        if (element instanceof NodeOverNodeInfo) {
            NodeOverNodeInfo wrapper = (NodeOverNodeInfo) element;
            element = (Element) wrapper.getUnderlyingNodeInfo();
        }
        List<Element> children = XmlUtil.getChildElements(element, "a");
        List<NodeInfo> result = new ArrayList<NodeInfo>(children.size());
        for (Element child : children) {
            result.add((NodeInfo) child);
        }
        return result;
    }

    public void testExternalNamespaceResolver() throws Exception {
        Document doc = parseFromFile("sample-data.xml");
        if (!(doc instanceof DocumentImpl)) {
            return;
        }

        DocumentImpl docImpl = (DocumentImpl) doc;
        ModelConfigManagerTest.init();
        docImpl.buildIndex();
        Map<String, String> params = Collections.emptyMap();
        TestWriter writer = new TestWriter();
        XQueryEngine.query(doc,
            "string(xdb:key(/., 'uuid', '9b06d70f-9fd5-11dd-a2a2-080020a9ed93')/@name)", params,
            writer, "text");
        assertEquals("Sun Blade 6000 Virtualized Multi-Fabric 10GbE Network Express Module",
            writer.toString());
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }

    public Document parseFromFile(String file) throws Exception {
        InputStream in = getClass().getResourceAsStream(file);
        InputSource is = new InputSource(in);
        return new XmlParser().parse(is);
    }

    public static class TestWriter extends Writer {
        private StringBuffer buffer = new StringBuffer();

        @Override
        public String toString() {
            return buffer.toString();
        }

        @Override
        public void write(char[] arg0, int arg1, int arg2) throws IOException {
            buffer.append(arg0, arg1, arg2);
        }

        @Override
        public void flush() throws IOException {
            // No op
        }

        @Override
        public void close() throws IOException {
            // No op
        }
    }
}
