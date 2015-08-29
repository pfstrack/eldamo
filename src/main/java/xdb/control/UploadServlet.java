package xdb.control;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.GZIPInputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xdb.dom.DomManager;

/**
 * Servlet to handle file uploads via HTTP POST.
 * 
 * @author Paul Strack
 */
@SuppressWarnings("serial")
public class UploadServlet extends HttpServlet {
    private static final int BUFFER_SIZE = 1024;
    private static final Logger LOGGER = Logger.getLogger(UploadServlet.class.getName());

    /**
     * Process upload.
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
        Set<String> importsAllowed = Collections.emptySet(); // TODO : Security?
        if (!importsAllowed.isEmpty()) {
            String ip = request.getRemoteAddr();
            if (!importsAllowed.contains(ip)) {
                String msg = "Invalid upload attempted from IP - " + ip;
                response.sendError(HttpServletResponse.SC_FORBIDDEN, msg);
                LOGGER.log(Level.SEVERE, msg);
                return;
            }
        }

        String uri = request.getRequestURI();
        String outFile = null;
        if (uri.endsWith("quenya-data.xml.gz")) {
            outFile = DomManager.getDataHome();
        } else {
            String msg = "Invalid file - " + uri;
            response.sendError(HttpServletResponse.SC_FORBIDDEN, msg);
            LOGGER.log(Level.WARNING, msg);
            return;
        }

        ServletInputStream sis = request.getInputStream();
        File tmp = new File(outFile + System.currentTimeMillis() + ".tmp");
        tmp.getParentFile().mkdirs();
        InputStream is;
        if (uri.endsWith(".gz")) {
            is = new GZIPInputStream(sis, BUFFER_SIZE);
        } else {
            is = new BufferedInputStream(sis);
        }

        FileOutputStream fos = new FileOutputStream(tmp);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        try {
            try {
                int b = is.read();
                while (b >= 0) {
                    bos.write(b);
                    b = is.read();
                }
            } finally {
                is.close();
                bos.close();
            }
            tmp.renameTo(new File(outFile));
        } finally {
            tmp.delete();
        }

        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        out.print("<saved>");
        out.print(outFile);
        out.print("</saved>");
    }
}
