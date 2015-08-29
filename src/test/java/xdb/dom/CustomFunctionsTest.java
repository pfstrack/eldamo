/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xdb.dom;

import java.io.IOException;
import java.io.InputStream;
import java.io.Writer;
import java.util.Collections;
import java.util.Map;

import javax.xml.xpath.XPathExpressionException;

import junit.framework.TestCase;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import xdb.config.ModelConfigManagerTest;
import xdb.dom.impl.DocumentImpl;

/**
 * 
 * @author ps142237
 */
public class CustomFunctionsTest extends TestCase {

    public CustomFunctionsTest(String testName) {
        super(testName);
    }

    public void testKey() throws Exception {
        Document doc = initTestDoc();
        Map<String, String> params = Collections.emptyMap();
        TestWriter writer = new TestWriter();
        XQueryEngine.query(doc,
            "string(xdb:key(/., 'uuid', '9b06d70f-9fd5-11dd-a2a2-080020a9ed93')/@name)", params,
            writer, "text");
        assertEquals("Sun Blade 6000 Virtualized Multi-Fabric 10GbE Network Express Module",
            writer.toString());
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

    private Document initTestDoc() throws Exception, XPathExpressionException {
        Document doc = parseFromFile("sample-data.xml");
        DocumentImpl docImpl = (DocumentImpl) doc;
        ModelConfigManagerTest.init();
        docImpl.buildIndex();
        return doc;
    }
}
