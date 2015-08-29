package xdb.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Document;

import xdb.config.ConfigMonitor;
import xdb.config.ModelConfigManager;
import xdb.config.QueryConfigManager;
import xdb.dom.DomManager;
import xdb.layout.NodeInfoManager;
import xdb.util.XmlUtil;

/**
 * Dispatcher for service queries.
 * 
 * @author Paul Strack
 */
@SuppressWarnings("serial")
public class DispatchServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DispatchServlet.class.getName());
    private int contextLength = 0;

    /**
     * Init components that depend on the servlet context.
     * 
     * @throws javax.servlet.ServletException
     *             For errors.
     */
    @Override
    public void init() throws ServletException {
        try {
            ServletContext context = getServletContext();
            contextLength = context.getContextPath().length();
            QueryConfigManager.init(context);
            ModelConfigManager.init(context);
            DomManager.init(context);
            NodeInfoManager.init(context.getContextPath(), context.getRealPath("/"));
            String noAutoload = ConfigMonitor.getMonitorProperties().get("NO_AUTOLOAD");
            if (!"true".equals(noAutoload)) {
                DomManager.getDoc(); // Prompt load
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "DispatchServlet failed to init", ex);
        }
    }

    @Override
    public void destroy() {
        DomManager.shutdown();
        ConfigMonitor.getInstance().shutdown();
    }

    /**
     * Process request by dispatching to an appropriate controller.
     * 
     * @param request
     *            The request.
     * @param response
     *            The response.
     * @throws javax.servlet.ServletException
     *             For errors.
     * @throws java.io.IOException
     *             For errors.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String uri = request.getRequestURI();
            uri = uri.substring(contextLength);
            Controller controller = QueryConfigManager.getController(uri);
            if (controller == null) {
                sendClientError(response, "No query for uri - " + uri);
                return;
            }
            Document doc = DomManager.getDoc();
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType(controller.getMimeType(request));
            Date date = DomManager.getLastUpdate();
            response.setDateHeader("Last-Modified", date.getTime());
            setCommonHeaders(response);
            if ("HEAD".equals(request.getMethod().toUpperCase())) {
                return;
            }
            PrintWriter out = response.getWriter();
            controller.process(doc, request, out);
        } catch (Exception ex) {
            sendError(response, ex);
        }
    }

    /**
     * Simply invokes doGet().
     * 
     * @param request
     *            The request.
     * @param response
     *            The response.
     * @throws javax.servlet.ServletException
     *             For errors.
     * @throws java.io.IOException
     *             For errors.
     */
    @Override
    protected void doHead(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Send error message.
     * 
     * @param response
     *            The response.
     * @param ex
     *            The error.
     * @throws java.io.IOException
     *             For errors writing the response.
     */
    private void sendError(HttpServletResponse response, Exception ex) throws IOException {
        ex.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("text/xml");
        setCommonHeaders(response);
        PrintWriter out = response.getWriter();
        out.print("<error type=\"");
        XmlUtil.writeCharacters(out, ex.getClass().getSimpleName());
        out.print("\">");
        String msg = ex.getMessage();
        if (msg != null) {
            XmlUtil.writeCharacters(out, msg);
        }
        out.print("</error>");
    }

    /**
     * Send error message.
     * 
     * @param response
     *            The response.
     * @param message
     *            The error message.
     * @throws java.io.IOException
     *             For errors writing the response.
     */
    private void sendClientError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/xml");
        setCommonHeaders(response);
        PrintWriter out = response.getWriter();
        out.print("<error type=\"BadRequest\">");
        XmlUtil.writeCharacters(out, message);
        out.print("</error>");
    }

    private void setCommonHeaders(HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
