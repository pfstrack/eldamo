<%@page import="java.io.*,xdb.dom.*,xdb.util.*" %><%
String dataHome = DomManager.getDataHome();
String tmp = dataHome + ".tmp";
String server = request.getServerName();
int port = request.getServerPort();
String context = request.getContextPath();
FileUtil.pullFileFromUrl("http://" + server + ":" + port + context + "/content/sort.xml", tmp);
FileUtil.moveTempFile(tmp, dataHome);

String parent = new File(dataHome).getParent();
String oldFile = parent + "/eldamo-data-old.xml";
FileUtil.copyFile(dataHome, oldFile);
response.sendRedirect("index.html");
%>