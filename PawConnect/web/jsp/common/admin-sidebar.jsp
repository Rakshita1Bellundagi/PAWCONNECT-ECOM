<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminFootCtx = request.getContextPath();
%>
        </main>
    </div>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="<%= adminFootCtx %>/js/modal.js?v=<%= System.currentTimeMillis() %>"></script>
    <script src="<%= adminFootCtx %>/js/admin.js?v=<%= System.currentTimeMillis() %>"></script>
    <script>
        AOS.init({
            duration: 800,
            once: true,
            offset: 50
        });
    </script>
</body>
</html>
