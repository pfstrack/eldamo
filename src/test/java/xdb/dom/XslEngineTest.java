package xdb.dom;

import java.io.IOException;
import java.io.StringReader;
import java.io.Writer;
import java.util.Collections;
import java.util.Map;

import junit.framework.TestCase;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class XslEngineTest extends TestCase {

    public XslEngineTest(String testName) {
        super(testName);
    }

    public void testQuery() throws Exception {
        String xml = "<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>";
        Document doc = parse(xml);
        Map<String, String> params = Collections.singletonMap("id", "2");
        TestWriter writer = new TestWriter();
        String xsl = "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'/>";
        XslEngine.query(doc, xsl, params, writer, "xml");
        writer.close();
        assertEquals("<?xml version=\"1.0\" encoding=\"UTF-8\"?>xyz", writer.toString());
    }
    private static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
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
