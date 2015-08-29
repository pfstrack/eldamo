package xdb.config;

import java.io.File;
import java.net.URL;

import javax.servlet.ServletContext;

import junit.framework.TestCase;
import xdb.http.MockContext;

/**
 * 
 * @author ps142237
 */
public class QueryConfigManagerTest extends TestCase {

    public QueryConfigManagerTest(String testName) {
        super(testName);
    }

    public static String deriveTestRoot() {
        URL rootMarker = QueryConfigManagerTest.class.getResource("query-configs/test-queries.xml");
        String markerPath = rootMarker.getPath();
        File markerFile = new File(markerPath);
        return markerFile.getParentFile().getAbsolutePath() + "/";
    }

    public void testInit() {
        ServletContext context = new MockContext() {

            @Override
            public String getRealPath(String path) {
                if (path.endsWith("query-configs")) {
                    return deriveTestRoot();
                } else {
                    return null;
                }
            }
        };
        QueryConfigManager.init(context);
        assertNotNull(QueryConfigManager.getController("/query/entity/item.xml"));
        assertTrue(QueryConfigManager.getControllerUris().size() > 0);
    }
}
