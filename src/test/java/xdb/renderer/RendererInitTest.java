package xdb.renderer;

import junit.framework.TestCase;

import org.w3c.dom.Element;

import xdb.test.TestUtil;

public class RendererInitTest extends TestCase {

    public RendererInitTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        Element configElement = getConfigElement();
        String fileName = "test-config.xml";
        try {
            RendererInit.init(configElement, fileName);
            fail("Exception expected for bogus renderer type");
        } catch (Exception ex) {
            // Expected
        }
    }

    private Element getConfigElement() throws Exception {
        String xml = "<bogus-renderer-type />";
        return TestUtil.parse(xml).getDocumentElement();
    }
}
