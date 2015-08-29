package xdb.control;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.w3c.dom.Document;

import xdb.dom.DomManager;
import xdb.dom.XmlParser;

/**
 * Servlet to handle updates.
 * 
 * @author Paul Strack
 */
@SuppressWarnings("serial")
public class UpdateServlet extends HttpServlet {

    /**
     * Process update.
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            XmlParser parser = new XmlParser();
            Document updates = parser.parse(request.getInputStream());

            int count = updates.getDocumentElement().getChildNodes().getLength();
            DomManager.update(updates);

            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("text/xml");
            PrintWriter out = response.getWriter();
            out.print("<updated count=\"");
            out.print(count);
            out.print("\" />");
        } catch (Exception ex) {
            sendError(response, ex);
        }
    }

    /**
     * Process update.
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
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doPost(request, response);
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
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, ex.getMessage());
    }
}
