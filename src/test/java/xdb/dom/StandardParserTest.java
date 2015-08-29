package xdb.dom;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

public class StandardParserTest extends XmlParserTest {

    public StandardParserTest(String testName) {
        super(testName);
    }

    public DocumentBuilder getParser() throws ParserConfigurationException {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setIgnoringElementContentWhitespace(true);
        return dbf.newDocumentBuilder();
    }
}
