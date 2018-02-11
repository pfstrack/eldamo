<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="xdb.layout.*,java.util.*" %>
<%!
List<NodeInfo> getBreadcrumb(NodeInfo node) {
    List<NodeInfo> breadcrumb = new LinkedList<NodeInfo>();
    NodeInfo parent = node.getParent();
    while(parent != null) {
        breadcrumb.add(0, parent);
        parent = parent.getParent();
    }
    return breadcrumb;
}
%>
<% NodeInfo node = (NodeInfo) request.getAttribute("page-node"); %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldarin Data : <%= node.getTitle() %></title>
</head>

<body>

<%
List<NodeInfo> breadcrumbs = getBreadcrumb(node);
if (!breadcrumbs.isEmpty()) { %>
<div id="breadcrumb">
<%
for (NodeInfo breadcrumb : breadcrumbs) {
    String label = breadcrumb.getTitle();
    String uri = breadcrumb.getUri(); %>
    <a href="<%= uri %>"><%= label %></a>&#160;&gt;
<%  } %>
</div><br />
<%  } else { %>
<div id="breadcrumb"></div><br />
<% } %>

<h1><%= node.getTitle() %></h1>

<%= request.getAttribute("page-body") %>
</body>
</html>