package xdb.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

/**
 * Controller for handling service requests.
 * 
 * @author Paul Strack
 */
public class Controller {

    private final String description;
    private final RequestParser requestParser;
    private final Query query;
    private final Map<String, Renderer> renderers;

    /**
     * Constructor.
     * 
     * @param description
     *            A description documenting the controller.
     * @param requestParser
     *            The request parser.
     * @param query
     *            The query.
     * @param renderers
     *            The renderers.
     */
    public Controller(String description, RequestParser requestParser, Query query,
        Map<String, Renderer> renderers) {
        this.description = description;
        this.requestParser = requestParser;
        this.query = query;
        this.renderers = renderers;
    }

    /**
     * The controller description, for documentation.
     * 
     * @return The description.
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Get the mime type being rendered.
     * 
     * @param request
     *            The request.
     * @return The mime type.
     */
    public String getMimeType(HttpServletRequest request) {
        return deriveRenderer(request).getMimeType();
    }

    /**
     * Process a request.
     * 
     * @param doc
     *            The data model.
     * @param request
     *            The request.
     * @param out
     *            The output stream.
     * @throws QueryException
     *             For query errors.
     * @throws IOException
     *             For rendering errors.
     */
    public void process(Document doc, HttpServletRequest request, PrintWriter out)
        throws QueryException, IOException {
        String contentType = requestParser.deriveContentType(request);
        Renderer renderer = renderers.get(contentType);
        if (renderer == null) {
            contentType = "about";
            renderer = renderers.get(contentType);
        }
        if ("about".equals(contentType)) {
            renderer.render(null, out, null);
        } else {
            Map<String, String[]> params = requestParser.deriveParameters(request);
            Boolean pubmode = "true".equals(request.getAttribute(PubModeFilter.PUB_MODE));
            params.put("pubmode", new String[] {pubmode.toString()});
            List<Node> results = query.query(doc, params);
            renderer.render(results, out, params);
        }
    }

    private Renderer deriveRenderer(HttpServletRequest request) {
        String contentType = requestParser.deriveContentType(request);
        Renderer renderer = renderers.get(contentType);
        if (renderer == null) {
            contentType = "about";
            renderer = renderers.get(contentType);
        }
        return renderer;
    }
}
