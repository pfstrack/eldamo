/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xdb.renderer;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import junit.framework.TestCase;
import org.w3c.dom.Element;

import xdb.control.Renderer;
import xdb.renderer.RendererInit;
import xdb.renderer.XQueryRenderer;
import xdb.test.TestUtil;

/**
 * 
 * @author ps142237
 */
public class XQueryRendererTest extends TestCase {

    public XQueryRendererTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        Renderer renderer = initRenderer();
        assertTrue(renderer instanceof XQueryRenderer);
    }

    public void testGetMimeType() throws Exception {
        Renderer instance = initRenderer();
        String expResult = "text/plain";
        String result = instance.getMimeType();
        assertEquals(expResult, result);
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public void testRender() throws Exception {
        String xml = "<parts>";
        xml += "<part id='1' description='Part 1' />";
        xml += "<part id='2' description='Part 2 with &quot;' />";
        xml += "</parts>";
        List results = Collections.singletonList(TestUtil.parse(xml));
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        Map<String, String[]> params = Collections.emptyMap();
        Renderer instance = initRenderer();
        instance.render(results, out, params);
        String expected = "2";
        assertEquals(expected, sw.toString());
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public void testBogusRender() throws Exception {
        String xml = "<parts>";
        xml += "<part id='1' description='Part 1' />";
        xml += "<part id='2' description='Part 2 with &quot;' />";
        xml += "</parts>";
        List results = Collections.singletonList(TestUtil.parse(xml));
        StringWriter sw = new StringWriter();
        PrintWriter out = new PrintWriter(sw);
        Map<String, String[]> params = Collections.emptyMap();
        Renderer instance = initBogusRenderer();
        try {
            instance.render(results, out, params);
            fail("Should throw an error");
        } catch (Exception ex) {
            // Expected
        }
    }

    private Renderer initRenderer() throws Exception {
        String xml = "<xquery-renderer content-type='txt' mime-type='text/plain'>count(/*/part)</xquery-renderer>";
        Element configElement = TestUtil.parse(xml).getDocumentElement();
        Renderer renderer = RendererInit.init(configElement, "test-config.xml");
        return renderer;
    }

    private Renderer initBogusRenderer() throws Exception {
        String xml = "<xquery-renderer content-type='xml' mime-type='text/plain'>not-a-function()</xquery-renderer>";
        Element configElement = TestUtil.parse(xml).getDocumentElement();
        Renderer renderer = RendererInit.init(configElement, "test-config.xml");
        return renderer;
    }
}
