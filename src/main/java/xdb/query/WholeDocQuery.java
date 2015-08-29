package xdb.query;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.control.Query;
import xdb.control.QueryException;

/**
 * A "query" that simply returns the entire document. For global XML processing such as XQuery.
 * 
 * @author ps142237
 */
public class WholeDocQuery implements Query {

    /**
     * Init the query from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @return The query.
     */
    public static WholeDocQuery init(Element configElement) {
        return new WholeDocQuery();
    }

    /** Constructor. */
    public WholeDocQuery() {
    }

    @Override
    public List<Node> query(Document doc, Map<String, String[]> params) throws QueryException {
        return Collections.singletonList((Node) doc);
    }
}
