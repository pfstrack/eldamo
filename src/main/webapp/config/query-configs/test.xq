import module namespace c = "common.xq" at "common.xq";

<html>
<body> 
{
let $words := //word[c:get-lang(.)=('nq', 'q', 'mq', 'eq', 'ns', 's', 'n', 'en', 'g')]
let $finished := $words[notes | see-notes | see]
return (
    <p>Words: {count($words)}</p>,
    <p>Finished: {count($finished)}</p>,
    <p>Remaining: {count($words) - count($finished)}</p>
)
}

</body>
</html>
