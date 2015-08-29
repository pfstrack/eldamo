package xdb.dom;

import java.io.InputStream;
import java.io.StringReader;
import java.util.List;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Text;
import org.xml.sax.InputSource;

import xdb.config.ModelConfigManagerTest;
import xdb.dom.XmlParser;
import xdb.dom.impl.DocumentImpl;
import junit.framework.TestCase;

public class XmlParserTest extends TestCase {

    public XmlParserTest(String testName) {
        super(testName);
    }

    public void testMisc() {
        XmlParser parser = new XmlParser();
        assertEquals(DocumentImpl.IMPLEMENTATION, parser.getDOMImplementation());
        assertEquals(false, parser.isNamespaceAware());
        assertEquals(false, parser.isValidating());
        try {
            parser.newDocument();
            fail("Should fail");
        } catch (Exception ex) {
            // Expected
        }
        parser.setEntityResolver(null);
        parser.setErrorHandler(null);
    }

    public void testDocument() throws Exception {
        Document node = parse("<xml />");
        assertEquals(Node.DOCUMENT_NODE, node.getNodeType());
        assertEquals("#document", node.getNodeName());
        assertNull(node.getNodeValue());
        assertNull(node.getParentNode());
        assertNull(node.getAttributes());
        assertEquals(null, node.getOwnerDocument());
    }

    public void testElement() throws Exception {
        Document doc = parse("<xml />");
        Element node = doc.getDocumentElement();
        assertEquals(Node.ELEMENT_NODE, node.getNodeType());
        assertEquals("xml", node.getNodeName());
        assertNull(node.getNodeValue());
        assertEquals(doc, node.getParentNode());
        assertEquals(0, node.getChildNodes().getLength());
        assertEquals(0, node.getAttributes().getLength());
        assertEquals(doc, node.getOwnerDocument());
    }

    public void testText() throws Exception {
        Document doc = parse("<xml>The text</xml>");
        Element element = doc.getDocumentElement();
        Text node = (Text) element.getFirstChild();
        assertEquals(Node.TEXT_NODE, node.getNodeType());
        assertEquals("#text", node.getNodeName());
        assertEquals("The text", node.getNodeValue());
        assertEquals(element, node.getParentNode());
        assertEquals(0, node.getChildNodes().getLength());
        assertNull(node.getAttributes());
        assertEquals(doc, node.getOwnerDocument());
        assertTrue(node.isSameNode(element.getFirstChild()));
    }

    public void testAttributes() throws Exception {
        Document doc = parse("<xml a='1' b='2' />");
        Element element = doc.getDocumentElement();
        assertEquals("1", element.getAttribute("a"));
        assertEquals("2", element.getAttribute("b"));
        assertEquals("", element.getAttribute("c"));
        assertEquals(null, element.getAttributeNode("c"));
        assertEquals(2, element.getAttributes().getLength());

        Attr node = (Attr) element.getAttributes().getNamedItem("a");
        assertEquals("a", node.getNodeName());
        assertEquals("1", node.getNodeValue());
        assertNull(node.getParentNode());
        assertEquals(1, node.getChildNodes().getLength());
        assertNull(node.getAttributes());
        assertEquals(doc, node.getOwnerDocument());

        assertTrue(node.isSameNode(element.getAttributes().getNamedItem("a")));

        Text text = (Text) node.getChildNodes().item(0);
        assertEquals(node.getNodeValue(), text.getNodeValue());
        assertTrue(node.getChildNodes().item(0).isSameNode(text));
    }

    public void testChildren() throws Exception {
        Document doc = parse("<xml><a>x</a><a>x</a><a>x</a></xml>");
        Element element = doc.getDocumentElement();
        assertEquals(3, element.getChildNodes().getLength());
        assertTrue(element.getFirstChild() != element.getLastChild());
    }

    public void testGetElementByTagName() throws Exception {
        Document doc = parse("<x><a>x</a><b>x</b><a>x</a></x>");
        Element element = doc.getDocumentElement();
        assertEquals(2, element.getElementsByTagName("a").getLength());
        assertEquals(0, element.getElementsByTagName("x").getLength());
        assertEquals(0, element.getElementsByTagName("q").getLength());
        assertEquals(2, doc.getElementsByTagName("a").getLength());
        assertEquals(1, doc.getElementsByTagName("x").getLength());
        assertEquals(0, doc.getElementsByTagName("q").getLength());
    }

    public void testCompareDocumentPosition() throws Exception {
        Document doc = parse("<x a='1' b='2'><a c='3'>x</a><b>x</b><a>x</a></x>");
        assertEquals(0, doc.compareDocumentPosition(doc));
        Document doc2 = parse("<x a='1' b='2'><a c='3'>x</a><b>x</b><a>x</a></x>");
        Element element = doc.getDocumentElement();
        assertTrue((Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC & doc2
            .compareDocumentPosition(doc)) > 0);
        assertTrue((Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC & doc2
            .compareDocumentPosition(element)) > 0);
        assertTrue((Node.DOCUMENT_POSITION_DISCONNECTED & doc2.compareDocumentPosition(doc)) > 0);
        assertTrue((Node.DOCUMENT_POSITION_DISCONNECTED & doc2.compareDocumentPosition(element)) > 0);
        assertEquals(Node.DOCUMENT_POSITION_CONTAINED_BY + Node.DOCUMENT_POSITION_FOLLOWING,
            doc.compareDocumentPosition(element));
        assertEquals(Node.DOCUMENT_POSITION_CONTAINS + Node.DOCUMENT_POSITION_PRECEDING,
            element.compareDocumentPosition(doc));
        Node child1 = element.getChildNodes().item(0);
        Node child2 = element.getChildNodes().item(1);
        assertEquals(Node.DOCUMENT_POSITION_FOLLOWING, child1.compareDocumentPosition(child2));
        assertEquals(Node.DOCUMENT_POSITION_PRECEDING, child2.compareDocumentPosition(child1));
        Node text = child1.getChildNodes().item(0);
        assertEquals(Node.DOCUMENT_POSITION_CONTAINED_BY + Node.DOCUMENT_POSITION_FOLLOWING,
            child1.compareDocumentPosition(text));
        assertEquals(Node.DOCUMENT_POSITION_CONTAINS + Node.DOCUMENT_POSITION_PRECEDING,
            text.compareDocumentPosition(child1));
        Node attr1 = element.getAttributeNode("a");
        assertEquals(Node.DOCUMENT_POSITION_CONTAINED_BY + Node.DOCUMENT_POSITION_FOLLOWING,
            element.compareDocumentPosition(attr1));
        assertEquals(Node.DOCUMENT_POSITION_CONTAINS + Node.DOCUMENT_POSITION_PRECEDING,
            attr1.compareDocumentPosition(element));
        Node attr2 = element.getAttributeNode("b");
        assertEquals(Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
            + Node.DOCUMENT_POSITION_FOLLOWING, attr1.compareDocumentPosition(attr2));
        assertEquals(Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
            + Node.DOCUMENT_POSITION_PRECEDING, attr2.compareDocumentPosition(attr1));
        Node attr3 = ((Element) child1).getAttributeNode("c");
        assertTrue((Node.DOCUMENT_POSITION_FOLLOWING & attr1.compareDocumentPosition(attr3)) > 0);
        assertTrue((Node.DOCUMENT_POSITION_PRECEDING & attr3.compareDocumentPosition(attr1)) > 0);
    }

    public void testGetTextContent() throws Exception {
        Document doc = parse("<x a='1' b='2'><a c='3'>x</a><b>x</b><a>x</a></x>");
        assertNull(doc.getTextContent());
        Element element = doc.getDocumentElement();
        assertEquals("xxx", element.getTextContent());
        Node child1 = element.getChildNodes().item(0);
        assertEquals("x", child1.getTextContent());
        Node text = child1.getChildNodes().item(0);
        assertEquals("x", text.getTextContent());
        Node attr1 = element.getAttributeNode("a");
        assertEquals("1", attr1.getTextContent());
    }

    public void testSiblings() throws Exception {
        Document doc = parse("<x a='1' b='2'><a c='3'>x</a><b>x</b><a>x</a></x>");
        assertNull(doc.getNextSibling());
        assertNull(doc.getPreviousSibling());
        Element element = doc.getDocumentElement();
        assertNull(element.getNextSibling());
        assertNull(element.getPreviousSibling());
        Node child1 = element.getChildNodes().item(0);
        Node child2 = element.getChildNodes().item(1);
        assertTrue(child2.isSameNode(child1.getNextSibling()));
        assertTrue(child1.isSameNode(child2.getPreviousSibling()));
        Node text = child1.getChildNodes().item(0);
        assertNull(text.getNextSibling());
        assertNull(text.getPreviousSibling());
        Node attr1 = element.getAttributeNode("a");
        assertNull(attr1.getNextSibling());
        assertNull(attr1.getPreviousSibling());
    }

    public void testId() throws Exception {
        Document doc = parse("<x><a id='1'>x</a><a id='2'>y</a><a id='3'>z</a></x>");
        if (!(doc instanceof DocumentImpl)) {
            return;
        }
        assertEquals("2", doc.getDocumentElement().getChildNodes().item(1).getAttributes()
            .getNamedItem("id").getNodeValue());
        Element element = doc.getElementById("2");
        assertEquals("y", element.getTextContent());
    }

    public void testReplace() throws Exception {
        Document doc = parseFromFile("sample-data.xml");
        Node oldPart = doc.getElementsByTagName("part").item(0);
        Node parent = oldPart.getParentNode();
        int oldPosition = parent.compareDocumentPosition(oldPart);

        Document newDoc = parse("<part id='X4238'><translation locale='en' description='New Description' /></part>");
        Node newPart = newDoc.getDocumentElement();
        newPart = doc.importNode(newPart, true);

        parent.replaceChild(newPart, oldPart);
        Element replacedPart = (Element) doc.getElementsByTagName("part").item(0);
        Element translation = (Element) replacedPart.getElementsByTagName("translation").item(0);
        assertEquals("New Description", translation.getAttribute("description"));

        if (doc instanceof DocumentImpl) {
            ((DocumentImpl) doc).reposition();
        }
        assertEquals(oldPosition, parent.compareDocumentPosition(replacedPart));
    }

    public void testReplaceWithChildren() throws Exception {
        Document doc = parseFromFile("sample-data.xml");
        Element oldCategory = (Element) doc.getElementsByTagName("category").item(1);
        Element oldProduct = (Element) oldCategory.getElementsByTagName("product").item(0);
        int oldPosition = oldCategory.compareDocumentPosition(oldProduct);

        String xml = "<category id='Blade_Servers_1'>";
        xml += "<translation locale='en' name='New Name' />";
        xml += "<children><product-ref id-ref='SB_6000_VMF_10GBE' /></children>";
        xml += "</category>";
        Document newDoc = parse(xml);
        Element newCategory = newDoc.getDocumentElement();

        newCategory = (Element) doc.importNode(newCategory, true);
        Element ref = (Element) newCategory.getElementsByTagName("product-ref").item(0);
        ref.getParentNode().replaceChild(oldProduct, ref);

        oldCategory.getParentNode().replaceChild(newCategory, oldCategory);
        Element replacedCategory = (Element) doc.getElementsByTagName("category").item(1);
        Element translation = (Element) replacedCategory.getElementsByTagName("translation")
            .item(0);
        assertEquals("New Name", translation.getAttribute("name"));

        Element newProduct = (Element) replacedCategory.getElementsByTagName("product").item(0);
        assertTrue(newProduct.isSameNode(oldProduct));

        if (doc instanceof DocumentImpl) {
            ((DocumentImpl) doc).reposition();
        }
        assertEquals(oldPosition, replacedCategory.compareDocumentPosition(newProduct));
    }

    public void testReindexing() throws Exception {
        Document doc = parseFromFile("sample-data.xml");
        if (!(doc instanceof DocumentImpl)) {
            return;
        }

        DocumentImpl docImpl = (DocumentImpl) doc;
        ModelConfigManagerTest.init();
        docImpl.buildIndex();

        Element oldCategory = doc.getElementById("Blade_Servers_1");
        Element oldProduct = doc.getElementById("SB_6000_VMF_10GBE");

        String xml = "<product id='SB_6000_VMF_10GBE' name='New Description' uuid='new-uuid'>";
        xml += "<translation locale='en' name='New Description' />";
        xml += "<children>";
        xml += "<part-ref idref='X4238' ecom-base-part='true' />";
        xml += "</children>";
        xml += "</product>";
        Document newDoc = parse(xml);
        Element newProduct = newDoc.getDocumentElement();

        docImpl.unindex(new Element[] { oldProduct });
        newProduct = (Element) doc.importNode(newProduct, true);
        oldProduct.getParentNode().replaceChild(newProduct, oldProduct);
        docImpl.reposition();
        docImpl.reindex(newProduct);

        assertEquals(newProduct, doc.getElementById("SB_6000_VMF_10GBE"));

        List<Node> elementByUuid = docImpl.getElementsFromKey("uuid", "new-uuid");
        assertEquals(newProduct, elementByUuid.get(0));

        List<Node> parentByKey = docImpl.getElementsFromKey("parent", "SB_6000_VMF_10GBE");
        assertEquals(oldCategory, parentByKey.get(0));
    }

    public Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return getParser().parse(is);
    }

    public Document parseFromFile(String file) throws Exception {
        InputStream in = getClass().getResourceAsStream(file);
        InputSource is = new InputSource(in);
        return getParser().parse(is);
    }

    public DocumentBuilder getParser() throws ParserConfigurationException {
        return new XmlParser();
    }
}
