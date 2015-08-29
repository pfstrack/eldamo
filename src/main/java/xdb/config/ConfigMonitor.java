package xdb.config;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;

import xdb.util.FileUtil;

/**
 * Class for monitoring configuration files and notifying when config directory contents have changed. Listeners can be
 * added to the monitor to watch for configuration file changes.
 * 
 * @author Paul Strack
 */
public class ConfigMonitor {
    /** The configuration value for the check frequency. */
    public static final String CHECK_FREQUENCY = "ConfigMonitor.checkFrequency";
    private static final String PROP_FILE = "/ConfigMonitor.properties";
    private static final Map<String, String> MONITOR_PROPS = loadMonitorProperties();
    private static final ConfigMonitor SINGLETON = new ConfigMonitor();
    private static final Object ADD_REMOVE_LOCK = new Object();
    private final Timer timer = new Timer("ConfigMonitor", true);
    // Volatile for thread-safety
    private volatile Map<File, ConfigListener> listenerMap = new HashMap<File, ConfigListener>();
    private Map<File, Long> fileTimestamps = new ConcurrentHashMap<File, Long>();
    private Map<File, File[]> fileLists = new ConcurrentHashMap<File, File[]>();

    /**
     * Get the configuration monitor, a singleton.
     * 
     * @return The configuration monitor.
     */
    public static ConfigMonitor getInstance() {
        return SINGLETON;
    }

    /**
     * Get the configuration data for the ConfigMonitor.
     * 
     * @return The configuration data.
     */
    public static Map<String, String> getMonitorProperties() {
        return MONITOR_PROPS;
    }

    @SuppressWarnings("unchecked")
    private static Map<String, String> loadMonitorProperties() {
        Properties props = new Properties();
        InputStream in = ConfigMonitor.class.getResourceAsStream(PROP_FILE);
        try {
            try {
                props.load(in);
            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException ex) {
            throw new IllegalStateException("Could not load " + PROP_FILE, ex);
        }
        @SuppressWarnings("rawtypes")
        Map unmodifiable = Collections.unmodifiableMap(props);
        return (Map<String, String>) unmodifiable;
    }

    private ConfigMonitor() {
        this(getMonitorProperties());
    }

    /** Package-level access for testing. */
    ConfigMonitor(Map<String, String> config) {
        long checkFrequency = Long.parseLong(config.get("ConfigMonitor.checkFrequency"));
        timer.schedule(new MonitorTask(), 0, checkFrequency);
    }

    /**
     * Add a listener. Only one listener can monitor a given file or directory. If you add another listener for the same
     * file/directory, it replaces the old lister. If the item monitored is a file, the listener is notified when the
     * file timestamp changes. If the item monitored is a directory, the listener is notified of file changes inside
     * that directory, including file additions, file deletions and file timestamp changes. The monitor does not monitor
     * files in any subdirectories, though.
     * 
     * @param monitored
     *            The monitored file or directory.
     * @param listener
     *            The listener.
     */
    public void addConfigListener(File monitored, ConfigListener listener) {
        synchronized (ADD_REMOVE_LOCK) {
            if (listener == null || monitored == null) {
                String msg = "Listener and monitored directory cannot be null.";
                throw new IllegalArgumentException(msg);
            }
            Map<File, ConfigListener> newMap = copyListenerMap();
            newMap.put(monitored, listener);
            setListenerMap(newMap);
            saveMonitoredState(monitored);
        }
    }

    /**
     * Remove a listener.
     * 
     * @param monitored
     *            The monitored file or directory.
     */
    public void removeConfigListener(File monitored) {
        synchronized (ADD_REMOVE_LOCK) {
            Map<File, ConfigListener> newMap = copyListenerMap();
            newMap.remove(monitored);
            this.setListenerMap(newMap);
        }
    }

    /** Remove all listeners. */
    public void removeAllListeners() {
        synchronized (ADD_REMOVE_LOCK) {
            this.setListenerMap(new HashMap<File, ConfigListener>());
        }
    }

    /**
     * Determine if a listener exists for a file or directory. There may be only one listener for a given location.
     * 
     * @param monitored
     *            The monitored file or directory.
     * @return Whether a listener exists for that location.
     */
    public boolean listenerExists(File monitored) {
        return getListenerMap().containsKey(monitored);
    }

    /** Shut down monitoring. Should be called when the app is unloaded. */
    public void shutdown() {
        timer.cancel();
    }

    /**
     * Utility method for copying the listener map, to facilitate synchronous updates. The code "changes" the listener
     * map by creating a copy, updating the copy and replacing the original. This allows the original map to stay in use
     * while the copy is being updated.
     */
    private Map<File, ConfigListener> copyListenerMap() {
        Map<File, ConfigListener> newMap = new HashMap<File, ConfigListener>();
        newMap.putAll(getListenerMap());
        return newMap;
    }

    private Map<File, ConfigListener> getListenerMap() {
        return listenerMap;
    }

    private void setListenerMap(Map<File, ConfigListener> listenerMap) {
        this.listenerMap = listenerMap;
    }

    private void saveMonitoredState(File monitored) {
        File[] files = new File[] { monitored };
        if (monitored.isDirectory()) {
            files = FileUtil.listFiles(monitored);
            fileLists.put(monitored, files);
        } else if (!monitored.exists()) {
            files = new File[0];
            fileLists.put(monitored, files);
        }
        for (int i = 0; i < files.length; i++) {
            File file = files[i];
            if (file.isFile()) {
                fileTimestamps.put(file, file.lastModified());
            }
        }
    }

    private List<File> getChangedFiles(File monitored) {
        List<File> changedFiles = new LinkedList<File>();
        File[] files = new File[] { monitored };
        if (monitored.isDirectory()) {
            files = FileUtil.listFiles(monitored);
            File[] oldFilesArray = fileLists.get(monitored);

            List<File> newFiles = makeList(files);
            if (oldFilesArray != null) {
                newFiles.removeAll(Arrays.asList(oldFilesArray));
            }
            changedFiles.addAll(newFiles);

            List<File> removedFiles = makeList(oldFilesArray);
            removedFiles.removeAll(Arrays.asList(files));
            changedFiles.addAll(removedFiles);
        } else if (!monitored.exists()) {
            files = new File[0];
        }
        for (int i = 0; i < files.length; i++) {
            File file = files[i];
            if (changedFiles.contains(file)) {
                continue;
            }
            Long oldTimestamp = fileTimestamps.get(file);
            if (oldTimestamp == null || oldTimestamp < file.lastModified()) {
                changedFiles.add(file);
            }
        }
        return changedFiles;
    }

    private List<File> makeList(File[] files) {
        if (files == null) {
            files = new File[0];
        }
        List<File> list = new LinkedList<File>();
        list.addAll(Arrays.asList(files));
        return list;
    }

    private class MonitorTask extends TimerTask {

        @Override
        public void run() {
            Map<File, ConfigListener> map = getListenerMap();
            for (File monitored : map.keySet()) {
                List<File> changedFiles = getChangedFiles(monitored);
                if (!changedFiles.isEmpty()) {
                    saveMonitoredState(monitored);
                    ConfigListener listener = map.get(monitored);
                    listener.configChanged(changedFiles);
                }
            }
        }
    }
}
