package xdb.dom.impl;

import org.w3c.dom.DOMException;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

/**
 * Implementation of NamedNodeMap class.
 */
public class NamedNodeMapImpl implements NamedNodeMap {

    private final ElementBase owner;
    private final String[][] attributes;

    /**
     * Constructor.
     * 
     * @param owner
     *            The owning element.
     * @param attributes
     *            The attributes in the map.
     */
    public NamedNodeMapImpl(ElementBase owner, String[][] attributes) {
        this.owner = owner;
        this.attributes = attributes;
    }

    @Override
    public int getLength() {
        return attributes.length;
    }

    @Override
    public Node getNamedItem(String name) {
        DocumentImpl doc = (DocumentImpl) owner.getOwnerDocument();
        name = doc.getCanonicalName(name);
        if (name == null) {
            return null;
        }
        int i;
        for (i = 0; i < attributes.length; i++) {
            if (attributes[i][0] == name) {
                break;
            }
        }
        return item(i);
    }

    @Override
    public Node getNamedItemNS(String namespaceURI, String localName) throws DOMException {
        return getNamedItem(localName);
    }

    @Override
    public Node item(int index) {
        if (index < 0 || index >= attributes.length) {
            return null;
        }
        String name = attributes[index][0];
        String value = attributes[index][1];
        int position = this.owner.getPosition() + 2 * index + 1;
        return new AttrImpl(position, name, value, owner);
    }

    @Override
    public Node removeNamedItem(String name) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Node removeNamedItemNS(String namespaceURI, String localName) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Node setNamedItem(Node arg) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Node setNamedItemNS(Node arg) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    /**
     * Get attribute value, using the canonical attribute name.
     * 
     * @param name
     *            The name.
     * @return The value.
     */
    String getAttributeValue(String name) {
        DocumentImpl doc = (DocumentImpl) owner.getOwnerDocument();
        name = doc.getCanonicalName(name);
        if (name == null) {
            return null;
        }
        for (String[] attribute : attributes) {
            if (attribute[0] == name) {
                return attribute[1];
            }
        }
        return null;
    }

    /**
     * Get attribute value, without using the canonical attribute name.
     * 
     * @param name
     *            The name.
     * @return The value.
     */
    String getRawAttributeValue(String name) {
        for (String[] attribute : attributes) {
            if (attribute[0].equals(name)) {
                return attribute[1];
            }
        }
        return null;
    }

    /**
     * Get all raw attribute values.
     * 
     * @return All attribute values.
     */
    public String[][] getRawAttributes() {
        return this.attributes;
    }
}
