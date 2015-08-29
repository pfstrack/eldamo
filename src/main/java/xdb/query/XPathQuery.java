package xdb.query;

import java.util.List;
import java.util.Map;
import javax.xml.xpath.XPathExpressionException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.control.Query;
import xdb.control.QueryException;
import xdb.dom.XPathEngine;
import xdb.util.CollectionsUtil;

/**
 * A query processor that uses an XPath to derive a list of nodes from the XML data model.
 */
public class XPathQuery implements Query {
    private final String xpath;

    /**
     * Init the query from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @return The query.
     */
    public static XPathQuery init(Element configElement) {
        String xpath = configElement.getAttribute("xpath");
        return new XPathQuery(xpath);
    }

    /**
     * Constructor.
     * 
     * @param xpath
     *            The xpath.
     */
    public XPathQuery(String xpath) {
        this.xpath = xpath;
    }

    @Override
    public List<Node> query(Document doc, Map<String, String[]> params) throws QueryException {
        try {
            return XPathEngine.query(doc, xpath, CollectionsUtil.flatten(params));
        } catch (XPathExpressionException ex) {
            throw new QueryException(ex.getMessage(), ex);
        }
    }
}
