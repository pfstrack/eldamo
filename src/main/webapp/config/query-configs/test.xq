import module namespace c = "common.xq" at "common.xq";

<html>
<body> 
<table> {
let $words := //word[@l=('ns', 's', 'n', 'en', 'g', 'nq', 'q', 'mq', 'eq')][not(see)]
    [not(contains(@mark, '-'))][not(contains(@mark, '|'))]
    [c:is-word(.)][not(@gloss='[unglossed]')][not(c:get-gloss(.) = '‽')][not(c:get-gloss(.) = '?')][not(@cat)]
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
</body>
</html>
