/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xdb.http;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

public class MockResponse implements HttpServletResponse {
    public final List<Cookie> cookies = new LinkedList<Cookie>();

    public void addCookie(Cookie cookie) {
        cookies.add(cookie);
    }

    public boolean containsHeader(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String encodeURL(String url) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String encodeRedirectURL(String url) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String encodeUrl(String url) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String encodeRedirectUrl(String url) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void sendError(int sc, String msg) throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void sendError(int sc) throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String redirectUrl;

    public void sendRedirect(String location) throws IOException {
        redirectUrl = location;
    }

    public void setDateHeader(String name, long date) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void addDateHeader(String name, long date) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setHeader(String name, String value) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void addHeader(String name, String value) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setIntHeader(String name, int value) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void addIntHeader(String name, int value) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setStatus(int sc) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setStatus(int sc, String sm) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getCharacterEncoding() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getContentType() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ServletOutputStream getOutputStream() throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public PrintWriter getWriter() throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setCharacterEncoding(String charset) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setContentLength(int len) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setContentType(String type) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setBufferSize(int size) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getBufferSize() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void flushBuffer() throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void resetBuffer() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isCommitted() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void reset() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setLocale(Locale loc) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Locale getLocale() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getStatus() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getHeader(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Collection<String> getHeaders(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Collection<String> getHeaderNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void setContentLengthLong(long len) {

    }
}
