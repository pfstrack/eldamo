package xdb.dom;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.xml.xpath.XPathExpressionException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import xdb.config.CacheManager;
import xdb.config.ConfigListener;
import xdb.config.ConfigMonitor;
import xdb.dom.impl.DocumentImpl;
import xdb.util.FileUtil;
import xdb.util.XmlUtil;

/**
 * Manager for XML data model singleton.
 * 
 * @author Paul Strack
 */
public final class DomManager {


    private DomManager() {
    }

    private static final String PATH = "/eldarin/data/eldarin-data.xml";
    private static String dataRoot = FileUtil.findDirectoryFromClasspath(DomManager.class, PATH);
    private static final Logger LOGGER = Logger.getLogger(DomManager.class.getName());
    private static volatile DocumentImpl data;
    private static volatile Date lastPatch = new Date(0);
    private static volatile Date lastLoad = new Date(0);
//    private static String schemaRoot;
//    private static String updateSchema;

    /**
     * Initialize the dom manager.
     * 
     * @param context
     *            The servlet context, used to find locations within the web application directory
     *            structure.
     */
    public static void init(ServletContext context) {
        setDataRoot(context.getRealPath("data"));
        System.err.println(getDataRoot());
        ConfigMonitor monitor = ConfigMonitor.getInstance();
        if (!monitor.listenerExists(new File(getDataHome()))) {
            monitor.addConfigListener(new File(getDataHome()), new ConfigListener() {
                public void configChanged(List<File> changedFiles) {
                    try {
                        SCHEDULER.scheduleLoad();
                    } catch (Exception ex) {
                        LOGGER.log(Level.SEVERE, "Could not reload data", ex);
                    }
                }
            });
        }
//        schemaRoot = context.getRealPath("config/schemas");
//        updateSchema = schemaRoot + "/entity-service-strict.xsd";
    }

    /**
     * Get date of the last update.
     * 
     * @return The date.
     */
    public static Date getLastUpdate() {
        if (lastLoad.after(lastPatch)) {
            return lastLoad;
        }
        return lastPatch;
    }

    /**
     * Get date of the last patch file made.
     * 
     * @return The date.
     */
    public static Date getLastPatchDate() {
        return lastPatch;
    }

    /**
     * Get date of the last file load.
     * 
     * @return The date.
     */
    public static Date getLastLoadDate() {
        return lastLoad;
    }

    /**
     * Retrieve the data model.
     * 
     * @return The data model.
     * @throws java.io.IOException
     *             For loading errors.
     * @throws org.xml.sax.SAXException
     *             For parsing errors.
     * @throws javax.xml.xpath.XPathExpressionException
     *             For indexing errors.
     */
    public static synchronized Document getDoc() throws IOException, SAXException,
        XPathExpressionException {
        if (data == null) {
            SCHEDULER.loadData();
        }
        return data;
    }

    /**
     * Set the raw data document.
     * 
     * @param doc
     *            The data document.
     */
    static void setData(DocumentImpl doc) {
        data = doc;
    }

    /**
     * Shutdown this manager. Should be called when the application shuts down.
     */
    public static synchronized void shutdown() {
        SCHEDULER.shutDown();
    }

    /** Info of when updates were made. */
    public static class UpdateInfo {
        private final long timestamp;
        private final String id;

        /**
         * The constructor.
         * 
         * @param timestamp
         *            When the update was made.
         * @param id
         *            The id of the entity updated.
         */
        public UpdateInfo(long timestamp, String id) {
            this.timestamp = timestamp;
            this.id = id;
        }

        /**
         * When the update was made.
         * 
         * @return When the update was made.
         */
        public long getTimestamp() {
            return timestamp;
        }

        /**
         * The id of the entity updated.
         * 
         * @return The id of the entity updated.
         */
        public String getId() {
            return id;
        }
    }

    private static final List<UpdateInfo> UPDATE_INFO = new LinkedList<UpdateInfo>();

    /**
     * Get all update info.
     * 
     * @return The list of updates.
     */
    public static synchronized List<UpdateInfo> getUpdateInfo() {
        List<UpdateInfo> results = new ArrayList<UpdateInfo>(UPDATE_INFO.size());
        results.addAll(UPDATE_INFO);
        return results;
    }

    private static final int UPDATE_INFO_CAP = 100;

    private static synchronized void logUpdate(String id) {
        UpdateInfo log = new UpdateInfo(System.currentTimeMillis(), id);
        UPDATE_INFO.add(0, log);
        while (UPDATE_INFO.size() > UPDATE_INFO_CAP) {
            UPDATE_INFO.remove(UPDATE_INFO_CAP);
        }
    }

    /**
     * Update the XML model.
     * 
     * @param updates
     *            An XML document with the updated entity xml.
     * @throws Exception
     *             For errors.
     */
    public static synchronized void update(Document updates) throws Exception {
        try {
//            try {
//                SchemaUtil.validate(updates, updateSchema);
//            } catch (Exception ex) {
//                String msg = "Update failed - " + ex + "\n";
//                msg += XmlUtil.xmlToString(updates);
//                LOGGER.log(Level.SEVERE, msg);
//                throw ex;
//            }
            update(updates, data);
            savePatch(updates);
            CacheManager.flushAll();
        } catch (Exception ex) {
            forceReload();
            throw ex;
        }
    }

    static void update(Document updates, DocumentImpl doc) throws Exception {
        Element root = updates.getDocumentElement();
        NodeList items = root.getChildNodes();
        Element[] newItems = new Element[items.getLength()];
        for (int i = 0; i < items.getLength(); i++) {
            Element item = (Element) items.item(i);
            String id = item.getAttribute("id");
            Element oldItem = doc.getElementById(id);

            doc.unindex(new Element[] { oldItem });
            Element newItem = (Element) doc.importNode(item, true);
            newItems[i] = newItem;

            String entityType = newItem.getNodeName();
            if (entityType.equals("category") || entityType.equals("option-group")) {
                NodeList childrenElements = newItem.getElementsByTagName("children");
                if (childrenElements.getLength() > 0) {
                    Node childrenElement = childrenElements.item(0);
                    NodeList children = childrenElement.getChildNodes();
                    for (int j = 0; j < children.getLength(); j++) {
                        Element childRef = (Element) children.item(j);
                        String childId = childRef.getAttribute("idref");
                        Element child = doc.getElementById(childId);
                        childrenElement.replaceChild(child, childRef);
                    }
                }
            }

            oldItem.getParentNode().replaceChild(newItem, oldItem);
            logUpdate(id);
        }
        doc.reposition();
        for (Element newItem : newItems) {
            doc.reindex(newItem);
        }
    }

    // TODO: Refactor import/export scheduler into another class.
    private static final class Scheduler extends TimerTask {
        private static final int SCHEDULER_TIMING = 100; // .1 second
        private Timer timer = new Timer("DomManager.Loader", true);
        private volatile boolean loadScheduled = false;
        private volatile boolean loading = false;

        private Scheduler() {
            timer.schedule(this, SCHEDULER_TIMING, SCHEDULER_TIMING);
        }

        private void scheduleLoad() {
            this.loadScheduled = true;
        }

        public void run() {
            try {
                if (loadScheduled && !loading) {
                    loadData();
                }
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Data load failed.", ex);
            }
        }

        public void shutDown() {
            timer.cancel();
        }

        public void loadData() throws IOException, SAXException, XPathExpressionException {
            try {
                loading = true;
                loadScheduled = false;
                long start = System.currentTimeMillis();
                XmlParser parser = new XmlParser();
                DocumentImpl doc = (DocumentImpl) parser.parse(getDataHome());
                doc.buildIndex();
                loadRecentPatches(doc);
                setData(doc);
                lastLoad = new Date();
                CacheManager.flushAll();
                long time = System.currentTimeMillis() - start;
                LOGGER.info("Loaded XML data in " + time + " ms.");
            } finally {
                loading = false;
            }
        }
    }

    private static final Scheduler SCHEDULER = new Scheduler();

    private static void forceReload() {
        SCHEDULER.scheduleLoad();
    }

    static void savePatch(Document updates) throws IOException {
        String patchFile = "patch-" + System.currentTimeMillis() + ".xml";
        // TODO: String hash to ensure uniqueness?
        // TODO: Add user info to root element for auditing
        String patchPath = getPatchHome() + patchFile;
        XmlUtil.writeXml(patchPath, updates);
        long patchTime = new File(patchPath).lastModified();
        lastPatch = new Date(patchTime);
    }

    private static void loadRecentPatches(DocumentImpl doc) {
        long docModified = new File(getDataHome()).lastModified();
        boolean deleteOld = true;
        File[] patches = FileUtil.listFiles(new File(getPatchHome()));
        long lastPatchTime = loadPatches(patches, deleteOld, docModified, doc);
        lastPatch = new Date(lastPatchTime);
    }

    private static long loadPatches(File[] patches, boolean deleteOld, long docModified,
        DocumentImpl doc) {
        Arrays.sort(patches, new Comparator<File>() {
            public int compare(File t, File t1) {
                long diff = t.lastModified() - t1.lastModified();
                if (diff < 0) {
                    return -1;
                } else if (diff == 0) {
                    return 0;
                } else {
                    return 1;
                }
            }
        });
        Date docDate = new Date(docModified);
        long lastPatchTime = 0;
        XmlParser parser = new XmlParser();
        for (File patch : patches) {
            if (patch.getName().endsWith(".xml")) {
                long patchModified = patch.lastModified();
                Date patchDate = new Date(patchModified);
                if (deleteOld && patchDate.before(docDate)) {
                    patch.delete();
                } else {
                    try {
                        Document updates = parser.parse(patch);
                        update(updates, doc);
                        if (lastPatchTime < patchModified) {
                            lastPatchTime = patchModified;
                        }
                    } catch (Exception ex) {
                        String msg = "Failure loading patch - " + patch;
                        LOGGER.log(Level.SEVERE, msg, ex);
                    }
                }
            }
        }
        return lastPatchTime;
    }

    public static String getDataRoot() {
        return dataRoot;
    }

    public static String getDataHome() {
        return getDataRoot() + "/eldarin-data.xml";
    }

    private static String getPatchHome() {
        return getDataRoot() + "/patches/";
    }

    private static void setDataRoot(String dataRoot) {
        DomManager.dataRoot = dataRoot;
    }
}
