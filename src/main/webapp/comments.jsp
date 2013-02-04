<! DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.me.thepresident.Comments" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>

<html>
    <head><title>The president is...</title></head>
    <body>
        <%
            MemcacheService cache = MemcacheServiceFactory.getMemcacheService();
            Entity e = DatastoreServiceFactory.getDatastoreService().prepare(new Query("Elected")).asSingleEntity();
            if (e == null) { %>
                <H1>The president is still unknown.</H1>
                <table>
                    <tr><td><img src="obama.png" /></td><td><img src="romney.png" /></td></tr>
                    <tr style="text-align: center">
                        <td><a href="/countTheVotes?name=obama">+1</a> <%=cache.get("obama")%></td>
                        <td><a href="/countTheVotes?name=romney">+1</a> <%=cache.get("romney")%></td>
                    </tr>
                </table>
         <% } else { %>
                <H1>The president is <%= e.getProperty("name") %></H1><img src="<%= e.getProperty("image") %>" />
         <% }
            UserService userService = UserServiceFactory.getUserService();
            User user = userService.getCurrentUser();
            if (user == null)
            {%>
        <p>Hello, <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
            please log in</a> to post comments.</p>
        <%}
        else
        {
            // store:
            String comment = request.getParameter("user-comment");
            if (comment != null) {
                comment = comment.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
                Comments.store(comment, user.getNickname());
            }
            // retrieve:
            List<Entity> comments = Comments.retrieveAllCached();
            for (Entity commentEntity: comments) {%>
                <p><b><%=commentEntity.getProperty("user")%></b>: <%=commentEntity.getProperty("text")%></p>
         <% } %>

        <form action="" method="post">
            <textarea name="user-comment"></textarea><br/>
            <input type="submit" value="OK" />
            <!-- logout link -->
            <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">logout</a>
        </form>
        <% } %>
    </body>
</html>