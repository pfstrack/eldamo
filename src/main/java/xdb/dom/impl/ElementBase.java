package xdb.dom.impl;

import java.util.LinkedList;
import java.util.List;
import net.sf.saxon.type.Type;
import org.w3c.dom.Attr;
import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.TypeInfo;

/**
 * Super class of implementations of the Element class.
 */
public abstract class ElementBase extends NodeImpl implements Element {

    private final int nameCode;
    private final String nodeName;
    private Node parentNode;
    private NamedNodeMap attributes;
    private Node previousSibling;
    private Node nextSibling;

    /**
     * Constructor.
     * 
     * @param position
     *            Node position within document.
     * @param name
     *            The element name.
     * @param parent
     *            The element's parent node.
     */
    public ElementBase(int position, String name, Node parent) {
        super(position);
        this.nameCode = getNamePool().allocate("", "", name);
        this.nodeName = name;
        this.parentNode = parent;
    }

    @Override
    public String getAttribute(String name) {
        NamedNodeMapImpl atts = (NamedNodeMapImpl) getAttributes();
        String value = atts.getAttributeValue(name);
        return value == null ? "" : value;
    }

    @Override
    public String getAttributeNS(String namespaceURI, String localName) throws DOMException {
        return getAttribute(localName);
    }

    @Override
    public Attr getAttributeNode(String name) {
        return (Attr) getAttributes().getNamedItem(name);
    }

    @Override
    public Attr getAttributeNodeNS(String namespaceURI, String localName) throws DOMException {
        return getAttributeNode(localName);
    }

    @Override
    public NodeList getElementsByTagName(String name) {
        DocumentImpl doc = (DocumentImpl) this.getOwnerDocument();
        name = doc.getCanonicalName(name);
        if (name == null) {
            return NodeListImpl.EMPTY_LIST;
        }
        List<Node> list = new LinkedList<Node>();
        addByTagName(getChildNodes(), name, list);
        return NodeListImpl.toNodeList(list);
    }

    /**
     * Utility method to all children to node list matching the tag name.
     * 
     * @param children
     *            The children.
     * @param name
     *            The canonical tag name (suitable for "==" comparison).
     * @param list
     *            The list of nodes.
     */
    static void addByTagName(NodeList children, String name, List<Node> list) {
        for (int i = 0; i < children.getLength(); i++) {
            Node node = children.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                if (node.getNodeName() == name) {
                    list.add(node);
                }
                addByTagName(node.getChildNodes(), name, list);
            }
        }
    }

    @Override
    public NodeList getElementsByTagNameNS(String namespaceURI, String localName)
        throws DOMException {
        return getElementsByTagName(localName);
    }

    @Override
    public TypeInfo getSchemaTypeInfo() {
        return null;
    }

    @Override
    public String getTagName() {
        return getNodeName();
    }

    @Override
    public boolean hasAttribute(String name) {
        NamedNodeMapImpl atts = (NamedNodeMapImpl) getAttributes();
        String value = atts.getAttributeValue(name);
        return value != null;
    }

    @Override
    public boolean hasAttributeNS(String namespaceURI, String localName) throws DOMException {
        return hasAttribute(localName);
    }

    @Override
    public void removeAttribute(String name) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void removeAttributeNS(String namespaceURI, String localName) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Attr removeAttributeNode(Attr oldAttr) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setAttribute(String arg0, String arg1) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setAttributeNS(String namespaceURI, String qualifiedName, String value)
        throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Attr setAttributeNode(Attr newAttr) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Attr setAttributeNodeNS(Attr newAttr) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setIdAttribute(String name, boolean isId) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setIdAttributeNS(String namespaceURI, String localName, boolean isId)
        throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setIdAttributeNode(Attr idAttr, boolean isId) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public NamedNodeMap getAttributes() {
        return this.attributes;
    }

    @Override
    public boolean hasAttributes() {
        NamedNodeMap atts = getAttributes();
        return atts != null && atts.getLength() > 0;
    }

    @Override
    public short getNodeType() {
        return Node.ELEMENT_NODE;
    }

    @Override
    public String getNodeName() {
        return this.nodeName;
    }

    @Override
    public String getNodeValue() throws DOMException {
        return null;
    }

    @Override
    public Node getParentNode() {
        return this.parentNode;
    }

    @Override
    public Node getNextSibling() {
        return this.nextSibling;
    }

    @Override
    public Node getPreviousSibling() {
        return this.previousSibling;
    }

    void setAttributes(NamedNodeMap attributes) {
        this.attributes = attributes;
    }

    void setPreviousSibling(Node node) {
        this.previousSibling = node;
    }

    void setNextSibling(Node node) {
        this.nextSibling = node;
    }

    void setParent(Node node) {
        this.parentNode = node;
    }

    @Override
    public int getNodeKind() {
        return Type.ELEMENT;
    }

    @Override
    public int getNameCode() {
        return this.nameCode;
    }
}
