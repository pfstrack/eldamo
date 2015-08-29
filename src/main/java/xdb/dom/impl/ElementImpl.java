package xdb.dom.impl;

import org.w3c.dom.DOMException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Implementation of Element class for elements that contain other elements.
 */
public class ElementImpl extends ElementBase {
    private NodeList childNodes = NodeListImpl.EMPTY_LIST;

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
    public ElementImpl(int position, String name, Node parent) {
        super(position, name, parent);
    }

    @Override
    public NodeList getChildNodes() {
        return this.childNodes;
    }

    @Override
    public boolean hasChildNodes() {
        return this.childNodes.getLength() > 0;
    }

    @Override
    public Node replaceChild(Node newChild, Node oldChild) throws DOMException {
        if (!(oldChild instanceof ElementBase) || !(newChild instanceof ElementBase)) {
            throw DOMImplementationImpl.hierarchyRequestErr();
        }
        Node[] rawArray = ((NodeListImpl) childNodes).getRawArray();
        boolean replaced = false;
        for (int i = 0; i < rawArray.length; i++) {
            Node node = rawArray[i];
            if (node.isSameNode(oldChild)) {
                rawArray[i] = newChild;
                ((ElementBase) newChild).setParent(oldChild.getParentNode());
                ElementBase oldElement = (ElementBase) oldChild;
                oldElement.setParent(null);
                oldElement.setPreviousSibling(null);
                oldElement.setNextSibling(null);
                replaced = true;
            }
        }
        if (replaced) {
            fixChildren();
            return oldChild;
        } else {
            throw DOMImplementationImpl.hierarchyRequestErr();
        }
    }

    @Override
    public String getTextContent() {
        StringBuffer buffer = new StringBuffer();
        NodeList children = getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            buffer.append(children.item(i).getTextContent());
        }
        return buffer.toString();
    }

    @Override
    void addChild(Node child) {
        if (!(childNodes instanceof NodeListMutable)) {
            childNodes = new NodeListMutable();
        }
        ((NodeListMutable) childNodes).add(child);
    }

    @Override
    void fixChildren() {
        if (childNodes instanceof NodeListMutable) {
            childNodes = ((NodeListMutable) childNodes).fixed();
        }
        for (int i = 0; i < childNodes.getLength(); i++) {
            ElementBase element = (ElementBase) childNodes.item(i);
            element.setPreviousSibling(childNodes.item(i - 1));
            element.setNextSibling(childNodes.item(i + 1));
        }
    }
}
