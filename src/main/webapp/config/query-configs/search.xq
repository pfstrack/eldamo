import module namespace c = "common.xq" at "common.xq";

declare function local:lang-order($lang as xs:string) as xs:string {
    if ($lang = 'q') then (
       '0'
    ) else if ($lang = 's') then (
       '1'
    ) else if ($lang = 'mq') then (
       '2'
    ) else if ($lang = 'n') then (
       '3'
    ) else if ($lang = 'en') then (
       '4'
    ) else if ($lang = 'eq') then (
       '5'
    ) else if ($lang = 'g') then (
       '6'
    ) else if ($lang = 'p') then (
       '7'
    ) else if ($lang = 'mp') then (
       '8'
    ) else if ($lang = 'ep') then (
       '9'
    ) else (
       $lang
    )
    
};

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
    <meta http-equiv="Content-Style-Type" content="text/css"></meta>
    <title>Eldamo : Search</title>
    <link rel="stylesheet" type="text/css" href="../../css/global.css"></link>
</head>
<script src="search-index.js"></script>
<script src="../../js/search.js"></script>
<body onload="initSearch()">
<p>[<a href="../../index.html">Home</a>]</p>
<hr />
<p>
    <b>Search:</b>&#160;&#160;<input id="searchBox" value="" onkeyup="doSearch()" /> &#160;|
    &#160;<select id="langSelect" onchange="doSearch()">
        <option value="">All Languages</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="eq|mq|q">All Quenya</option>
        <option value="g|n|en|s">Sindarin/Noldorin/Gnomish</option>
        <option value="p|mp|ep">All Primitive Elvish</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="q|s|p">All Late Elvish</option>
        <option value="mq|n|mp">All Middle Elvish</option>
        <option value="eq|en|g|ep">All Early Elvish</option>
        <option value="" disabled="disabled">─────────────</option> {
            for $lang in //language[@id]
            order by local:lang-order($lang/@id)
            return (
                <option value="{$lang/@id/string()}">{$lang/@name/string()}</option>,
                if ($lang/@id = 'ep') then  <option value="" disabled="disabled">─────────────</option> else ()
            )
       }
    </select> &#160;
    <p style="line-height: 0">
    <select id="targetSelect" onchange="doSearch()">
        <option value="word-and-gloss">Search word and gloss</option>
        <option value="word-only">Search word only</option>
        <option value="gloss-only">Search gloss only</option>
    </select> &#160;|&#160;
    <select id="positionSelect" onchange="doSearch()">
        <option value="anywhere">Match anywhere</option>
        <option value="start">Match start</option>
        <option value="end">Match end</option>
    </select> &#160;|&#160;
    <select id="partsOfSpeechSelect" onchange="doSearch()">
        <option value="">Parts of Speech</option>
        <option value="" disabled="disabled">──────</option>
        <option value="no-names">Exclude Names</option>
        <option value="" disabled="disabled">──────</option>
        <option value="n">noun</option>
        <option value="vb">verb</option>
        <option value="adj">adjective</option>
        <option value="adv">adverb</option>
        <option value="pron">pronoun</option>
        <option value="prep">preposition</option>
        <option value="conj">conjugation</option>
        <option value="pref">prefix</option>
        <option value="suf">suffix</option>
    </select>
    </p>
    <p style="line-height: 0">
    <button id="firstButton" onclick="goFirst()">&lt;&lt;</button>
    <button id="backButton" onclick="goBack()">&lt;</button>
    <span id="matchCount"></span>
    <button id="forwardButton" onclick="goForward()">&gt;</button>
    <button id="lastButton" onclick="goLast()">&gt;&gt;</button> &#160;|&#160;
    <button id="resetButton" onclick="reset()">Reset</button>
    </p>
</p>
<hr />
<div id="resultDiv"></div>
</body>
</html>
