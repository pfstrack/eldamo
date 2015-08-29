package xdb.query;

import org.w3c.dom.Element;

import xdb.control.Query;

/**
 * Class for initializing queries from their configuration.
 */
public final class QueryInit {

    private QueryInit() {
    }

    /**
     * Init the query from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @param fileName
     *            The file name.
     * @return The query.
     */
    public static Query init(Element configElement, String fileName) {
        if ("xpath-query".equals(configElement.getNodeName())) {
            return XPathQuery.init(configElement);
        } else if ("multi-id-query".equals(configElement.getNodeName())) {
            return MultiIdQuery.init(configElement);
        } else if ("multi-key-query".equals(configElement.getNodeName())) {
            return MultiKeyQuery.init(configElement);
        } else if ("whole-doc-query".equals(configElement.getNodeName())) {
            return WholeDocQuery.init(configElement);
        } else {
            String msg = "Unknown query in " + fileName + " - " + configElement.getNodeName();
            throw new IllegalStateException(msg);
        }
    }
}
