import module namespace c = "common.xq" at "common.xq";

<html>
<body>
<dl>{
for $note in //word/notes
let $html := $note/xdb:html(.)
return
if ($note[contains(xdb:html(.)[1], 'ERROR')]) then (
<dt>&lt;word l="{c:get-lang($note/..)}" v="{c:print-word($note/.., <print-word show-link="y" hide-mark="y"/>)}"</dt>,
<dd>{xdb:html($note)}</dd>
) else (
    for $link in $html//a
    let $code := $link/substring-before(substring-after(@href, 'word-'), '.html')
    let $word := xdb:key(/*, 'word-code', $code)
    return if ($code and not($word)) then (
        <dt>&lt;word l="{c:get-lang($note/..)}" v="{c:print-word($note/.., <print-word show-link="y" hide-mark="y"/>)}"</dt>,
        <dd>ERROR:BAD_LINK - &lt;a href="{$link/@href/string()}"&gt;{$link/text()}&lt;/a&gt;</dd>
    ) else ()
)}
</dl>
<script src="../../js/dark-mode.js" ></script>
</body>
</html>
