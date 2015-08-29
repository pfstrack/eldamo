package xdb.http;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

@SuppressWarnings({ "rawtypes", "deprecation", "unchecked"})
public class MockSession implements HttpSession {
    private final Map<String, Object> data = new HashMap<String, Object>();

    public long getCreationTime() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getId() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long getLastAccessedTime() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ServletContext getServletContext() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setMaxInactiveInterval(int interval) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getMaxInactiveInterval() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public HttpSessionContext getSessionContext() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Object getAttribute(String name) {
        return data.get(name);
    }

    public Object getValue(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getAttributeNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String[] getValueNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void setAttribute(String name, Object value) {
        data.put(name, value);
    }

    public void putValue(String name, Object value) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void removeAttribute(String name) {
        data.remove(name);
    }

    public void removeValue(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void invalidate() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean isNew() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

}
