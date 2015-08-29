package xdb.layout;

import java.io.File;
import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xdb.util.FileUtil;

/**
 * A filter to manage page layout. It buffers the output of the original request and wraps that text
 * with the page layout. Only pages that appear within the NodeInfoManager will be filtered and laid
 * out.
 */
public class LayoutFilter implements Filter {
    private ServletContext servletContext;
    private int contextLength;

    /**
     * Initialize.
     * 
     * @param config
     *            The config.
     */
    public void init(FilterConfig config) {
        servletContext = config.getServletContext();
        String contextPath = servletContext.getContextPath();
        contextLength = contextPath.length();
    }

    /**
     * Do filtering.
     * 
     * @param req
     *            The request.
     * @param res
     *            The response.
     * @param chain
     *            The filter chain.
     * @throws IOException
     *             For errors.
     * @throws ServletException
     *             For errors.
     */
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
        throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        NodeInfo node = findNode(uri);
        if (node == null) {
            chain.doFilter(req, res);
            return;
        }
        uri = node.getUri();
        String text = getText(node, request, response, chain);
        if (request.getAttribute("no-layout") != null) {
            res.getWriter().print(text);
            return;
        }
        String body = getTextBody(text);
        request.setAttribute("page-body", body);
        request.setAttribute("page-node", node);
        RequestDispatcher rd = request.getRequestDispatcher("/layout/layout.jsp");
        rd.forward(request, response);
    }

    /** Destroy. */
    public void destroy() {
        // Do nothing
    }

    static String getTextBody(String text) {
        String bodyElement = "<body>";
        int bodyElementLength = bodyElement.length();
        int startBody = text.indexOf(bodyElement);
        int endBody = text.indexOf("</body>");
        if (!(startBody >= 0 && endBody > startBody + bodyElementLength)) {
            return "";
        }
        text = text.substring(startBody + bodyElementLength, endBody);
        text = text.trim();
        if (text.startsWith("<h1>")) {
            String endH1Element = "</h1>";
            int endH1 = text.indexOf(endH1Element);
            text = text.substring(endH1 + endH1Element.length());
            text = text.trim();
        }
        return text;
    }

    private NodeInfo findNode(String uri) {
        NodeInfoManager nim = NodeInfoManager.getInstance();
        NodeInfo node = nim.getNode(uri);
        if (node == null && uri.endsWith("/")) {
            node = nim.getNode(uri + "index.html");
            if (node == null) {
                node = nim.getNode(uri + "index.jsp");
            }
        }
        return node;
    }

    private String getText(NodeInfo node, ServletRequest req, HttpServletResponse response,
        FilterChain chain) throws IOException, ServletException {
        String uri = node.getUri();
        String text = "";
        if (uri.endsWith(".jsp")) {
            BufferedResponseWrapper brw = new BufferedResponseWrapper(response);
            chain.doFilter(req, brw);
            text = brw.getBuffer();
        } else if (uri.endsWith(".html")) {
            String shortUri = uri.substring(contextLength);
            String realPath = servletContext.getRealPath(shortUri);
            text = FileUtil.loadText(new File(realPath));
        }
        return text;
    }
}
