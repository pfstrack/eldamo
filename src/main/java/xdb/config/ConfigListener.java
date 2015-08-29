package xdb.config;

import java.io.File;
import java.util.List;

/**
 * Interface for listeners to configuration change events. They should be registered with the
 * ConfigMonitor.addConfigListener() method. Because the config updates will be executed from a
 * different thread, the listener or its delegate is responsible for synchronizing configuration
 * reinitialization.
 * 
 * @author Paul Strack
 */
public interface ConfigListener {

    /**
     * Invoked when configuration files in the monitored file or directory is updated.
     * 
     * @param changedFiles
     *            The updated files. The changed could be a file addition, removal or timestamp
     *            change.
     */
    public void configChanged(List<File> changedFiles);
}
