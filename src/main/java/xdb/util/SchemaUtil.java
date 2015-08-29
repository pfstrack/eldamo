package xdb.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.xml.XMLConstants;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.w3c.dom.Document;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/**
 * Utility class for XML Schema (XSD) logic.
 * 
 * @author Paul Strack
 */
public final class SchemaUtil {

    private SchemaUtil() {
    }

    /**
     * Validate document against the specified schema.
     * 
     * @param doc
     *            The document.
     * @param schemaPath
     *            The path to the schema file.
     * @throws SAXException
     *             For errors.
     * @throws IOException
     *             For errors.
     */
    public static void validate(Document doc, String schemaPath) throws SAXException, IOException {
        Handler handler = new Handler();
        handler.setSchema(schemaPath);
        handler.validator.validate(new DOMSource(doc));
    }

    private static Validator getValidator(String path) throws SAXException, IOException {
        String xsdUri = XMLConstants.W3C_XML_SCHEMA_NS_URI;
        SchemaFactory sf = SchemaFactory.newInstance(xsdUri);
        InputStream stream = new FileInputStream(path);
        StreamSource xsd = new StreamSource(stream);
        Schema schema = sf.newSchema(xsd);
        return schema.newValidator();
    }

    private static class Handler implements ErrorHandler {
        private Validator validator;

        public void setSchema(String schema) throws SAXException, IOException {
            validator = SchemaUtil.getValidator(schema);
            validator.setErrorHandler(this);
        }

        public void warning(SAXParseException ex) throws SAXException {
            throw ex;
        }

        public void error(SAXParseException ex) throws SAXException {
            throw ex;
        }

        public void fatalError(SAXParseException ex) throws SAXException {
            throw ex;
        }
    };
}
