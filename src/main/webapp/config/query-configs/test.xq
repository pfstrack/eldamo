import module namespace c = "common.xq" at "common.xq";

<html>
<body> 
<table> {
let $refs := //ref[count(deriv) gt 1]
for $ref in $refs
order by c:normalize-for-sort($ref/@v)
return
    <tr>
        <td>{ c:get-lang($ref) }</td>
        <td>{ $ref/@v/string() }</td>
        <td>{ $ref/@source/string() }</td>
    </tr>
} </table>
<table> {
let $words := //word[count(deriv) gt 1]
for $word in $words
order by c:normalize-for-sort($word/@v), $word/@l
return
    <tr>
        <td>{ c:get-lang($word) }</td>
        <td>{ $word/@v/string() }</td>
        <td>{ c:get-speech($word) }</td>
        <td>{ c:get-gloss($word) }</td>
    </tr>
} </table>
<script src="../../js/dark-mode.js" ></script>
</body>
</html>
