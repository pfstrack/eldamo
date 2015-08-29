package xdb.config;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import xdb.config.ConfigListener;
import xdb.config.ConfigMonitor;
import junit.framework.TestCase;

public class ConfigMonitorTest extends TestCase implements ConfigListener {

    private static final int frequency = 100;
    private static final int timestampDelay = 1100;
    ConfigMonitor monitor = null;
    List<File> changedFiles = null;
    File configRoot = initConfigRoot();
    File config1 = new File(configRoot, "config1.xml");
    File config2 = new File(configRoot, "config2.xml");
    File config3 = new File(configRoot, "config3.xml");

    private static File initConfigRoot() {
        Class<ConfigMonitorTest> cls = ConfigMonitorTest.class;
        URL url = cls.getResource("ConfigMonitorTest.class");
        File file = new File(url.getFile());
        return new File(file.getParentFile(), "testConfigs");
    }

    public ConfigMonitorTest(String testName) {
        super(testName);
        Map<String, String> config = new HashMap<String, String>();
        config.put(ConfigMonitor.CHECK_FREQUENCY, String.valueOf(frequency));
        monitor = new ConfigMonitor(config);
    }

    @Override
    protected void setUp() throws Exception {
        configRoot.mkdirs();
        changedFiles = null;
        writeConfig(config1);
        writeConfig(config2);
    }

    @Override
    protected void tearDown() throws Exception {
        monitor.removeAllListeners();
        File[] files = configRoot.listFiles();
        for (int i = 0; i < files.length; i++) {
            files[i].delete();
        }
        configRoot.delete();
    }

    public void testGetMonitorProperties() {
        Map<String, String> props = ConfigMonitor.getMonitorProperties();
        assertNotNull(props.get(ConfigMonitor.CHECK_FREQUENCY));
    }

    public void testAddConfigListener() {
        File monitored = configRoot;
        monitor.addConfigListener(monitored, this);
        assertTrue(monitor.listenerExists(monitored));
        monitor.removeConfigListener(monitored);
        assertFalse(monitor.listenerExists(monitored));
    }

    public void testConfigFileChange() throws Exception {
        File monitored = config1;
        monitor.addConfigListener(monitored, this);
        Thread.sleep(frequency * 2);
        assertNull(this.changedFiles);
        Thread.sleep(timestampDelay);
        writeConfig(config1);
        Thread.sleep(frequency * 2);
        assertTrue(changedFiles.contains(config1));
    }

    public void testDirectoryChange() throws Exception {
        File monitored = configRoot;
        monitor.addConfigListener(monitored, this);
        Thread.sleep(frequency * 2);
        assertNull(this.changedFiles);
        Thread.sleep(timestampDelay);
        writeConfig(config1);
        Thread.sleep(frequency * 2);
        assertTrue(changedFiles.contains(config1));
        assertEquals(1, changedFiles.size());
    }

    public void testFileAddition() throws Exception {
        File monitored = configRoot;
        monitor.addConfigListener(monitored, this);
        writeConfig(config3);
        Thread.sleep(frequency * 2);
        assertTrue(changedFiles.contains(config3));
        assertEquals(1, changedFiles.size());
    }

    public void testFileDeletion() throws Exception {
        File monitored = configRoot;
        monitor.addConfigListener(monitored, this);
        config1.delete();
        Thread.sleep(frequency * 2);
        assertTrue(changedFiles.contains(config1));
        assertEquals(1, changedFiles.size());
    }

    // public void testLateCreationOfConfigDir() throws Exception {
    // tearDown();
    // File monitored = configRoot;
    // monitor.addConfigListener(monitored, this);
    // Thread.sleep(frequency * 2);
    // assertTrue(changedFiles == null);
    // writeConfig(config3);
    // Thread.sleep(timestampDelay);
    // assertTrue(changedFiles.contains(config3));
    // assertEquals(1, changedFiles.size());
    // }

    public void configChanged(List<File> changedFiles) {
        this.changedFiles = changedFiles;
    }

    public static void writeConfig(File file) throws IOException {
        file.getParentFile().mkdirs();
        FileWriter fw = new FileWriter(file);
        PrintWriter pw = new PrintWriter(fw);
        pw.print("<config/>");
        pw.close();
    }
}
