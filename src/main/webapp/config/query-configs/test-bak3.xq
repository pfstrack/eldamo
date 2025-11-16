import module namespace c = "common.xq" at "common.xq";

<html>
<body> 
<table> {
for $cat in //cat
return
    <tr>
        <td>{ $cat/@id/string() }</td>
        <td>{ $cat/@num/string() }</td>
        <td>{ $cat/@label/string() }</td>
    </tr>
} </table>
<script src="../../js/dark-mode.js" ></script>
</body>
</html>
