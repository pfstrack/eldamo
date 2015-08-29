package xdb.config;

import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import xdb.dom.DomManager;
import xdb.dom.XPathEngine;
import xdb.dom.XmlParser;
import xdb.dom.impl.DocumentImpl;
import xdb.util.FileUtil;

/**
 * Manager for model configurations.
 * 
 * @author ps142237
 */
public class ModelConfigManager {

    private static final Logger LOGGER = Logger.getLogger(ModelConfigManager.class.getName());
    private static volatile ModelConfigManager singleton;
    private static File configRoot;

    /**
     * Initialize the model configuration.
     * 
     * @param context
     *            The servlet context, used to find locations within the web application directory
     *            structure.
     */
    public static void init(ServletContext context) {
        if (singleton == null) {
            configRoot = new File(context.getRealPath("config/model-configs"));
            singleton = loadData();
        }
        ConfigMonitor monitor = ConfigMonitor.getInstance();
        if (!monitor.listenerExists(configRoot)) {
            monitor.addConfigListener(configRoot, new ConfigListener() {
                public void configChanged(List<File> changedFiles) {
                    singleton = loadData();
                    try {
                        DocumentImpl doc = (DocumentImpl) DomManager.getDoc();
                        doc.buildIndex();
                    } catch (Exception ex) {
                        String msg = "Document not available for re-indexing";
                        LOGGER.log(Level.SEVERE, msg, ex);
                    }
                }
            });
        }
    }

    /**
     * Get the manager.
     * 
     * @return The manager singleton.
     */
    public static ModelConfigManager instance() {
        return singleton;
    }

    private static ModelConfigManager loadData() {
        ModelConfigManager manager = new ModelConfigManager(null);
        File[] files = FileUtil.listFiles(configRoot);
        for (File file : files) {
            if (file.getName().endsWith(".xml")) {
                manager = new ModelConfigManager(file);
                break; // Only first config
            }
        }
        return manager;
    }

    private Map<String, List<Key>> keyMap = new HashMap<String, List<Key>>();

    /**
     * Constructor.
     * 
     * @param config
     *            The config file.
     */
    public ModelConfigManager(File config) {
        if (config != null) {
            String fileName = config.getName();
            try {
                XmlParser parser = new XmlParser();
                Document doc = parser.parse(config);
                NodeList keys = doc.getElementsByTagName("key");
                for (int i = 0; i < keys.getLength(); i++) {
                    Element element = (Element) keys.item(i);
                    initKey(element);
                }
            } catch (Exception ex) {
                String msg = "Config parsing failed for " + fileName + " - " + ex;
                LOGGER.log(Level.WARNING, msg, ex);
            }
        }
    }

    /**
     * Get list of keys for an element name.
     * 
     * @param element
     *            The element name.
     * @return The list of keys.
     */
    public List<Key> getKeys(String element) {
        List<Key> keys = keyMap.get(element);
        if (keys == null) {
            return Collections.emptyList();
        }
        return keys;
    }

    private void initKey(Element element) throws XPathExpressionException {
        String name = element.getAttribute("name");
        String matches = element.getAttribute("match");
        String type = element.getAttribute("type");
        if (type == null) {
            type = "node";
        }
        String use = element.getAttribute("use");
        for (String match : matches.split("\\|")) {
            match = match.trim();
            Key key = new Key(name, match, type, use);
            List<Key> list = keyMap.get(match);
            if (list == null) {
                list = new LinkedList<Key>();
                keyMap.put(match, list);
            }
            list.add(key);
        }
    }

    /** Class defining an index key. */
    public static final class Key {
        private final String name;
        private final String match;
        private final String type;
        private final XPathExpression xpath;

        private Key(String name, String match, String type, String use) throws XPathExpressionException {
            this.name = name;
            this.match = match;
            this.type = type;
            this.xpath = XPathEngine.getUnparametrizedXPath(use);
        }

        /**
         * The key name.
         * 
         * @return the name
         */
        public String getName() {
            return name;
        }

        /**
         * The element matched.
         * 
         * @return the match
         */
        public String getMatch() {
            return match;
        }
        
        /**
         * The type of match: string or node.
         * 
         * @return the type
         */
        public String getType() {
            return this.type;
        }

        /**
         * The xpath expresssion from the "use" value.
         * 
         * @return the xpath
         */
        public XPathExpression getXpath() {
            return xpath;
        }
    }
}
