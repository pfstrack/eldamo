package xdb.dom.impl;

import java.util.LinkedList;
import java.util.List;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Implementation of (mutable) NodeList class.
 */
public class NodeListMutable implements NodeList {

    private List<Node> list = new LinkedList<Node>();

    @Override
    public int getLength() {
        return list.size();
    }

    @Override
    public Node item(int index) {
        if (index < 0 || index >= list.size()) {
            return null;
        }
        return list.get(index);
    }

    /**
     * Add a node.
     * 
     * @param node
     *            The node.
     */
    public void add(Node node) {
        list.add(node);
    }

    /**
     * Convert to an immutable NodeListImpl.
     * 
     * @return The immutable NodeListImpl.
     */
    public NodeListImpl fixed() {
        Node[] array = new Node[list.size()];
        list.toArray(array);
        return new NodeListImpl(array);
    }
}
