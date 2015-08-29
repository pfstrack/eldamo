package xdb.query;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.control.Query;
import xdb.control.QueryException;

/**
 * An optimized query processor to retrieve entity elements using their ids. This query accepts
 * multiple "id" parameters and returns the list of nodes matching those ids.
 */
public class MultiIdQuery implements Query {
    private final String entityType;

    /**
     * Init the query from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @return The query.
     */
    public static MultiIdQuery init(Element configElement) {
        String entityType = configElement.getAttribute("entity-type");
        return new MultiIdQuery(entityType);
    }

    /**
     * Constructor.
     * 
     * @param entityType
     *            The entity type to be retrieve, null for any entity.
     */
    public MultiIdQuery(String entityType) {
        this.entityType = entityType;
    }

    @Override
    public List<Node> query(Document doc, Map<String, String[]> params) throws QueryException {
        List<Node> result = new LinkedList<Node>();
        String[] ids = params.get("id");
        for (String id : ids) {
            Element element = doc.getElementById(id);
            if (element != null) {
                if (entityType != null && entityType.length() > 0) {
                    if (!entityType.equals(element.getNodeName())) {
                        continue; // Skip
                    }
                }
                result.add(element);
            }
        }
        return result;
    }
}
