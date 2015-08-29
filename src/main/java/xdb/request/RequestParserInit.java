package xdb.request;

import org.w3c.dom.Element;

import xdb.control.RequestParser;

/**
 * Class for initializing request parsers from their configurations.
 */
public final class RequestParserInit {

    private RequestParserInit() {
    }

    /**
     * Initialize request parser from configuration.
     * 
     * @param configElement
     *            The configuration.
     * @param fileName
     *            The name of the configuration file.
     * @return The request parser.
     */
    public static RequestParser init(Element configElement, String fileName) {
        if ("simple-request-parser".equals(configElement.getNodeName())) {
            return SimpleRequestParser.init(configElement);
        } else if ("path-based-request-parser".equals(configElement.getNodeName())) {
            return PathBasedRequestParser.init(configElement);
        } else if ("uri-template-parser".equals(configElement.getNodeName())) {
            return UriTemplateParser.init(configElement);
        } else {
            String msg = "Unknown request parser in " + fileName + " - "
                + configElement.getNodeName();
            throw new IllegalStateException(msg);
        }
    }
}
