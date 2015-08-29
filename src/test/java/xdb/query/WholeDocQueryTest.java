/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xdb.query;

import java.util.Collections;
import java.util.List;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.control.Query;
import xdb.query.QueryInit;
import xdb.query.WholeDocQuery;
import xdb.test.TestUtil;

/**
 * 
 * @author ps142237
 */
public class WholeDocQueryTest extends TestCase {

    public WholeDocQueryTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        String xml = "<whole-doc-query />";
        Element config = TestUtil.parse(xml).getDocumentElement();
        Query instance = QueryInit.init(config, "test-config.xml");
        assertTrue(instance instanceof WholeDocQuery);
    }

    public void testQuery() throws Exception {
        String xml = "<x><a id='1'/><a id='2'/><a id='3'/><b id='4'/><b id='5'/></x>";
        Document doc = TestUtil.parse(xml);
        WholeDocQuery instance = new WholeDocQuery();
        List<Document> expResult = Collections.singletonList(doc);
        List<Node> result = instance.query(doc, null);
        assertEquals(expResult, result);
    }
}
