package xdb.layout;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

/**
 * Response wrapper that buffers output. It is used by the layout filter to buffer the page's
 * "main content", so that it can wrap this in the page layout.
 */
public class BufferedResponseWrapper extends HttpServletResponseWrapper {
    private final ByteArrayOutputStream baos = new ByteArrayOutputStream();

    private final ServletOutputStream sos = new ServletOutputStream() {

        @Override
        public void write(int b) throws IOException {
            baos.write(b);
        }
    };

    private final OutputStreamWriter osw;
    private final PrintWriter writer;

    /**
     * Constructor.
     * 
     * @param response
     *            The original response.
     * @throws UnsupportedEncodingException
     *             For errors.
     */
    public BufferedResponseWrapper(HttpServletResponse response)
        throws UnsupportedEncodingException {
        super(response);
        osw = new OutputStreamWriter(baos, "utf-8");
        writer = new PrintWriter(osw);
    }

    /**
     * Returns the buffer instead of the original writer.
     * 
     * @return The buffer.
     */
    @Override
    public PrintWriter getWriter() {
        return this.writer;
    }

    /**
     * Returns the buffer instead of the original output stream.
     * 
     * @return The buffer.
     */
    @Override
    public ServletOutputStream getOutputStream() {
        return sos;
    }

    /**
     * Method to retrieve the buffer.
     * 
     * @return The buffered text, as string.
     * @throws IOException
     *             For errors.
     */
    public String getBuffer() throws IOException {
        writer.flush();
        sos.flush();
        return new String(baos.toByteArray(), "utf-8");
    }
}
