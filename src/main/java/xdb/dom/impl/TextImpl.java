package xdb.dom.impl;

import net.sf.saxon.type.Type;
import org.w3c.dom.DOMException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

/**
 * Implementation of Text class.
 */
public class TextImpl extends NodeImpl implements Text {
    private static final String TEXT_NAME = "#text";

    private final Node parentNode;
    private final String nodeValue;

    /**
     * Constructor.
     * 
     * @param position
     *            Node position within document.
     * @param value
     *            The text in the node.
     * @param parent
     *            The parent node.
     */
    public TextImpl(int position, String value, Node parent) {
        super(position);
        this.nodeValue = value;
        this.parentNode = parent;
    }

    @Override
    public String getWholeText() {
        return this.getNodeValue();
    }

    @Override
    public boolean isElementContentWhitespace() {
        return false;
    }

    @Override
    public Text replaceWholeText(String content) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Text splitText(int offset) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void appendData(String arg) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void deleteData(int offset, int count) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public String getData() throws DOMException {
        return this.getNodeValue();
    }

    @Override
    public int getLength() {
        return this.getNodeValue().length();
    }

    @Override
    public void insertData(int offset, String arg) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void replaceData(int offset, int count, String arg) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setData(String data) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public String substringData(int offset, int count) throws DOMException {
        try {
            return this.getNodeValue().substring(offset, offset + count);
        } catch (StringIndexOutOfBoundsException ex) {
            throw new DOMException(DOMException.INDEX_SIZE_ERR, ex.getMessage());
        }
    }

    @Override
    public boolean isSameNode(Node other) {
        if (other == null || !(other instanceof Text)) {
            return false;
        }
        return this.getParentNode().isSameNode(other.getParentNode());
    }

    @Override
    public short getNodeType() {
        return Node.TEXT_NODE;
    }

    @Override
    public String getNodeName() {
        return TEXT_NAME;
    }

    @Override
    public String getNodeValue() throws DOMException {
        return this.nodeValue;
    }

    @Override
    public NodeList getChildNodes() {
        return NodeListImpl.EMPTY_LIST;
    }

    @Override
    public Node getParentNode() {
        return this.parentNode;
    }

    @Override
    public boolean hasChildNodes() {
        return false;
    }

    @Override
    public String getTextContent() {
        return this.nodeValue;
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
    public int getNodeKind() {
        return Type.TEXT;
    }
}
