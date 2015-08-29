<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="xdb.config.*,java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Supported Queries</title>
</head>
<body>
<%= QueryConfigManager.getControllerUris() %>
<%--
<div class="g15titlebar"><h5>PDB Supported Queries</h5></div>
<table border="0" cellpadding="0" cellspacing="1" width="100%" summary="PDB Supported Queries" class="vatop">
<% Set<String> uris = QueryConfigManager.getControllerUris();
String lastNamespace = null;
for (String uri : uris) {
    String aboutUri = uri.replace("*", "about");
    int lastSlash = uri.lastIndexOf('/', uri.length() - 3);
    String namespace = uri.substring(7, lastSlash);
    %>
<% if (!namespace.equals(lastNamespace)) { %>
<tr class="odd">
    <th colspan="2">"<%= namespace %>" queries</th>
</tr>
<% } %>
<tr class="odd">
    <td><nobr><a href="../<%= aboutUri.substring(1) %>"><%= uri.substring(7) %></a></nobr></td>
    <td><%= QueryConfigManager.getController(aboutUri).getDescription() %></td>
</tr>
<% 
    lastNamespace = namespace;
}
%>
--%>
</table>
</body>
</html>
