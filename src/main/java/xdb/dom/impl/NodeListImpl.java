package xdb.dom.impl;

import java.util.List;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Implementation of (immutable) NodeList class.
 */
public class NodeListImpl implements NodeList {

    /** An empty list. */
    public static final NodeList EMPTY_LIST = new NodeList() {
        public int getLength() {
            return 0;
        }

        public Node item(int index) {
            return null;
        }
    };

    private final Node[] nodes;

    /**
     * Constructor.
     * 
     * @param nodes
     *            Nodes in list.
     */
    public NodeListImpl(Node[] nodes) {
        this.nodes = nodes;
    }

    @Override
    public int getLength() {
        return nodes.length;
    }

    @Override
    public Node item(int index) {
        if (index < 0 || index >= nodes.length) {
            return null;
        }
        return nodes[index];
    }

    Node[] getRawArray() {
        return nodes;
    }

    /**
     * Utility method to convert a java.util.List of Nodes to a NodeList.
     * 
     * @param list
     *            The list of nodes.
     * @return The NodeList.
     */
    public static NodeList toNodeList(List<Node> list) {
        if (list.size() == 0) {
            return NodeListImpl.EMPTY_LIST;
        }
        Node[] array = new Node[list.size()];
        list.toArray(array);
        return new NodeListImpl(array);
    }
}
