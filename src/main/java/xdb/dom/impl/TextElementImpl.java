package xdb.dom.impl;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Implementation of Element class for elements that contain only text.
 */
public class TextElementImpl extends ElementBase {

    private final String text;

    /**
     * Constructor.
     * 
     * @param position
     *            Node position within document.
     * @param name
     *            The element name.
     * @param parent
     *            The element's parent node.
     * @param text
     *            The text in the element.
     */
    public TextElementImpl(int position, String name, Node parent, String text) {
        super(position, name, parent);
        this.text = text;
    }

    @Override
    public NodeList getChildNodes() {
        Node[] list = { new TextImpl(getPosition() + 1, text, this) };
        return new NodeListImpl(list);
    }

    @Override
    public boolean hasChildNodes() {
        return true;
    }

    @Override
    public String getTextContent() {
        return this.text;
    }
}
