package xdb.request;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Arrays;
import java.util.Collections;
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
 * Request parser based on path uri-patterns.
 */
public class PathBasedRequestParser implements RequestParser {
    private final Map<String, String[]> extraParams;
    private final List<String> uriParams;

    /**
     * Initialize request parser from configuration.
     * 
     * @param configElement
     *            The configuration.
     * @return The request parser.
     */
    public static PathBasedRequestParser init(Element configElement) {
        String pattern = configElement.getAttribute("pattern");
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
            System.err.println(value);
            if (value.startsWith("$DATA_ROOT/")) {
                value = DomManager.getDataRoot() + "/" + value.substring("$DATA_ROOT/".length());
            }
            System.err.println(value);
            values.add(value);
        }
        return new PathBasedRequestParser(pattern, CollectionsUtil.toArrays(map));
    }

    /**
     * Constructor.
     * 
     * @param pattern
     *            Path pattern.
     * @param extraParams
     *            Extra parameters added to the request.
     */
    public PathBasedRequestParser(String pattern, Map<String, String[]> extraParams) {
        this.uriParams = new LinkedList<String>();
        for (String split : pattern.split("/")) {
            int length = split.length();
            uriParams.add(split.substring(1, length - 1));
        }
        Collections.reverse(uriParams);
        this.extraParams = extraParams;
    }

    /**
     * Derive content type from the {content-type} portion of the URI.
     * 
     * @param request
     *            The request.
     * @return The content type.
     */
    public String deriveContentType(HttpServletRequest request) {
        String[] contentTypes = uriToParams(request).get("content-type");
        if (contentTypes == null || contentTypes.length == 0) {
            return "about";
        } else {
            return contentTypes[0];
        }
    }

    /**
     * Derive parameters from the URI pattern. For example, if the pattern is
     * "{content-type}/{channel}/{locale}/{price-list}/{id}", the last value in the path is assign
     * to the id parameter, the 2nd-to-last to the price-list parameter and so forth. Multi-valued
     * parameters are comma-seperated, and all parameter values are UrlDecoded before being added to
     * the parameter map.
     * 
     * @param request
     *            The request.
     * @return The parameters.
     */
    // TODO : Fix with newest servlet API
    public Map<String, String[]> deriveParameters(HttpServletRequest request) {
        Map<String, String[]> params = uriToParams(request);
        params.putAll(request.getParameterMap());
        params.putAll(extraParams);
        return params;
    }

    private final Map<String, String[]> uriToParams(HttpServletRequest request) {
        Map<String, String[]> params = new TreeMap<String, String[]>();
        String uri = request.getRequestURI();
        List<String> pathElements = new LinkedList<String>();
        pathElements.addAll(Arrays.asList(uri.split("/")));
        Collections.reverse(pathElements);
        int i = 0;
        for (String pathElement : pathElements) {
            if (i < uriParams.size()) {
                String[] array = pathElement.split(",");
                for (int j = 0; j < array.length; j++) {
                    try {
                        array[j] = URLDecoder.decode(array[j], "utf-8");
                    } catch (UnsupportedEncodingException ex) {
                        // Won't happen; utf-8 always supported
                        throw new IllegalStateException(ex);
                    }
                }
                params.put(uriParams.get(i), array);
            }
            i++;
        }
        return params;
    }
}
