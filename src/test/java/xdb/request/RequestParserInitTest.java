package xdb.request;

import java.io.StringReader;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import xdb.control.RequestParser;
import xdb.dom.XmlParser;
import xdb.request.RequestParserInit;
import xdb.request.SimpleRequestParser;

public class RequestParserInitTest extends TestCase {

    public RequestParserInitTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        String xml = "<simple-request-parser />";
        Element config = parse(xml).getDocumentElement();
        String fileName = "config.xml";
        RequestParser result = RequestParserInit.init(config, fileName);
        assertTrue(result instanceof SimpleRequestParser);
    }

    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
