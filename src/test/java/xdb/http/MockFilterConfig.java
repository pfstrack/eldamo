package xdb.http;

import java.util.Enumeration;

import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;

@SuppressWarnings({"rawtypes", "unchecked"})
public class MockFilterConfig implements FilterConfig {
    final ServletContext context;

    public MockFilterConfig(ServletContext context) {
        this.context = context;
    }

    public String getFilterName() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ServletContext getServletContext() {
        return this.context;
    }

    public String getInitParameter(String name) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Enumeration getInitParameterNames() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
