package xdb.request;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import xdb.control.RequestParser;
import xdb.dom.DomManager;
import xdb.util.CollectionsUtil;

/**
 * Simple request parser that derives its parameters from the request parameters.
 * 
 * @author ps142237
 */
public class SimpleRequestParser implements RequestParser {
    private final Map<String, String[]> extraParams;

    /**
     * Initialize request parser from configuration.
     * 
     * @param configElement
     *            The configuration.
     * @return The request parser.
     */
    public static SimpleRequestParser init(Element configElement) {
        NodeList list = configElement.getElementsByTagName("extra-param");
        Map<String, List<String>> map = new TreeMap<String, List<String>>();
        for (int i = 0; i < list.getLength(); i++) {
            Element extraParam = (Element) list.item(i);
            String name = extraParam.getAttribute("name");
            List<String> values = map.get(name);
            if (values == null) {
                values = new LinkedList<String>();
                map.put(name, values);
            }
            String value = extraParam.getAttribute("value");
            if (value.startsWith("$DATA_ROOT/")) {
                value = DomManager.getDataRoot() + value.substring("$DATA_ROOT/".length());
            }
            values.add(value);
        }
        return new SimpleRequestParser(CollectionsUtil.toArrays(map));
    }

    /**
     * Constructor.
     * 
     * @param extraParams
     *            Extra parameters added to the request.
     */
    public SimpleRequestParser(Map<String, String[]> extraParams) {
        this.extraParams = extraParams;
    }

    /**
     * Derive content type from the URI's file extension. For example, "/directory/file.xml" would
     * have the content type "xml".
     * 
     * @param request
     *            The request.
     * @return The content type.
     */
    public String deriveContentType(HttpServletRequest request) {
        String uri = request.getRequestURI();
        if (request.getParameter("about") != null) {
            return "about";
        }
        int lastPeriod = uri.lastIndexOf('.');
        if (lastPeriod >= 0) {
            String extension = uri.substring(lastPeriod + 1);
            return extension;
        }
        return "about";
    }

    /**
     * Derive parameters from the request parameters (request.getParameterMap()).
     * 
     * @param request
     *            The request.
     * @return The parameters.
     */
    // TODO : Fix with latest servlet API
    public Map<String, String[]> deriveParameters(HttpServletRequest request) {
        Map<String, String[]> params = new TreeMap<String, String[]>();
        params.putAll(request.getParameterMap());
        for (String key : extraParams.keySet()) {
            if (!params.keySet().contains(key)) {
                params.put(key, extraParams.get(key));
            }
        }
        return params;
    }
}
