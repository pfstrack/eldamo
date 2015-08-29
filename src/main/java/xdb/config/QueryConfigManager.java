package xdb.config;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import xdb.control.Controller;
import xdb.control.Query;
import xdb.control.Renderer;
import xdb.control.RequestParser;
import xdb.dom.XmlParser;
import xdb.query.QueryInit;
import xdb.renderer.RendererInit;
import xdb.request.RequestParserInit;
import xdb.util.FileUtil;

/**
 * Manager for query service configurations.
 * 
 * @author ps142237
 */
public final class QueryConfigManager {

    private QueryConfigManager() {
    };

    private static final Logger LOGGER = Logger.getLogger(QueryConfigManager.class.getName());
    private static volatile Map<String, Controller> controllerMap;
    private static String configRoot;

    /**
     * Initialize the query configuration.
     * 
     * @param context
     *            The servlet context, used to find locations within the web application directory
     *            structure.
     */
    public static void init(ServletContext context) {
        if (controllerMap == null) {
            configRoot = context.getRealPath("config/query-configs");
            controllerMap = loadData();
        }
        ConfigMonitor monitor = ConfigMonitor.getInstance();
        if (!monitor.listenerExists(new File(configRoot))) {
            monitor.addConfigListener(new File(configRoot), new ConfigListener() {
                public void configChanged(List<File> changedFiles) {
                    controllerMap = loadData();
                }
            });
        }
    }

    /**
     * The configuration root directory.
     * 
     * @return the configRoot
     */
    public static String getConfigRoot() {
        return configRoot;
    }

    /**
     * Get a service controller for a uri.
     * 
     * @param uri
     *            The uri (with context path prefix removed).
     * @return The controller.
     */
    public static Controller getController(String uri) {
        Controller controller = controllerMap.get(uri);
        if (controller == null) {
            // Look for "/dir/name.*"
            int lastPeriod = uri.lastIndexOf('.');
            if (lastPeriod >= 0) {
                uri = uri.substring(0, lastPeriod + 1);
                controller = controllerMap.get(uri + "*");
            }
        }
        if (controller == null) {
            // Look for "/dir/*"
            int lastSlash = uri.lastIndexOf('/');
            while (lastSlash >= 0) {
                uri = uri.substring(0, lastSlash + 1);
                controller = controllerMap.get(uri + "*");
                if (controller != null) {
                    break;
                }
                lastSlash = uri.lastIndexOf('/', lastSlash - 1);
            }
        }
        return controller;
    }

    /**
     * A set of all controller uris.
     * 
     * @return All controller uris.
     */
    public static Set<String> getControllerUris() {
        return new TreeSet<String>(controllerMap.keySet());
    }

    private static Map<String, Controller> loadData() {
        Map<String, Controller> map = new HashMap<String, Controller>();
        File configDirectory = new File(configRoot);
        File[] files = FileUtil.listFiles(configDirectory);
        for (File file : files) {
            if (file.getName().endsWith(".xml")) {
                parseConfigXml(map, file);
            }
        }
        return map;
    }

    private static void parseConfigXml(Map<String, Controller> map, File file) {
        String fileName = file.getName();
        try {
            XmlParser parser = new XmlParser();
            Document doc = parser.parse(file);
            NodeList configs = doc.getElementsByTagName("query-controller");
            for (int i = 0; i < configs.getLength(); i++) {
                Element config = (Element) configs.item(i);
                String pattern = config.getAttribute("uri-pattern");
                Controller controller = initController(config, pattern, fileName);
                if (controller != null) {
                    map.put("/content" + pattern, controller);
                }
            }
        } catch (Exception ex) {
            String msg = "Config parsing failed for " + fileName + " - " + ex;
            LOGGER.log(Level.WARNING, msg, ex);
        }
    }

    private static Controller initController(Element configElement, String pattern, String fileName) {
        try {
            Element requestElement = (Element) configElement.getFirstChild();
            RequestParser parser = RequestParserInit.init(requestElement, fileName);
            Element queryElement = (Element) configElement.getElementsByTagName("query").item(0)
                .getFirstChild();
            Query query = QueryInit.init(queryElement, fileName);
            NodeList rendererElements = configElement.getElementsByTagName("renderers").item(0)
                .getChildNodes();
            Map<String, Renderer> renderers = new HashMap<String, Renderer>();
            for (int i = 0; i < rendererElements.getLength(); i++) {
                Element rendererElement = (Element) rendererElements.item(i);
                Renderer renderer = RendererInit.init(rendererElement, fileName);
                String contentType = rendererElement.getAttribute("content-type");
                renderers.put(contentType, renderer);
            }
            // renderers.put("about", new AboutRenderer(configElement)); // TODO : Recover
            String description = "";
            Element descriptionElement = (Element) configElement
                .getElementsByTagName("description").item(0);
            if (descriptionElement != null) {
                description = descriptionElement.getTextContent();
            }
            return new Controller(description, parser, query, renderers);
        } catch (Exception ex) {
            String msg = "Could not initialize '" + pattern + "' controller in file " + fileName
                + " - " + ex;
            LOGGER.log(Level.WARNING, msg);
            return null;
        }
    }
}
