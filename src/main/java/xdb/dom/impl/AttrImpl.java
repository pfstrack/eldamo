package xdb.dom.impl;

import net.sf.saxon.type.Type;

import org.w3c.dom.Attr;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.TypeInfo;

/**
 * Implementation of Attr class.
 */
public class AttrImpl extends NodeImpl implements Attr {

    private final int nameCode;
    private final String nodeName;
    private final String nodeValue;
    private final Element ownerElement;
    private final boolean id;

    /**
     * Constructor.
     * 
     * @param position
     *            Node position within document.
     * @param name
     *            Attribute name.
     * @param value
     *            Attribute value.
     * @param owner
     *            Owning element.
     */
    public AttrImpl(int position, String name, String value, Element owner) {
        super(position);
        this.nameCode = getNamePool().allocate("", "", name);
        this.nodeName = name;
        this.nodeValue = value;
        this.ownerElement = owner;
        this.id = "id".equals(name);
    }

    @Override
    public String getName() {
        return this.getNodeName();
    }

    @Override
    public Element getOwnerElement() {
        return this.ownerElement;
    }

    @Override
    public TypeInfo getSchemaTypeInfo() {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public boolean getSpecified() {
        return false;
    }

    @Override
    public String getValue() {
        return this.getNodeValue();
    }

    @Override
    public boolean isId() {
        return id;
    }

    @Override
    public void setValue(String value) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public NodeList getChildNodes() {
        int position = getPosition() + 1;
        TextImpl text = new TextImpl(position, getNodeValue(), this);
        Node[] list = { text };
        return new NodeListImpl(list);
    }

    @Override
    public Document getOwnerDocument() {
        Node ancestor = this.ownerElement;
        while (ancestor.getParentNode() != null) {
            ancestor = ancestor.getParentNode();
        }
        return (Document) ancestor;
    }

    @Override
    public boolean isSameNode(Node other) {
        if (other == null || !(other instanceof Attr)) {
            return false;
        }
        Attr otherAttr = (Attr) other;
        return this.getOwnerElement().isSameNode(otherAttr.getOwnerElement())
            && this.getNodeName() == other.getNodeName();
    }

    @Override
    public short getNodeType() {
        return Node.ATTRIBUTE_NODE;
    }

    @Override
    public String getNodeName() {
        return this.nodeName;
    }

    @Override
    public String getNodeValue() throws DOMException {
        return this.nodeValue;
    }

    @Override
    public Node getParentNode() {
        return null;
    }

    @Override
    public boolean hasChildNodes() {
        return true;
    }

    @Override
    public Node getPreviousSibling() {
        return null;
    }

    @Override
    public Node getNextSibling() {
        return null;
    }

    @Override
    public short compareDocumentPosition(Node other) throws DOMException {
        short comparison = super.compareDocumentPosition(other);
        if (other instanceof AttrImpl) {
            AttrImpl otherImpl = (AttrImpl) other;
            if (otherImpl.getOwnerElement().isSameNode(this.ownerElement)) {
                comparison += Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC;
            }
        }
        return comparison;
    }

    @Override
    public String getTextContent() throws DOMException {
        return this.nodeValue;
    }

    @Override
    boolean containedBy(NodeImpl other) {
        Node parent = getOwnerElement();
        while (parent != null) {
            if (other.isSameNode(parent)) {
                return true;
            }
            parent = parent.getParentNode();
        }
        return false;
    }

    @Override
    public int getNodeKind() {
        return Type.ATTRIBUTE;
    }

    @Override
    public int getNameCode() {
        return this.nameCode;
    }
}
