package xdb.http;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.AsyncContext;
import javax.servlet.DispatcherType;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@SuppressWarnings("rawtypes")
public class MockRequest implements HttpServletRequest {
    public final List<Cookie> cookies = new LinkedList<Cookie>();
    private final String uri;
    private final Map<String, String[]> params;
    private final String host = "http://localhost";
    private final MockSession session = new MockSession();

    public MockRequest() {
        this("uri", null);
    }

    public MockRequest(String uri, Map<String, String[]> params) {
        this.uri = uri;
        if (params == null) {
            this.params = Collections.emptyMap();
        } else {
            this.params = params;
        }
    }

    public String getAuthType() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Cookie[] getCookies() {
        Cookie[] array = new Cookie[cookies.size()];
        cookies.toArray(array);
        return array;
    }

    public long getDateHeader(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getHeader(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getHeaders(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getHeaderNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getIntHeader(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getMethod() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getPathInfo() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getPathTranslated() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getContextPath() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getQueryString() {
        StringBuffer query = new StringBuffer();
        for (String name : params.keySet()) {
            for (String value : params.get(name)) {
                query.append(name);
                query.append('=');
                try {
                    query.append(URLEncoder.encode(value, "utf-8"));
                } catch (UnsupportedEncodingException ex) {
                    // Won't happen
                }
                query.append('&');
            }
        }
        query.setLength(query.length() - 1);
        return query.toString();
    }

    public String getRemoteUser() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isUserInRole(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Principal getUserPrincipal() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getRequestedSessionId() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getRequestURI() {
        return this.uri;
    }

    public StringBuffer getRequestURL() {
        return new StringBuffer(host + uri);
    }

    public String getServletPath() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public HttpSession getSession(boolean arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public HttpSession getSession() {
        return session;
    }

    public boolean isRequestedSessionIdValid() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isRequestedSessionIdFromCookie() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isRequestedSessionIdFromURL() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isRequestedSessionIdFromUrl() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Object getAttribute(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getAttributeNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getCharacterEncoding() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setCharacterEncoding(String arg0) throws UnsupportedEncodingException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getContentLength() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getContentType() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ServletInputStream getInputStream() throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getParameter(String name) {
        String[] array = this.params.get(name);
        if (array == null || array.length == 0) {
            return null;
        }
        return array[0];
    }

    public Enumeration getParameterNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String[] getParameterValues(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Map getParameterMap() {
        return this.params;
    }

    public String getProtocol() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getScheme() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getServerName() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getServerPort() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public BufferedReader getReader() throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getRemoteAddr() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getRemoteHost() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setAttribute(String arg0, Object arg1) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void removeAttribute(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Locale getLocale() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getLocales() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isSecure() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public RequestDispatcher getRequestDispatcher(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getRealPath(String arg0) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getRemotePort() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getLocalName() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getLocalAddr() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getLocalPort() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public AsyncContext getAsyncContext() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public DispatcherType getDispatcherType() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public ServletContext getServletContext() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean isAsyncStarted() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public boolean isAsyncSupported() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public AsyncContext startAsync() throws IllegalStateException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public AsyncContext startAsync(ServletRequest arg0, ServletResponse arg1)
            throws IllegalStateException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean authenticate(HttpServletResponse arg0) throws IOException,
            ServletException {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public Part getPart(String arg0) throws IOException, ServletException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Collection<Part> getParts() throws IOException, ServletException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void login(String arg0, String arg1) throws ServletException {
        // TODO Auto-generated method stub
        
    }

    @Override
    public void logout() throws ServletException {
        // TODO Auto-generated method stub
        
    }
}
