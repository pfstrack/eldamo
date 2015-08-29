/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xdb.query;

import junit.framework.TestCase;

import org.w3c.dom.Element;

import xdb.test.TestUtil;

/**
 * 
 * @author ps142237
 */
public class QueryInitTest extends TestCase {

    public QueryInitTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        String xml = "<bogus-query />";
        Element config = TestUtil.parse(xml).getDocumentElement();
        try {
            QueryInit.init(config, "test-config.xml");
            fail("Should throw exception");
        } catch (Exception ex) {
            // Expected
        }
    }

}
