package xdb.util;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * Utilities for manipulating collections.
 */
public final class CollectionsUtil {

    private CollectionsUtil() {
    }

    /**
     * Flatten a map of string arrays to a map of strings using the first item in each array.
     * 
     * @param parameterMap
     *            The map of string arrays.
     * @return A map of strings.
     */
    public static Map<String, String> flatten(Map<String, String[]> parameterMap) {
        Map<String, String> result = new TreeMap<String, String>();
        for (String key : parameterMap.keySet()) {
            result.put(key, parameterMap.get(key)[0]);
        }
        return result;
    }

    /**
     * Convert a map of string arrays to a map of string lists.
     * 
     * @param parameterMap
     *            The map of string arrays.
     * @return The map of string lists.
     */
    public static Map<String, String[]> toArrays(Map<String, List<String>> parameterMap) {
        Map<String, String[]> result = new TreeMap<String, String[]>();
        for (String key : parameterMap.keySet()) {
            List<String> list = parameterMap.get(key);
            String[] array = new String[list.size()];
            list.toArray(array);
            result.put(key, array);
        }
        return result;
    }
}
