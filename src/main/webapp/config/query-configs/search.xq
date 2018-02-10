import module namespace c = "common.xq" at "common.xq";

declare function local:lang-name($lang as element()) as xs:string {
    if ($lang/@id = 'q') then (
        concat('Late ', $lang/@name/string(), ' (1950-73)')
    ) else if ($lang/@id = ('s', 'p')) then (
        concat($lang/@name/string(), ' (1950-73)')
    ) else if ($lang/@id = ('mq', 'n')) then (
        concat($lang/@name/string(), ' (1930-50)')
    ) else if ($lang/@id = 'mp') then (
        'Middle Primitive (1930-50)'
    ) else if ($lang/@id = 'eq') then (
        concat($lang/@name/string(), ' (1910-30)')
    ) else if ($lang/@id = 'g') then (
        concat($lang/@name/string(), ' (1910-20)')
    ) else if ($lang/@id = 'en') then (
        concat($lang/@name/string(), ' (1920-30)')
    ) else if ($lang/@id = 'ep') then (
        'Early Primitive (1910-30)'
    ) else (
        $lang/@name/string()
    )
};

declare function local:lang-order($lang as xs:string) as xs:string {
    if ($lang = 'q') then (
       '0'
    ) else if ($lang = 's') then (
       '1'
    ) else if ($lang = 'p') then (
       '2'
    ) else if ($lang = 'mq') then (
       '3'
    ) else if ($lang = 'n') then (
       '4'
    ) else if ($lang = 'mp') then (
       '5'
    ) else if ($lang = 'eq') then (
       '6'
    ) else if ($lang = 'en') then (
       '7'
    ) else if ($lang = 'g') then (
       '8'
    ) else if ($lang = 'ep') then (
       '9'
    ) else (
       $lang
    )
    
};

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
    <meta http-equiv="Content-Style-Type" content="text/css"></meta>
    <title>Eldamo : Search</title>
    <link rel="stylesheet" type="text/css" href="../../css/global.css"></link>
    <style>

span.label-holder {{ float: left; padding-right: 0.5em; }}
span.button-holder {{ float: right; display: block }}
span.search-holder {{ overflow: hidden; display: block; padding-right: 0.5em; }}
input.searchBox {{ width: 100%; }}
.search-selectors {{ margin-top: 0.25em; display: none; text-align: center; }}
input[type="text"], select, button {{ font-size: 16px; }}
button {{ border-radius: 4px; background-color: #EEE; border: 1px solid #444 }}
.label-holder {{ display: none; }}
@media only screen and (min-width: 920px) {{
    .search-selectors {{ text-align: left; }}
}}
@media only screen and (min-width: 400px) and (min-height: 400px) {{
    .label-holder {{ display: block; }}
    .search-selectors {{ display: block; }}
}}

    </style>
</head>
<script src="search-index.js"></script>
<script src="../../js/search.js"></script>
<body onload="initSearch()">
<div class="search-header">
    <span class="label-holder">
        <big>[<a href="../../index.html">Home</a>]</big>
    </span>
    <span class="button-holder">
        <button id="advancedButton" class="advancedButton" onclick="advanced()">...</button>
    </span>
    <span class="search-holder">
        <input type="text" id="searchBox" class="searchBox" value="" onkeyup="doSearch()" placeholder="Search..." />
    </span>
</div>
<div class="search-selectors" id="search-selectors">
    <select id="langSelect" class="langSelect" onchange="doSearch()">
        <option value="">All Languages</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="eq|mq|q|nq">All Quenya</option>
        <option value="g|n|en|s|ns">Sindarin/Noldorin/Gnomish</option>
        <option value="p|mp|ep|np">All Primitive Elvish</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="mq|q|nq">Later Quenya (1930+)</option>
        <option value="n|s|ns">Sindarin/Noldorin (1930+)</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="q|s|p">All Late Elvish (1950-73)</option>
        <option value="mq|n|mp">All Middle Elvish (1930-50)</option>
        <option value="eq|en|g|ep">All Early Elvish (1910-30)</option>
        <option value="" disabled="disabled">─────────────</option> {
            for $lang in //language[@id][not(@id=('np', 'ns', 'nq'))]
            order by local:lang-order($lang/@id)
            return (
                <option value="{$lang/@id/string()}">{local:lang-name($lang)}</option>,
                if ($lang/@id = 'ep') then  <option value="" disabled="disabled">─────────────</option>
                else if ($lang/@id = 'mp') then  <option value="" disabled="disabled">─────────────</option>
                else if ($lang/@id = 'p') then  <option value="" disabled="disabled">─────────────</option>
                else ()
            )
       }
    </select> &#160;
    <select id="targetSelect" onchange="doSearch()">
        <option value="word-and-gloss">word &amp; gloss</option>
        <option value="word-only">word only</option>
        <option value="gloss-only">gloss only</option>
    </select> &#160;
    <select id="positionSelect" onchange="doSearch()">
        <option value="anywhere">any match</option>
        <option value="start">start only</option>
        <option value="end">end only</option>
        <option value="interior">interior only</option>
    </select> &#160;
    <select id="partsOfSpeechSelect" onchange="doSearch()">
        <option value="">parts of speech</option>
        <option value="" disabled="disabled">──────</option>
        <option value="no-names">exclude names</option>
        <option value="" disabled="disabled">──────</option>
        <option value="n">noun</option>
        <option value="vb">verb</option>
        <option value="adj">adjective</option>
        <option value="adv">adverb</option>
        <option value="pron">pronoun</option>
        <option value="prep">preposition</option>
        <option value="conj">conjunction</option>
        <option value="pref">prefix</option>
        <option value="suf">suffix</option>
        <option value="root">root</option>
    </select> &#160;
    <button id="resetButton" onclick="reset()">Reset</button>
</div>
<hr />
<dl id="resultList"></dl>
</body>
</html>
