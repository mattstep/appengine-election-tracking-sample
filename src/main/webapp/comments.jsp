<! DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head><title>The president is...</title></head>
    <body>
        <H1>The president is...</H1>
        <img src="romney.png" />
        <%
            String comment = request.getParameter("user-comment");
            if (comment != null)
                comment = comment.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        %>
        <p>You: <%= comment %></p>
        <form action="" method="post">
            <textarea name="user-comment" ></textarea><br/>
            <input type="submit" value="OK" />
        </form>
    </body>
</html>