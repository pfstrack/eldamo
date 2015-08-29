package xdb.layout;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import xdb.util.FileUtil;

/**
 * Manager for site's node info (navigation hierarchy).
 * 
 * @author Paul Strack
 */
public class NodeInfoManager {
    /** Directories excluded from indexing. */
    public static final String[] EXCLUDES = { "/docs/test-reports", "/docs/coverage-reports" };
    private static NodeInfoManager instance;

    /**
     * Initialize the NodeInfoManager.
     * 
     * @param context
     *            The context path.
     * @param root
     *            The web app root directory.
     * @throws IOException
     *             For errors.
     */
    public static void init(String context, String root) throws IOException {
        instance = new NodeInfoManager(context, root);
    }

    /**
     * Get instance of the NodeInfoManager.
     * 
     * @return The NodeInfoManager.
     */
    public static NodeInfoManager getInstance() {
        return instance;
    }

    private final String context;
    private final NodeInfo rootNode;
    private final Map<String, NodeInfo> nodeMap = new HashMap<String, NodeInfo>();

    /**
     * Constructor.
     * 
     * @param context
     *            The context path.
     * @param root
     *            The web app root directory.
     * @throws IOException
     *             For errors.
     */
    public NodeInfoManager(String context, String root) throws IOException {
        this.context = context;
        this.rootNode = deriveNodeInfo(root);
    }

    /**
     * The root node (for the home page).
     * 
     * @return The root node.
     */
    public NodeInfo getRootNode() {
        return this.rootNode;
    }

    /**
     * Get a node by its URI. This URI should include the context path.
     * 
     * @param uri
     *            The node URI.
     * @return The node for its URI.
     */
    public NodeInfo getNode(String uri) {
        return nodeMap.get(uri);
    }

    private NodeInfo deriveNodeInfo(String root) throws IOException {
        File rootDir = new File(root);
        int rootLength = rootDir.getAbsolutePath().length();
        NodeInfo parent = null;
        return deriveIndexNode(rootDir, rootLength, parent);
    }

    private NodeInfo deriveIndexNode(File dir, int rootLength, NodeInfo parent) throws IOException {
        File[] files = FileUtil.listFiles(dir);
        File index = null;
        for (File file : files) {
            if (file.getName().startsWith("index")) {
                index = file;
                break;
            }
        }
        NodeInfo indexNode = deriveNode(index, rootLength, parent);
        if (indexNode == null) {
            return null;
        }
        for (File file : files) {
            if (file.isDirectory()) {
                NodeInfo child = deriveIndexNode(file, rootLength, indexNode);
                if (child != null) {
                    indexNode.addChild(child);
                }
            } else if (!file.getName().startsWith("index")) {
                NodeInfo child = deriveNode(file, rootLength, indexNode);
                if (child != null) {
                    indexNode.addChild(child);
                }
            }
        }
        return indexNode;
    }

    private NodeInfo deriveNode(File index, int rootLength, NodeInfo parent) throws IOException {
        NodeInfo node = null;
        if (index != null) {
            String title = deriveTitle(index);
            if (title != null) {
                String uri = index.getAbsolutePath().substring(rootLength);
                for (String exclude : EXCLUDES) {
                    if (uri.startsWith(exclude)) {
                        return null;
                    }
                }
                uri = context + uri;
                node = new NodeInfo(parent, title, uri);
                nodeMap.put(uri, node);
            }
        }
        return node;
    }

    private String deriveTitle(File file) throws IOException {
        String text = FileUtil.loadText(file);
        if (!(text.indexOf("<html>") >= 0)) {
            return null;
        }
        if (!(text.indexOf("<body>") >= 0)) {
            return null;
        }
        if (!(text.indexOf("</body>") >= 0)) {
            return null;
        }
        String startTitleElement = "<title>";
        int startTitle = text.indexOf(startTitleElement);
        int endTitle = text.indexOf("</title>");
        int startTitleElementLength = startTitleElement.length();
        if (startTitle >= 0 && endTitle > startTitle + startTitleElementLength) {
            return text.substring(startTitle + startTitleElementLength, endTitle);
        } else {
            return null;
        }
    }
}
