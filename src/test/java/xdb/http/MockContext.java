package xdb.http;

import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Enumeration;
import java.util.EventListener;
import java.util.Map;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterRegistration;
import javax.servlet.FilterRegistration.Dynamic;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import javax.servlet.SessionCookieConfig;
import javax.servlet.SessionTrackingMode;
import javax.servlet.descriptor.JspConfigDescriptor;

@SuppressWarnings({"rawtypes", "unchecked"})
public class MockContext implements ServletContext {

    public String getContextPath() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ServletContext getContext(String uripath) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getMajorVersion() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getMinorVersion() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getMimeType(String file) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Set getResourcePaths(String path) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public URL getResource(String path) throws MalformedURLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public InputStream getResourceAsStream(String path) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public RequestDispatcher getRequestDispatcher(String path) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public RequestDispatcher getNamedDispatcher(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Servlet getServlet(String name) throws ServletException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getServlets() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getServletNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void log(String msg) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void log(Exception exception, String msg) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void log(String message, Throwable throwable) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getRealPath(String path) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getServerInfo() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getInitParameter(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getInitParameterNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Object getAttribute(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getAttributeNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setAttribute(String name, Object object) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void removeAttribute(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getServletContextName() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Dynamic addFilter(String arg0, String arg1) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Dynamic addFilter(String arg0, Filter arg1) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Dynamic addFilter(String arg0, Class<? extends Filter> arg1) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void addListener(String arg0) {
        // TODO Auto-generated method stub
        
    }

    @Override
    public <T extends EventListener> void addListener(T arg0) {
        // TODO Auto-generated method stub
        
    }

    @Override
    public void addListener(Class<? extends EventListener> arg0) {
        // TODO Auto-generated method stub
        
    }

    @Override
    public javax.servlet.ServletRegistration.Dynamic addServlet(String arg0,
            String arg1) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public javax.servlet.ServletRegistration.Dynamic addServlet(String arg0,
            Servlet arg1) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public javax.servlet.ServletRegistration.Dynamic addServlet(String arg0,
            Class<? extends Servlet> arg1) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public <T extends Filter> T createFilter(Class<T> arg0)
            throws ServletException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public <T extends EventListener> T createListener(Class<T> arg0)
            throws ServletException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public <T extends Servlet> T createServlet(Class<T> arg0)
            throws ServletException {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void declareRoles(String... arg0) {
        // TODO Auto-generated method stub
        
    }

    @Override
    public ClassLoader getClassLoader() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Set<SessionTrackingMode> getDefaultSessionTrackingModes() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public int getEffectiveMajorVersion() {
        // TODO Auto-generated method stub
        return 0;
    }

    @Override
    public int getEffectiveMinorVersion() {
        // TODO Auto-generated method stub
        return 0;
    }

    @Override
    public Set<SessionTrackingMode> getEffectiveSessionTrackingModes() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public FilterRegistration getFilterRegistration(String arg0) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Map<String, ? extends FilterRegistration> getFilterRegistrations() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public JspConfigDescriptor getJspConfigDescriptor() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public ServletRegistration getServletRegistration(String arg0) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Map<String, ? extends ServletRegistration> getServletRegistrations() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public SessionCookieConfig getSessionCookieConfig() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean setInitParameter(String arg0, String arg1) {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public void setSessionTrackingModes(Set<SessionTrackingMode> arg0) {
        // TODO Auto-generated method stub
        
    }
}
