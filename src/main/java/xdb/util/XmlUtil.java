package xdb.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;


import net.sf.saxon.Configuration;
import net.sf.saxon.s9api.Processor;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.helpers.DefaultHandler;

import xdb.dom.impl.DocumentImpl;
import xdb.dom.impl.NamedNodeMapImpl;
import xdb.dom.impl.TextElementImpl;

/**
 * Utility class for XML processing.
 */
public final class XmlUtil {

    public static final Processor PROCESSOR = new Processor(false);
    public static final Configuration SAXON_CONFIG = PROCESSOR.getUnderlyingConfiguration();

    private XmlUtil() {
    }

    /**
     * Verify that specified file is well-formed XML. Does not validate against the schema or DTD.
     * 
     * @param xml
     *            The XML file.
     * @throws SAXException
     *             For parse errors.
     * @throws IOException
     *             For I/O errors.
     */
    public static void verifyXml(File xml) throws SAXException, IOException {
        if (!xml.exists()) {
            throw new IOException("XML file " + xml + " does not exist.");
        }
        parse(xml.getAbsolutePath(), new DefaultHandler());
    }

    /**
     * Parse file as namespaceless XML. Does not load the DTD, if any.
     * 
     * @param path
     *            The XML file.
     * @param handler
     *            The handler. If it is a {@link org.xml.sax.ext.LexicalHandler} it is specified as
     *            the lexical handler for the parser as well.
     * @throws SAXException
     *             For parse errors.
     * @throws IOException
     *             For I/O errors.
     */
    public static void parse(String path, DefaultHandler handler) throws SAXException, IOException {
        parse(new FileInputStream(path), handler);
    }

    /**
     * Parse file as namespaceless XML. Does not load the DTD, if any.
     * 
     * @param file
     *            The XML file.
     * @param handler
     *            The handler. If it is a {@link org.xml.sax.ext.LexicalHandler} it is specified as
     *            the lexical handler for the parser as well.
     * @throws SAXException
     *             For parse errors.
     * @throws IOException
     *             For I/O errors.
     */
    public static void parse(File file, DefaultHandler handler) throws SAXException, IOException {
        parse(new FileInputStream(file), handler);
    }

    /**
     * Parse file as namespaceless XML. Does not load the DTD, if any. Closes the stream when done.
     * 
     * @param in
     *            The input stream
     * @param handler
     *            The handler. If it is a {@link org.xml.sax.ext.LexicalHandler} it is specified as
     *            the lexical handler for the parser as well.
     * @throws SAXException
     *             For parse errors.
     * @throws IOException
     *             For I/O errors.
     */
    public static void parse(InputStream in, DefaultHandler handler) throws SAXException,
        IOException {
        BufferedInputStream bis = new BufferedInputStream(in);
        try {
            SAXParserFactory pf = SAXParserFactory.newInstance();
            pf.setValidating(false);
            pf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
            pf.setNamespaceAware(false);
            SAXParser p = pf.newSAXParser();
            if (handler instanceof LexicalHandler) {
                p.setProperty("http://xml.org/sax/properties/lexical-handler", handler);
            }
            p.parse(bis, handler);
        } catch (ParserConfigurationException e) {
            throw new SAXException(e);
        } finally {
            bis.close();
        }
    }

    /**
     * Parse an xs:dateTime value in "2009-05-21T14:52:18-07:00" format (with the timezone).
     * 
     * @param timestamp
     *            The xs:dateTime
     * @return The converted date
     * @throws DatatypeConfigurationException
     *             For errors.
     */
    public static Date parseXmlDateTimeWithZone(String timestamp)
        throws DatatypeConfigurationException {
        DatatypeFactory datatypeFactory = DatatypeFactory.newInstance();
        XMLGregorianCalendar xmlGregorianCalendar = datatypeFactory
            .newXMLGregorianCalendar(timestamp);
        GregorianCalendar gregorianCalendar = xmlGregorianCalendar.toGregorianCalendar();
        return gregorianCalendar.getTime();
    }

    /**
     * Format a date in xs:dateTime format.
     * 
     * @param date
     *            The date.
     * @return The xs:dateTime
     * @throws DatatypeConfigurationException
     *             For errors.
     */
    public static String formatXmlDateTimeWithZone(Date date) throws DatatypeConfigurationException {
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(date);
        DatatypeFactory datatypeFactory = DatatypeFactory.newInstance();
        XMLGregorianCalendar xmlGregorianCalendar = datatypeFactory.newXMLGregorianCalendar(gc);
        return xmlGregorianCalendar.toXMLFormat();
    }

    /**
     * Get the first child element with the given name.
     * 
     * @param element
     *            The parent element.
     * @param name
     *            The child element name.
     * @return The child element.
     */
    public static Element getChildElement(Element element, String name) {
        DocumentImpl doc = (DocumentImpl) element.getOwnerDocument();
        name = doc.getCanonicalName(name);
        NodeList children = element.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                if (child.getNodeName() == name) {
                    return (Element) child;
                }
            }
        }
        return null;
    }

    /**
     * Get all child elements with the given name.
     * 
     * @param element
     *            The parent element.
     * @param name
     *            The child element name.
     * @return The child elements.
     */
    public static List<Element> getChildElements(Element element, String name) {
        DocumentImpl doc = (DocumentImpl) element.getOwnerDocument();
        name = doc.getCanonicalName(name);
        NodeList children = element.getChildNodes();
        List<Element> result = new LinkedList<Element>();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                if (child.getNodeName() == name) {
                    result.add((Element) child);
                }
            }
        }
        return result;
    }

    /**
     * Write XML header (UTF-8).
     * 
     * @param out
     *            The writer.
     */
    public static void writeXmlHeader(PrintWriter out) {
        out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    }

    /**
     * Write open element with attributes.
     * 
     * @param out
     *            The output stream.
     * @param element
     *            The element name.
     * @param attributes
     *            The attributes.
     */
    public static void writeOpenElement(PrintWriter out, String element, NamedNodeMap attributes) {
        writeOpenElementFragment(out, element, attributes);
        out.print('>');
    }

    /**
     * Write close element.
     * 
     * @param out
     *            The writer.
     * @param element
     *            The element name.
     */
    public static void writeCloseElement(PrintWriter out, String element) {
        out.print("</");
        out.print(element);
        out.print('>');
    }

    /**
     * Write attribute. If the value is null, no attribute is written.
     * 
     * @param out
     *            The writer.
     * @param name
     *            The attribute name.
     * @param value
     *            The attribute value.
     */
    public static void writeAttribute(PrintWriter out, String name, String value) {
        if (value != null) {
            out.print(' ');
            out.print(name);
            out.print("=\"");
            writeCharacters(out, value);
            out.print("\"");
        }
    }

    /**
     * Write characters. Character data is properly escaped.
     * 
     * @param out
     *            The writer.
     * @param value
     *            The text as a strng.
     */
    public static void writeCharacters(PrintWriter out, String value) {
        writeCharacters(out, value.toCharArray(), 0, value.length());
    }

    /**
     * Write characters. Character data is properly escaped.
     * 
     * @param out
     *            The writer.
     * @param ch
     *            The character array.
     * @param start
     *            Start position.
     * @param length
     *            Substring length.
     */
    public static void writeCharacters(PrintWriter out, char[] ch, int start, int length) {
        for (int j = start; j < start + length; j++) {
            char c = ch[j];
            if (c == '&') {
                out.print("&amp;");
            } else if (c == '"') {
                out.print("&quot;");
            } else if (c == '<') {
                out.print("&lt;");
            } else if (c == '>') {
                out.print("&gt;");
            } else if (c == '\'') {
                out.print("&apos;");
            } else {
                out.print(c);
            }
        }
    }

    /**
     * Write the beginning of an XML element and its attributes. The closing ">" is omitted. For
     * example:
     * 
     * <pre>
     * &lt;element att="value"
     * </pre>
     * 
     * @param out
     *            The writer.
     * @param element
     *            The writer.
     * @param attributes
     *            Its attributes.
     */
    public static void writeOpenElementFragment(PrintWriter out, String element,
        NamedNodeMap attributes) {
        out.print('<');
        out.print(element);
        if (attributes != null) {
            String[][] raw = ((NamedNodeMapImpl) attributes).getRawAttributes();
            for (String[] attribute : raw) {
                writeAttribute(out, attribute[0], attribute[1]);
            }
        }
    }

    /**
     * Write document to the specified path.
     * 
     * @param path
     *            The path.
     * @param doc
     *            The document.
     * @throws IOException
     *             For errors.
     */
    public static void writeXml(String path, Document doc) throws IOException {
        String tmp = path + ".tmp";
        PrintWriter out = FileUtil.open(tmp);
        try {
            XmlUtil.writeXml(out, doc);
        } finally {
            out.close();
        }
        FileUtil.moveTempFile(tmp, path);
    }

    /**
     * Write gzipped document to the specified path.
     * 
     * @param path
     *            The path.
     * @param doc
     *            The document.
     * @throws IOException
     *             For errors.
     */
    public static void writeXmlGzipped(String path, Document doc) throws IOException {
        String tmp = path + ".tmp";
        PrintWriter out = FileUtil.openGzip(tmp);
        try {
            XmlUtil.writeXml(out, doc);
        } finally {
            out.close();
        }
        FileUtil.moveTempFile(tmp, path);
    }

    /**
     * Write document with UTF-8 XML header.
     * 
     * @param out
     *            The output stream.
     * @param doc
     *            The document.
     */
    public static void writeXml(PrintWriter out, Document doc) {
        writeXmlHeader(out);
        out.print('\n');
        writeElement(out, doc.getDocumentElement());
    }

    /**
     * Convert XML document to a string.
     * 
     * @param doc
     *            The doc.
     * @return The xml string.
     */
    public static String xmlToString(Document doc) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        writeXml(pw, doc);
        return sw.toString();
    }

    /**
     * Write element with all of its attributes and children.
     * 
     * @param out
     *            The output stream.
     * @param element
     *            The element.
     */
    public static void writeElement(PrintWriter out, Element element) {
        String name = element.getNodeName();
        writeOpenElementFragment(out, name, element.getAttributes());
        NodeList children = element.getChildNodes();
        if (children.getLength() == 0) {
            out.print("/>\n");
        } else {
            if (element instanceof TextElementImpl) {
                out.print(">");
            } else {
                out.print(">\n");
            }
            for (int i = 0; i < children.getLength(); i++) {
                Node child = children.item(i);
                if (child.getNodeType() == Node.ELEMENT_NODE) {
                    writeElement(out, (Element) child);
                } else {
                    writeCharacters(out, child.getTextContent());
                }
            }
            XmlUtil.writeCloseElement(out, name);
            out.print("\n");
        }
    }

    /**
     * Normalize a text string as per XPath normalize() function.
     * 
     * @param s
     *            The string to normalize.
     * @return The normalized text as character array.
     */
    public static char[] normalizeText(String s) {
        char[] ch = s.trim().toCharArray();
        if (ch.length == 0) {
            return ch;
        }
        return normalizeTrimmedText(ch);
    }

    private static char[] normalizeTrimmedText(char[] ch) {
        char[] ch2 = new char[ch.length];
        boolean inWhitespace = false;
        int j = 0;
        for (int i = 0; i < ch.length; i++) {
            char c = ch[i];
            boolean isWhitespace = Character.isWhitespace(c);
            if (isWhitespace && !inWhitespace) {
                ch2[j] = ' ';
                j++;
                inWhitespace = true;
            } else if (!isWhitespace) {
                ch2[j] = c;
                j++;
                inWhitespace = false;
            }
        }
        char[] ch3 = new char[j];
        for (int i = 0; i < j; i++) {
            ch3[i] = ch2[i];
        }
        return ch3;
    }
}
