package xdb.query;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import junit.framework.TestCase;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.config.ModelConfigManagerTest;
import xdb.control.Query;
import xdb.dom.impl.DocumentImpl;
import xdb.query.MultiKeyQuery;
import xdb.query.QueryInit;
import xdb.test.TestUtil;

/**
 * 
 * @author ps142237
 */
public class MultiKeyQueryTest extends TestCase {

    public MultiKeyQueryTest(String testName) {
        super(testName);
    }

    public void testInit() throws Exception {
        Query instance = initQuery();
        assertTrue(instance instanceof MultiKeyQuery);
    }

    public void testQuery() throws Exception {
        ModelConfigManagerTest.init();
        String xml = "<x><product id='1' uuid='aaa'>x</product><product id='2' uuid='bbb'>y</product><product id='3' uuid='ccc'>z</product></x>";
        DocumentImpl doc = (DocumentImpl) TestUtil.parse(xml);
        doc.buildIndex();
        String[] keys = { "aaa", "ccc" };
        Map<String, String[]> params = Collections.singletonMap("uuid", keys);
        Query instance = initQuery();
        List<Node> result = instance.query(doc, params);
        assertEquals(2, result.size());
    }

    private Query initQuery() throws Exception, IOException {
        String xml = "<multi-key-query param='uuid' key='uuid' entity-type='product' />";
        Element config = TestUtil.parse(xml).getDocumentElement();
        Query instance = QueryInit.init(config, "test-config.xml");
        return instance;
    }
}
