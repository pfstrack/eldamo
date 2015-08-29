package xdb.request;

import java.io.StringReader;
import java.util.Collections;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import xdb.dom.XmlParser;
import xdb.http.MockRequest;
import xdb.request.SimpleRequestParser;

public class SimpleRequestParserTest extends TestCase {
    private static final Map<String, String[]> EMPTY = Collections.emptyMap();

    public SimpleRequestParserTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        Element config = parse("<simple-request-parser />").getDocumentElement();
        SimpleRequestParser.init(config);
    }

    /**
     * Test of deriveContentType method, of class SimpleRequestParser.
     */
    public void testDeriveContentType() {
        HttpServletRequest request = new MockRequest("/test.xml", null);
        SimpleRequestParser instance = new SimpleRequestParser(EMPTY);
        String expResult = "xml";
        String result = instance.deriveContentType(request);
        assertEquals(expResult, result);
    }

    public void testDeriveParameters() {
        String[] a = { "a1", "a2" };
        Map<String, String[]> expResult = Collections.singletonMap("a", a);
        HttpServletRequest request = new MockRequest("/test.xml", expResult);
        SimpleRequestParser instance = new SimpleRequestParser(EMPTY);
        Map<String, String[]> result = instance.deriveParameters(request);
        assertEquals(expResult.get("a"), result.get("a"));
    }

    public void testExtraParameters() {
        String[] extras = { "a1", "a2" };
        String[] a = { "a1", "a2" };
        Map<String, String[]> expResult = Collections.singletonMap("a", a);
        Map<String, String[]> extraParams = Collections.singletonMap("extra", extras);
        HttpServletRequest request = new MockRequest("/test.xml", expResult);
        SimpleRequestParser instance = new SimpleRequestParser(extraParams);
        Map<String, String[]> result = instance.deriveParameters(request);
        assertEquals(a, result.get("a"));
        assertEquals(extras, result.get("extra"));
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
