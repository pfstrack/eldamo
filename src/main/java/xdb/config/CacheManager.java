package xdb.config;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Manager for an internal cache that is flushed when system data changes.
 */
@SuppressWarnings({ "rawtypes", "unchecked" })
public final class CacheManager {
    private static final Map<String, Map> MASTER_CACHE = new HashMap<String, Map>();

    private CacheManager() {
    }

    /**
     * Get a named cache.
     * 
     * @param cacheId
     *            The cache id.
     * @return The cache.
     */
    public static synchronized Map getCache(String cacheId) {
        Map cache = MASTER_CACHE.get(cacheId);
        if (cache == null) {
            cache = Collections.synchronizedMap(new HashMap());
            MASTER_CACHE.put(cacheId, cache);
        }
        return cache;
    }

    /**
     * Get a cached value.
     * 
     * @param cacheId
     *            The cache id.
     * @param key
     *            The lookup key.
     * @return The value.
     */
    public static String getCacheValue(String cacheId, String key) {
        return (String) getCache(cacheId).get(key);
    }

    /**
     * Set a cached value.
     * 
     * @param cacheId
     *            The cache id.
     * @param key
     *            The lookup key.
     * @param value
     *            The value.
     */
    public static void setCacheValue(String cacheId, String key, String value) {
        getCache(cacheId).put(key, value);
    }

    /** Flush all caches. */
    public static synchronized void flushAll() {
        MASTER_CACHE.clear();
    }
}
