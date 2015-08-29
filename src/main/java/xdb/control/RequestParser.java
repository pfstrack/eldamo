package xdb.control;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;

/**
 * Interface for all request parsers.
 * 
 * @author Paul Strack
 */
public interface RequestParser {

    /**
     * Derive content type (xml, html) from the URI (for example, by file extension).
     * 
     * @param request
     *            The request.
     * @return The content type.
     */
    public String deriveContentType(HttpServletRequest request);

    /**
     * Derive parameter list from the request (for example, using request parameters).
     * 
     * @param request
     *            The request.
     * @return The parameters for this request.
     */
    public Map<String, String[]> deriveParameters(HttpServletRequest request);
}
