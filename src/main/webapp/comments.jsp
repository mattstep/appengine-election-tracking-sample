<! DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.*" %>

<html>
    <head><title>The president is...</title></head>
    <body>
        <H1>The president is...</H1> <img src="obama.png" />
        <%
            UserService userService = UserServiceFactory.getUserService();
            User user = userService.getCurrentUser();
            if (user == null)
            {%>
        <p>Hello, <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
            please log in</a> to post comments.</p>
        <%}
        else
        {
            String comment = request.getParameter("user-comment");
            if (comment != null)
                comment = comment.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        %>
        <p><b><%=user.getNickname()%>:</b> <%=comment%></p>

        <form action="" method="post">
            <textarea name="user-comment"></textarea><br/>
            <input type="submit" value="OK" />
            <!-- logout link -->
            <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">logout</a>
        </form>
        <% } %>
    </body>
</html>