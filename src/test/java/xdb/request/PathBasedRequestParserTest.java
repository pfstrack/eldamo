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
import xdb.request.PathBasedRequestParser;
import xdb.request.UriTemplateParser;

public class PathBasedRequestParserTest extends TestCase {

    public PathBasedRequestParserTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        Element config = parse(
            "<path-based-request-parser pattern='{content-type}/{channel}/{locale}/{price-list}/{id}' />")
            .getDocumentElement();
        UriTemplateParser.init(config);
    }

    public void testDeriveContentType() {
        Map<String, String[]> emptyMap = Collections.emptyMap();
        String pattern = "{content-type}/{channel}/{locale}/{price-list}/{id}";
        PathBasedRequestParser instance = new PathBasedRequestParser(pattern, emptyMap);

        HttpServletRequest request = new MockRequest(
            "/query/adhoc/purl/item/xml/st/en/HARDWARE AND SYSTEM SOFTWARE CURRENT COMMERCIAL/X311L",
            emptyMap);
        assertEquals("xml", instance.deriveContentType(request));
    }

    public void testDeriveParameters() {
        Map<String, String[]> emptyMap = Collections.emptyMap();
        String pattern = "{content-type}/{channel}/{locale}/{price-list}/{id}";
        PathBasedRequestParser instance = new PathBasedRequestParser(pattern, emptyMap);

        HttpServletRequest request = new MockRequest(
            "/query/adhoc/purl/item/xml/st/en/HARDWARE AND SYSTEM SOFTWARE CURRENT COMMERCIAL/X311L",
            emptyMap);
        Map<String, String[]> parameters = instance.deriveParameters(request);
        assertEquals("X311L", parameters.get("id")[0]);
        assertEquals("HARDWARE AND SYSTEM SOFTWARE CURRENT COMMERCIAL",
            parameters.get("price-list")[0]);
        assertEquals("en", parameters.get("locale")[0]);
        assertEquals("st", parameters.get("channel")[0]);
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
