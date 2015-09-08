package xdb.control;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class PubModeFilter implements Filter {

    public static final String PUB_MODE = "PUB_MODE";

    @Override
    public void init(FilterConfig config) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res,
            FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        
        String uri = request.getRequestURI();
        if (uri.contains("/pub/")) {
            uri = uri.substring(4 + request.getContextPath().length());
            request.setAttribute(PUB_MODE, "true");
            RequestDispatcher dispatcher = request.getRequestDispatcher(uri);
            dispatcher.forward(req, res);
        } else {
            chain.doFilter(req, res);
        }
    }

    @Override
    public void destroy() {
    }
}
