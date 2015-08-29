package xdb.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import junit.framework.TestCase;

public class CollectionsUtilTest extends TestCase {

    public CollectionsUtilTest(String testName) {
        super(testName);
    }

    public void testFlatten() {
        String[] a = { "a1", "a2" };
        Map<String, String[]> parameterMap = Collections.singletonMap("a", a);
        Map<String, String> expResult = Collections.singletonMap("a", a[0]);
        Map<String, String> result = CollectionsUtil.flatten(parameterMap);
        assertEquals(expResult, result);
    }

    public void testToArrays() {
        String[] a = { "a1", "a2" };
        List<String> list = Arrays.asList(a);
        Map<String, List<String>> parameterMap = Collections.singletonMap("a", list);
        Map<String, String[]> result = CollectionsUtil.toArrays(parameterMap);
        assertTrue(Arrays.deepEquals(a, result.get("a")));
    }
}
