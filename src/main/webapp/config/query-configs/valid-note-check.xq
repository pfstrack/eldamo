import module namespace c = "common.xq" at "common.xq";

<html>
<body>
<dl>{
for $note in //word/notes return
if ($note[contains(xdb:html(.)[1], 'ERROR')]) then (
<dt>&lt;word l="{c:get-lang($note/..)}" v="{c:print-word($note/.., <print-word show-link="y"/>)}"</dt>,
<dd>{xdb:html($note)}</dd>
) else (
    for $link in $note/xdb:html(.)//a
    let $code := $link/substring-before(substring-after(@href, 'word-'), '.html')
    let $word := xdb:key(/*, 'word-code', $code)
    return if ($code and not($word)) then (
        <dt>&lt;word l="{c:get-lang($note/..)}" v="{c:print-word($note/.., <print-word show-link="y"/>)}"</dt>,
        <dd>ERROR:BAD_LINK - {$link/text()}</dd>
    ) else ()
)}
</dl>
</body>
</html>
