package xdb.layout;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.List;

import xdb.layout.NodeInfo;
import xdb.layout.NodeInfoManager;
import junit.framework.TestCase;

public class NodeInfoManagerTest extends TestCase {
    private static final String TEST_ROOT = deriveTestRoot();
    private NodeInfoManager nim;

    public static String deriveTestRoot() {
        URL rootMarker = NodeInfoManagerTest.class.getResource("testRoot/index.html");
        String markerPath = rootMarker.getPath();
        File markerFile = new File(markerPath);
        return markerFile.getParentFile().getAbsolutePath() + "/";
    }

    public NodeInfoManagerTest(String testName) throws IOException {
        super(testName);
        NodeInfoManager.init("/pdb", TEST_ROOT);
        nim = NodeInfoManager.getInstance();
    }

    public void testDeriveNodeInfo() throws IOException {
        NodeInfo root = nim.getRootNode();
        assertEquals("Home", root.getTitle());
        assertEquals("/pdb/index.html", root.getUri());
        assertEquals(null, root.getParent());
    }

    public void testChildPage() throws IOException {
        NodeInfo root = nim.getRootNode();
        List<NodeInfo> children = root.getChildren();
        NodeInfo page = null;
        for (NodeInfo child : children) {
            if ("Page 1".equals(child.getTitle())) {
                page = child;
            }
        }
        assertEquals("Page 1", page.getTitle());
        assertEquals("/pdb/page1.html", page.getUri());
        assertEquals(root, page.getParent());
    }

    public void testChildDirectory() throws IOException {
        NodeInfo root = nim.getRootNode();
        List<NodeInfo> children = root.getChildren();
        NodeInfo subindex = null;
        for (NodeInfo child : children) {
            if ("Subdirectory".equals(child.getTitle())) {
                subindex = child;
            }
        }
        assertEquals("Subdirectory", subindex.getTitle());
        assertEquals("/pdb/subdir/index.html", subindex.getUri());
        assertEquals(root, subindex.getParent());
        List<NodeInfo> subchildren = subindex.getChildren();
        NodeInfo page = null;
        for (NodeInfo child : subchildren) {
            if ("Page 2".equals(child.getTitle())) {
                page = child;
            }
        }
        assertEquals("Page 2", page.getTitle());
        assertEquals("/pdb/subdir/page2.html", page.getUri());
        assertEquals(subindex, page.getParent());
    }

    public void testGetNode() throws IOException {
        NodeInfo page = nim.getNode("/pdb/subdir/page2.html");
        assertEquals("Page 2", page.getTitle());
        assertEquals("/pdb/subdir/page2.html", page.getUri());
        assertEquals("Subdirectory", page.getParent().getTitle());
    }

    public void testNoRss() throws IOException {
        NodeInfo root = nim.getRootNode();
        List<NodeInfo> children = root.getChildren();
        NodeInfo page = null;
        for (NodeInfo child : children) {
            if ("/pdb/rss.jsp".equals(child.getUri())) {
                page = child;
            }
        }
        assertEquals(null, page);
    }
}
