package xdb.dom;

import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.xml.sax.EntityResolver;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import xdb.dom.impl.DocumentImpl;
import xdb.dom.impl.DomHandler;

/**
 * Custom XML parser for memory-optimal data. The XML tree it returns complies with the W3C DOM 3.0
 * interfaces, but it optimizes the structure to reduce memory usage, taking advantage of XML data
 * that does not have mixed content and does not use namespaces.
 * 
 * <p>
 * The main efficiency is using only a single string instance for repeated string values. Wherever a
 * string value is repeated in the XML structure, it is replaced with a "canonical" string object.
 * The strategy generally means the memory footprint of the XML data is only about 20-25% of the
 * file size.
 * </p>
 * 
 * <p>
 * Another advantage of this approach is that repeated string values like element and attribute
 * names can be compared internally using the "==" operator instead of the slower String.equals()
 * method. External class can use this technique as well by casting the document to a
 * {@link xdb.dom.impl.DocumentImpl} and using its getCanonicalName() method.
 * </p>
 * 
 * <p>
 * The canonical strings are <i>not</i> produced with the String.intern() method. This is because
 * interned strings are held in memory permanently, resulting in memory leaks. This also means that
 * the canonical strings are specific to a particular document instance, and will vary between
 * instances. Canonical string values must be retrieved from the document each time it is processed,
 * as these values will change when the data is reloaded.
 * </p>
 * 
 * @author Paul Strack
 */
public class XmlParser extends DocumentBuilder {
    private ErrorHandler eh = null;

    @Override
    public DOMImplementation getDOMImplementation() {
        return DocumentImpl.IMPLEMENTATION;
    }

    @Override
    public boolean isNamespaceAware() {
        return false;
    }

    @Override
    public boolean isValidating() {
        return false;
    }

    @Override
    public Document newDocument() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setEntityResolver(EntityResolver er) {
    }

    @Override
    public void setErrorHandler(ErrorHandler errorHandler) {
        this.eh = errorHandler;
    }

    @Override
    public Document parse(InputSource is) throws SAXException, IOException {
        try {
            SAXParserFactory factor = SAXParserFactory.newInstance();
            SAXParser parser = factor.newSAXParser();
            XMLReader reader = parser.getXMLReader();
            if (eh != null) {
                reader.setErrorHandler(eh);
            }
            DomHandler handler = new DomHandler();
            reader.setContentHandler(handler);
            reader.parse(is);
            return handler.getDoc();
        } catch (ParserConfigurationException ex) {
            throw new SAXException(ex);
        }
    }
}
