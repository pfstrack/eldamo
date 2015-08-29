/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xdb.util;

import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.xml.sax.InputSource;

import xdb.dom.XmlParser;
import xdb.util.XmlUtil;

/**
 * 
 * @author ps142237
 */
public class XmlUtilTest extends TestCase {

    public XmlUtilTest(String testName) {
        super(testName);
    }

    public void testParseXmlDateTimeWithZone() throws Exception {
        String timestamp = "2009-05-21T14:52:18-07:00";
        Date result = XmlUtil.parseXmlDateTimeWithZone(timestamp);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        String formatted = formatter.format(result);
        assertEquals("2009-05-21T14:52:18-0700", formatted);
    }

    public void testFormatXmlDateTimeWithZone() throws Exception {
        String timestamp = "2009-05-21T14:52:18.000-07:00";
        Date result = XmlUtil.parseXmlDateTimeWithZone(timestamp);
        String formatted = XmlUtil.formatXmlDateTimeWithZone(result);
        assertEquals(timestamp, formatted);
    }

    public void testGetChildElement() throws Exception {
        String xml = "<test><child1/><child2/></test>";
        Document doc = parse(xml);
        Element element = doc.getDocumentElement();
        Element result = XmlUtil.getChildElement(element, "child2");
        assertEquals("child2", result.getNodeName());
    }

    public void testGetChildElements() throws Exception {
        String xml = "<test><child1/><child2/><child2/></test>";
        Document doc = parse(xml);
        Element element = doc.getDocumentElement();
        List<Element> result = XmlUtil.getChildElements(element, "child2");
        assertEquals(2, result.size());
    }

    public void testWriteXmlHeader() {
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        XmlUtil.writeXmlHeader(out);
        assertEquals("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", sw.toString());
    }

    public void testWriteOpenElement() throws Exception {
        String xml = "<test att1='1' att2='1' />";
        Document doc = parse(xml);
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        String element = "test";
        NamedNodeMap attributes = doc.getDocumentElement().getAttributes();
        XmlUtil.writeOpenElement(out, element, attributes);
        assertEquals("<test att1=\"1\" att2=\"1\">", sw.toString());
    }

    public void testWriteCloseElement() {
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        String element = "test";
        XmlUtil.writeCloseElement(out, element);
        assertEquals("</test>", sw.toString());
    }

    public void testWriteAttribute() {
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        String name = "att";
        String value = "value&'";
        XmlUtil.writeAttribute(out, name, value);
        assertEquals(" att=\"value&amp;&apos;\"", sw.toString());
    }

    public void testWriteCharacters() {
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        String value = "value &'\"<>";
        XmlUtil.writeCharacters(out, value);
        assertEquals("value &amp;&apos;&quot;&lt;&gt;", sw.toString());
    }

    public void testWriteOpenElementFragment() throws Exception {
        String xml = "<test att1='1' att2='1' />";
        Document doc = parse(xml);
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        String element = "test";
        NamedNodeMap attributes = doc.getDocumentElement().getAttributes();
        XmlUtil.writeOpenElementFragment(out, element, attributes);
        assertEquals("<test att1=\"1\" att2=\"1\"", sw.toString());
    }

    public void testWriteXml() throws Exception {
        String xml = "<test att1='1' att2='1'><child1/><child2>text</child2></test>";
        Document doc = parse(xml);
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        XmlUtil.writeXml(out, doc);
        assertEquals(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<test att1=\"1\" att2=\"1\">\n<child1/>\n<child2>text</child2>\n</test>\n",
            sw.toString());
    }

    public void testWriteElement() throws Exception {
        String xml = "<test att1=\"1\" att2=\"1\">\n<child1/>\n<child2>text</child2>\n</test>\n";
        Document doc = parse(xml);
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        XmlUtil.writeElement(out, doc.getDocumentElement());
        assertEquals(xml, sw.toString());
    }

    public static Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }
}
