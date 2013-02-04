<%@ page import="com.google.apphosting.api.ApiProxy" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Starter Application Page</title>
</head>
<body>
    <p>Welcome to <%= ApiProxy.getCurrentEnvironment().getAppId() %>, There isn't anything running here yet.</p>
</body>
</html>