package xdb.dom.impl;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.w3c.dom.Element;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

/**
 * Class for handling parsing of content for XmlParser.
 */
public class DomHandler implements ContentHandler {
    private DocumentImpl doc;

    private NodeImpl current;

    private StringBuffer buffer;

    private Map<String, String> textSpace;

    private Map<String, Element> elementById;

    private Set<String> nodeNames;

    private int position = 0;

    @Override
    public void startDocument() throws SAXException {
        doc = new DocumentImpl(position++);
        current = getDoc();
        buffer = new StringBuffer();
        textSpace = new HashMap<String, String>();
        nodeNames = new HashSet<String>();
        elementById = new HashMap<String, Element>();
    }

    @Override
    public void startElement(String uri, String localName, String name, Attributes atts)
        throws SAXException {
        String elementName = fixText(name);
        nodeNames.add(elementName);
        ElementImpl element = new ElementImpl(position++, elementName, current);
        String[][] attributes = new String[atts.getLength()][2];
        for (int i = 0; i < atts.getLength(); i++) {
            String attributeName = fixText(atts.getQName(i));
            nodeNames.add(attributeName);
            attributes[i][0] = attributeName;
            String attributeValue = atts.getValue(i);
            attributes[i][1] = fixText(attributeValue);
        }
        position += attributes.length * 2;
        element.setAttributes(new NamedNodeMapImpl(element, attributes));
        current = element;
        buffer.setLength(0);
    }

    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        buffer.append(ch, start, length);
    }

    @Override
    public void endElement(String uri, String localName, String name) throws SAXException {
        NodeImpl parent = (NodeImpl) current.getParentNode();
        String text = buffer.toString().trim();
        if (text.length() > 0) {
            if (current.getChildNodes().getLength() > 0) {
                throw new SAXException("Mixed content not allowed - " + text);
            }
            String nodeName = current.getNodeName();
            NamedNodeMapImpl attributes = (NamedNodeMapImpl) current.getAttributes();
            current = new TextElementImpl(current.getPosition(), nodeName, parent, text);
            ElementBase elementBase = (ElementBase) current;
            String[][] rawAtts = attributes.getRawAttributes();
            NamedNodeMapImpl newAtts = new NamedNodeMapImpl(elementBase, rawAtts);
            elementBase.setAttributes(newAtts);
            position++;
        } else {
            current.fixChildren();
        }
        NamedNodeMapImpl atts = (NamedNodeMapImpl) current.getAttributes();
        String id = atts.getRawAttributeValue("id");
        if (id != null) {
            this.elementById.put(id, (ElementBase) current);
        }
        parent.addChild(current);
        current = parent;
        buffer.setLength(0);
    }

    @Override
    public void endDocument() throws SAXException {
        getDoc().fixChildren();
        Set<String> cleanSet = new HashSet<String>(this.nodeNames.size());
        cleanSet.addAll(this.nodeNames);
        getDoc().setNodeNames(cleanSet);
        Map<String, Element> cleanMap = new HashMap<String, Element>(elementById.size());
        cleanMap.putAll(elementById);
        getDoc().setElementById(cleanMap);
    }

    @Override
    public void endPrefixMapping(String prefix) throws SAXException {
    }

    @Override
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
    }

    @Override
    public void processingInstruction(String target, String data) throws SAXException {
    }

    @Override
    public void setDocumentLocator(Locator locator) {
    }

    @Override
    public void skippedEntity(String name) throws SAXException {
    }

    @Override
    public void startPrefixMapping(String prefix, String uri) throws SAXException {
    }

    private String fixText(String text) {
        String fixedText = textSpace.get(text);
        if (fixedText == null) {
            fixedText = text;
            textSpace.put(text, fixedText);
        }
        return fixedText;
    }

    /**
     * Return the parsed document.
     * 
     * @return The parsed document.
     */
    public DocumentImpl getDoc() {
        return doc;
    }
}
