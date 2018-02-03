import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $primary-word := <control style="bold" show-link="y"/>;
declare variable $secondary-word := <control show-link="y"/>;

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
<title>Eldamo : {$lang-name} Grammar</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<div id="nav-block" class="nav-block">
    [<a href="../../index.html">Home</a>] »
<span class="breadcrumb-nav">
    <a href="../languages/index.html">Languages</a> »&#160;
</span>
    <a href="../language-pages/lang-{$id}.html">{$lang-name}</a>
</div>
<hr/>
<h1>{$lang-name} Grammar</h1>
{xdb:html($lang/grammar/string())}
<hr/>
{ let $words := /*//word[@l=$id]
let $grammar := $words[c:get-speech(.)='grammar']
return c:show-hierarchy($grammar, 'grammar', 'Grammar') }
</body>
</html>
