package xdb.layout;

import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;

/**
 * A navigation node for a page. It is used to generate breadcrumb information.
 * 
 * @author Paul Strack
 */
public class NodeInfo {
    private static final Comparator<NodeInfo> COMPARATOR = new Comparator<NodeInfo>() {

        public int compare(NodeInfo arg0, NodeInfo arg1) {
            return arg0.getTitle().compareToIgnoreCase(arg1.getTitle());
        }
    };

    private final NodeInfo parent;
    private final String title;
    private final String uri;
    private final List<NodeInfo> children = new LinkedList<NodeInfo>();

    /**
     * Constructor.
     * 
     * @param parent
     *            Parent node, or null if there is no parent.
     * @param title
     *            The node title.
     * @param uri
     *            The node uri.
     */
    public NodeInfo(NodeInfo parent, String title, String uri) {
        this.parent = parent;
        this.title = title;
        this.uri = uri;
    }

    /**
     * The parent node, or null if there is no parent.
     * 
     * @return The parent node.
     */
    public NodeInfo getParent() {
        return parent;
    }

    /**
     * The node title, for the page title and breadcrumb trails.
     * 
     * @return The node title.
     */
    public String getTitle() {
        return title;
    }

    /**
     * The node uri, for breadcrumb trails.
     * 
     * @return The node uri.
     */
    public String getUri() {
        return uri;
    }

    /**
     * The node children.
     * 
     * @return The node children.
     */
    public List<NodeInfo> getChildren() {
        return children;
    }

    void addChild(NodeInfo child) {
        children.add(child);
        Collections.sort(children, COMPARATOR);
    }
}
