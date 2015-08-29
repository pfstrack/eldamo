package xdb.layout;

import xdb.layout.LayoutFilter;
import junit.framework.TestCase;

public class LayoutFilterTest extends TestCase {

    public LayoutFilterTest(String testName) {
        super(testName);
    }

    public void testGetTextBody() {
        String text = "<html><body> The body </body></html>";
        String expResult = "The body";
        String result = LayoutFilter.getTextBody(text);
        assertEquals(expResult, result);
    }

    public void testGetTextBodyWithH1() {
        String text = "<html><body> <h1>Header</h1> The body <h1>Another header</h1></body></html>";
        String expResult = "The body <h1>Another header</h1>";
        String result = LayoutFilter.getTextBody(text);
        assertEquals(expResult, result);
    }
}
