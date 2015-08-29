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
import xdb.request.UriTemplateParser;

public class UriTemplateParserTest extends TestCase {

    public UriTemplateParserTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        Element config = parse(
            "<uri-template-parser template='part-translations-{locale}.{content-type}' />")
            .getDocumentElement();
        UriTemplateParser.init(config);
    }

    public void testDeriveContentType() {
        Map<String, String[]> emptyMap = Collections.emptyMap();
        String template = "part-translations-{locale}.{content-type}";
        UriTemplateParser instance = new UriTemplateParser(template, emptyMap);

        HttpServletRequest request = new MockRequest("/part-translations-fr.csv", emptyMap);
        assertEquals("csv", instance.deriveContentType(request));
    }

    public void testDeriveAboutContentType() {
        Map<String, String[]> emptyMap = Collections.emptyMap();
        String template = "part-translations-{locale}.{content-type}";
        UriTemplateParser instance = new UriTemplateParser(template, emptyMap);

        HttpServletRequest request = new MockRequest("/about", emptyMap);
        assertEquals("about", instance.deriveContentType(request));
    }

    public void testDeriveParameters() {
        Map<String, String[]> emptyMap = Collections.emptyMap();
        String template = "part-translations-{locale}.{content-type}";
        UriTemplateParser instance = new UriTemplateParser(template, emptyMap);

        HttpServletRequest request = new MockRequest("/part-translations-fr.csv", emptyMap);
        Map<String, String[]> result = instance.deriveParameters(request);
        assertEquals("csv", result.get("content-type")[0]);
        assertEquals("fr", result.get("locale")[0]);
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
