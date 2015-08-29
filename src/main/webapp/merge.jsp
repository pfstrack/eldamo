<%@page import="xdb.dom.*,xdb.util.*" %><%
String dataHome = DomManager.getDataHome();
String tmp = dataHome + ".tmp";
String server = request.getServerName();
int port = request.getServerPort();
String context = request.getContextPath();
FileUtil.pullFileFromUrl("http://" + server + ":" + port + context + "/content/sort-merge.xml", tmp);
FileUtil.moveTempFile(tmp, dataHome);
//FileUtil.moveTempFile(tmp, dataHome + ".BAK");
response.sendRedirect("index.html");
%>