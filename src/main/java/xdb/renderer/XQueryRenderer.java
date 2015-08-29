package xdb.renderer;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import xdb.config.QueryConfigManager;
import xdb.control.Renderer;
import xdb.dom.XQueryEngine;
import xdb.util.CollectionsUtil;
import xdb.util.FileUtil;

/**
 * XQuery-based renderer. It only renders output for the first node in the result (which should generally be the
 * document node).
 */
public class XQueryRenderer implements Renderer {
    private final String xquery;
    private final String mimeType;
    private final String outputType;

    /**
     * Initialize the renderer from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @return The renderer.
     * @throws IOException
     */
    public static XQueryRenderer init(Element configElement) throws IOException {
        String mimeType = configElement.getAttribute("mime-type");
        String xquery = configElement.getTextContent();
        String file = configElement.getAttribute("file");
        if (file != null) {
            String path = QueryConfigManager.getConfigRoot() + "/" + file;
            xquery = FileUtil.loadText(new File(path));
        }
        return new XQueryRenderer(xquery, mimeType);
    }

    /**
     * Constructor.
     * 
     * @param xquery
     *            The query.
     * @param mimeType
     *            The output mime type.
     */
    public XQueryRenderer(String xquery, String mimeType) {
        this.xquery = xquery;
        this.mimeType = mimeType;
        if (mimeType.endsWith("xml")) {
            outputType = "xml";
        } else if (mimeType.endsWith("html")) {
            outputType = "html";
        } else {
            outputType = "text";
        }
    }

    @Override
    public String getMimeType() {
        return this.mimeType;
    }

    @Override
    public void render(List<Node> results, PrintWriter out, Map<String, String[]> params) throws IOException {
        try {
            Map<String, String> flatMap = CollectionsUtil.flatten(params);
            XQueryEngine.query(results.get(0), xquery, flatMap, out, outputType);
        } catch (Exception ex) {
            throw new IOException(ex.getMessage());
        }
    }
}
