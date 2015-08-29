package xdb.control;

import java.util.List;
import java.util.Map;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 * Interface for query definitions.
 * 
 * @author Paul Strack
 */
public interface Query {

    /**
     * Execute the query.
     * 
     * @param doc
     *            The document being queried.
     * @param params
     *            Query parameters.
     * @return The list of nodes in the results.
     * @throws xdb.control.QueryException
     *             For errors.
     */
    public List<Node> query(Document doc, Map<String, String[]> params) throws QueryException;
}
