package xdb.config;

import java.io.File;
import java.net.URL;
import javax.servlet.ServletContext;

import xdb.config.ModelConfigManager;
import xdb.http.MockContext;
import junit.framework.TestCase;

public class ModelConfigManagerTest extends TestCase {

    public ModelConfigManagerTest(String testName) {
        super(testName);
    }

    public static ModelConfigManager getTestModelConfigManager() {
        init();
        return ModelConfigManager.instance();
    }

    public static void init() {
        Class<ModelConfigManagerTest> cls = ModelConfigManagerTest.class;
        URL url = cls.getResource("model-configs/model-config.xml");
        File root = new File(url.getPath()).getParentFile();
        final String realPath = root.getAbsolutePath();
        ServletContext context = new MockContext() {

            @Override
            public String getRealPath(String path) {
                return realPath;
            }
        };
        ModelConfigManager.init(context);
    }

    public void testInit() {
        init();
    }

    public void testInstance() {
        ModelConfigManager result = getTestModelConfigManager();
        assertNotNull(result);
    }

    public void testGetKeys() {
        ModelConfigManager manager = getTestModelConfigManager();
        assertTrue(manager.getKeys("product").size() >= 2);
    }
}
