package com.pawconnect.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse res = (HttpServletResponse) response;
        
        // Prevent Clickjacking
        res.setHeader("X-Frame-Options", "DENY");
        // Prevent MIME-sniffing
        res.setHeader("X-Content-Type-Options", "nosniff");
        // Enable basic XSS protection in browsers
        res.setHeader("X-XSS-Protection", "1; mode=block");
        // Strict Transport Security (HSTS) - mock
        res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
