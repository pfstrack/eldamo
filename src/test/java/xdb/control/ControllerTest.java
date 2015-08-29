/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package xdb.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import xdb.control.Controller;
import xdb.control.Query;
import xdb.control.Renderer;
import xdb.control.RequestParser;
import xdb.dom.XmlParser;
import xdb.http.MockRequest;
import xdb.query.WholeDocQuery;
import xdb.request.SimpleRequestParser;

/**
 * 
 * @author ps142237
 */
public class ControllerTest extends TestCase {

    public static final String DESCRIPTION = "Description";

    RequestParser requestParser = new SimpleRequestParser(new HashMap<String, String[]>());
    Query query = new WholeDocQuery();
    Controller instance;

    public ControllerTest(String testName) {
        super(testName);
    }

    @Override
    protected void setUp() throws Exception {
        Renderer xmlRenderer = new Renderer() {

            public String getMimeType() {
                return "xml";
            }

            public void render(List<Node> results, PrintWriter out, Map<String, String[]> params)
                throws IOException {
                out.print("<result/>");
            }
        };
        Renderer aboutRenderer = new Renderer() {

            public String getMimeType() {
                return "html";
            }

            public void render(List<Node> results, PrintWriter out, Map<String, String[]> params)
                throws IOException {
                out.print("About");
            }
        };
        Map<String, Renderer> renderers = new HashMap<String, Renderer>();
        renderers.put("xml", xmlRenderer);
        renderers.put("about", aboutRenderer);
        instance = new Controller(DESCRIPTION, requestParser, query, renderers);
    }

    public void testGetDescription() {
        String result = instance.getDescription();
        assertEquals(DESCRIPTION, result);
    }

    public void testGetMimeType() {
        HttpServletRequest request = new MockRequest("test.xml", null);
        String expResult = "xml";
        String result = instance.getMimeType(request);
        assertEquals(expResult, result);
    }

    public void testGetUnknownMimeType() {
        HttpServletRequest request = new MockRequest("test.unknown", null);
        String expResult = "html";
        String result = instance.getMimeType(request);
        assertEquals(expResult, result);
    }

    public void testProcessUnknownExtenstion() throws Exception {
        Document doc = parse("<xml/>");
        HttpServletRequest request = new MockRequest("test.unknown", new HashMap<String, String[]>());
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        instance.process(doc, request, out);
        assertEquals("About", sw.toString());
    }

    public void testProcess() throws Exception {
        Document doc = parse("<xml/>");
        HttpServletRequest request = new MockRequest("test.xml", new HashMap<String, String[]>());
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        instance.process(doc, request, out);
        assertEquals("<result/>", sw.toString());
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
