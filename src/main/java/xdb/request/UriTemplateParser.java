package xdb.request;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
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
 * Request parser based on path uri-templates.
 */
public class UriTemplateParser implements RequestParser {
    private final Map<String, String[]> extraParams;
    private final List<String> templates;
    private final List<String> paramNames;

    /**
     * Initialize request parser from configuration.
     * 
     * @param configElement
     *            The configuration.
     * @return The request parser.
     */
    public static UriTemplateParser init(Element configElement) {
        String template = configElement.getAttribute("template");
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
        return new UriTemplateParser(template, CollectionsUtil.toArrays(map));
    }

    /**
     * Constructor.
     * 
     * @param template
     *            The uri template.
     * @param extraParams
     *            Extra parameters added to the request.
     */
    public UriTemplateParser(String template, Map<String, String[]> extraParams) {
        this.templates = new LinkedList<String>();
        this.paramNames = new LinkedList<String>();
        for (String split : template.split("\\{")) {
            if (split.contains("}")) {
                String[] subsplit = split.split("\\}");
                paramNames.add(subsplit[0]);
                if (subsplit.length > 1) {
                    templates.add(subsplit[1]);
                }
            } else {
                templates.add(split);
            }
        }
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
        String uri = request.getRequestURI();
        if (uri.endsWith("about")) {
            return "about";
        }
        String[] contentTypes = uriToParams(request).get("content-type");
        return contentTypes[0];
    }

    /**
     * Derive parameters from the URI template. For example, if the template is
     * "{content-type}/{channel}/{locale}/{price-list}/{id}", the last value in the path is assign
     * to the id parameter, the 2nd-to-last to the price-list parameter and so forth. Multi-valued
     * parameters are comma-seperated, and all parameter values are UrlDecoded before being added to
     * the parameter map.
     * 
     * @param request
     *            The request.
     * @return The parameters.
     */
    public Map<String, String[]> deriveParameters(HttpServletRequest request) {
        Map<String, String[]> params = uriToParams(request);
        params.putAll(request.getParameterMap());
        params.putAll(extraParams);
        return params;
    }

    private final Map<String, String[]> uriToParams(HttpServletRequest request) {
        Map<String, String[]> params = new TreeMap<String, String[]>();
        String uri = request.getRequestURI();
        String firstTemplate = templates.get(0);
        int pos = uri.indexOf(firstTemplate) + firstTemplate.length();
        int i = 1;
        for (String paramName : paramNames) {
            String value = "";
            if (i >= templates.size()) {
                value = uri.substring(pos);
            } else {
                String nextTemplate = templates.get(i);
                int nextPos = uri.indexOf(nextTemplate, pos + 1);
                value = uri.substring(pos, nextPos);
                pos = nextPos + nextTemplate.length();
            }
            try {
                value = URLDecoder.decode(value, "utf-8");
            } catch (UnsupportedEncodingException ex) {
                // Won't happen; utf-8 always supported
                throw new IllegalStateException(ex);
            }
            String[] array = { value };
            params.put(paramName, array);
            i++;
        }
        return params;
    }
}
