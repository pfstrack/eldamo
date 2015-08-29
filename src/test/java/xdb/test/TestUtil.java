package xdb.test;

import java.io.StringReader;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import xdb.dom.XmlParser;

public class TestUtil {

    public static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
