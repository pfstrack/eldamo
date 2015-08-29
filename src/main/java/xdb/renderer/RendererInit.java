package xdb.renderer;

import java.io.IOException;

import org.w3c.dom.Element;

import xdb.control.Renderer;

/**
 * Class for initializing renderers from their configuration.
 */
public final class RendererInit {

    private RendererInit() {
    }

    /**
     * Init the renderer from its configuration.
     * 
     * @param configElement
     *            The configuration element.
     * @param fileName
     *            The file name.
     * @return The renderer.
     * @throws IOException
     *             For errors.
     */
    public static Renderer init(Element configElement, String fileName) throws IOException {
        if ("xquery-renderer".equals(configElement.getNodeName())) {
            return XQueryRenderer.init(configElement);
        } else if ("xsl-renderer".equals(configElement.getNodeName())) {
            return XslRenderer.init(configElement);
        } else {
            String msg = "Unknown renderer in " + fileName + " - " + configElement.getNodeName();
            throw new IllegalStateException(msg);
        }
    }
}
