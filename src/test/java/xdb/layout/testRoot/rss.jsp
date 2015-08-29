<%@page contentType="text/xml" pageEncoding="UTF-8"%><%
java.util.Date date = com.sun.pdb.system.SystemManager.getInstance().getLastUpdate();
response.setDateHeader("Last-Modified", date.getTime());
if ("HEAD".equals(request.getMethod().toUpperCase())) return;
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss z");
String update = sdf.format(date);
String link = "http://" + request.getServerName() + ":" + request.getServerPort() + "/pdb/";
%><?xml version="1.0"?>
<rss version="2.0">
   <channel>
      <title>PDB Updates</title>
      <link><%= link %></link>
      <pubDate><%= update %></pubDate>
      <lastBuildDate><%= update %></lastBuildDate>
      <item>
         <title>Last Update</title>
         <link><%= link %></link>
         <pubDate><%= update %></pubDate>
         <guid><%= link %>#<%= update %></guid>
      </item>
   </channel>
</rss>