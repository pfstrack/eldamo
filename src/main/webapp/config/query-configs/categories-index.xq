import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $pubmode external;
declare variable $lang := /*//language[@id=$id]/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Eldamo : {$lang} Semantic Categories</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>
    [<a href="../../index.html">Home</a>] »
    [<a href="../languages/index.html">Languages</a>] »
    [<a href="../language-pages/lang-{$id}.html">{$lang}</a>]
</p>
<hr/>
<h1>{$lang} Semantic Categories</h1>
<hr/>
<ul>
{
for $cat-group in /*/cats/cat-group
return (
    <li>
        <a href="#{$cat-group/@id}">
        { $cat-group/@num/string() }.
        { $cat-group/@label/string() }
        </a>
    </li>
) }
</ul>
<hr/>
{
for $cat-group in /*/cats/cat-group
return (
    <h2>
        <u>
        <a name="{$cat-group/@id}"/>
        { $cat-group/@num/string() }.
        { $cat-group/@label/string() }
        </u>
    </h2>,
    for $cat in $cat-group/cat[xdb:key(., 'category', @id)[@l=$id][c:is-word(.)]]
    return (
        <h3>
            <u>
            { $cat/@num/string() }{' '}
            { $cat/@label/string() }
            </u>
        </h3>,
        <dl> {
        for $word in $cat/xdb:key(., 'category', @id)[@l=$id][c:is-word(.)]
        order by c:normalize-for-sort($word/@v)
        return (
            <dt>
                { c:print-word($word, <control style="bold" show-link="y"/>) }
                { c:print-speech($word) }
                { c:print-gloss($word) }
            </dt>
        ) } </dl>
    )
) }
{
let $uncategorized := xdb:key(/*, 'language', $id)
    [not(starts-with(c:get-speech(.), 'phon'))]
    [not(ends-with(c:get-speech(.), 'name'))]
    [not(c:get-speech(.) = 'grammar')]
    [not(c:get-speech(.) = 'phrase')]
    [not(c:get-speech(.) = 'text')]
    [not(@cat = /*/cats/cat-group/cat/@id or @cat = '?')]
    [$pubmode != 'true']
return if (count($uncategorized) = 0) then () else (
<p><b>Uncategorized Words</b></p>,
<dl> {
for $word in $uncategorized
order by c:normalize-for-sort($word/@v)
return (
    <dt>
        { c:print-word($word, $primary-word) } <u>{ $word/@cat/string() }</u>
    </dt>
) } </dl>
) }
</body>
</html>
