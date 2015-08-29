package xdb.query;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.control.Query;
import xdb.control.QueryException;
import xdb.dom.impl.DocumentImpl;

/**
 * An optimized query processor to retrieve entity elements using keys. It accepts a key and a list
 * of values for that key, and returns all nodes whose key value matches one of the possible keys.
 */
public class MultiKeyQuery implements Query {
    private final String key;
    private final String entityType;

    /**
     * Init the query from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @return The query.
     */
    public static MultiKeyQuery init(Element configElement) {
        String param = configElement.getAttribute("param");
        String key = configElement.getAttribute("key");
        String entityType = configElement.getAttribute("entity-type");
        return new MultiKeyQuery(param, key, entityType);
    }

    /**
     * Constructor.
     * 
     * @param param
     *            The parameter name holding the key values.
     * @param key
     *            The key name.
     * @param entityType
     *            The entity type to be retrieve, null for any entity.
     */
    public MultiKeyQuery(String param, String key, String entityType) {
        this.key = key;
        if (param == null || key == null) {
            throw new IllegalArgumentException("Must specify both param and key");
        }
        this.entityType = entityType;
    }

    @Override
    public List<Node> query(Document doc, Map<String, String[]> params) throws QueryException {
        DocumentImpl docImpl = (DocumentImpl) doc;
        List<Node> result = new LinkedList<Node>();
        String[] keys = params.get(key);
        for (String id : keys) {
            List<Node> elements = docImpl.getElementsFromKey(key, id);
            for (Node element : elements) {
                if (element != null) {
                    if (entityType != null && entityType.length() > 0) {
                        if (!entityType.equals(element.getNodeName())) {
                            continue; // Skip
                        }
                    }
                    result.add(element);
                }
            }
        }
        return result;
    }
}
