<%@ page contentType="text/html; charset=UTF-8" %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
    <title>Eldamo : Home</title>
    <link rel="stylesheet" type="text/css" href="css/global.css">
    <script src="js/add-queries.js"></script>
</head>
<body>
<h1>Eldamo - An&nbsp;Elvish&nbsp;Lexicon</h1>
<% if ("true".equals(request.getAttribute("PUB_MODE"))) { %>
<p><i>by Paul Strack &mdash; v<%= xdb.dom.DomManager.getDoc().getDocumentElement().getAttribute("version") %> &mdash;
generated&nbsp;<%= java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG).format(new java.util.Date()).replace(" ", "&#160;") %></i></p>
<% } %>
<ul>
<li><a href="content/languages/index.html">Languages</a></li>
<li><a href="content/references/index.html">References</a></li>
</ul>
<p><b>Word Searches:</b></p>
<ul>
<li><a href="content/search/search.html" query="neo">Neo-Eldarin Word Search</a></li>
<li><a href="content/search/search.html">Academic Word Search</a></li>
<li><a href="translations/international-searches.html">International Searches</a></li>
</ul>
<% if ("true".equals(request.getAttribute("PUB_MODE"))) { %>
<p>This collection of documents is a lexicon of Tolkien’s invented languages, particularly his Elvish languages, which
are the most detailed. The collection is called a “lexicon” because it is not a dictionary in the traditional sense; it
also analyzes the relationships between the languages and their development both within Tolkien’s fictional history and
conceptual changes through Tolkien’s lifetime. The title “Eldamo” superficially resembles an Elvish word, but it is
actually is an abbreviation for <u>El</u>vish <u>Da</u>ta <u>Mo</u>del, since its content is derived from an
<a href="content/data-model/eldamo-data.xml">XML data model</a> describing Tolkien’s languages and their relationships.
</p>
<p>Readers new to the Elvish languages might want to look first at the <a href="general/getting-started.html">Getting 
Started</a> document. More experienced readers may want to start with the discussion of the
<a href="general/motivations-and-methodology.html">Motivations and Methodology</a> for this lexicon. Everyone is invited
to look at the <a href="content/languages/index.html">Language Index</a>, particularly the sections on
<a href="content/language-pages/lang-nq.html">Quenya</a> and <a href="content/language-pages/lang-ns.html">Sindarin</a>.
Information about the source material used to compile this lexicon can be found in the
<a href="content/references/index.html">References Index</a>.</p>
<p>The information in this lexicon, including its XML data model, can be used freely in accordance with the
<a href="https://creativecommons.org/licenses/by/4.0/">Creative Commons (Attribution) License</a>, which basically
allows you to do whatever you want with it provided you credit my work. As it stands, this lexicon is currently in a
draft or “beta” state. It includes nearly all of Tolkien’s published Elvish words, including the major vocabulary lists
of Tolkien’s languages: <i><a href="content/references/ref-Ety.html">The Etymologies</a></i>,
the <i><a href="content/references/ref-GL.html">Gnomish</a></i> and <i><a href="content/references/ref-QL.html">Qenya
Lexicons</a></i>, <a href="content/references/ref-PE17.html">“Words, Phrases and Passages from <i>The Lord of the
Rings</i>”</a> (PE17) as well as <i><a href="content/references/ref-LotR.html">The Lord of the Rings</a></i> itself.
However, I have barely begun the work of analyzing and comparing the various word forms, and any conclusions in the
current version of the lexicon must be considered preliminary.</p>
<hr/>
<% } %>
<h2>General Information</h2>
<ul>
<li><a href="general/getting-started.html">Getting Started</a></li>
<li><a href="general/motivations-and-methodology.html">Motivations and Methodology</a></li>
<li><a href="general/terminology-and-notations.html">Terminology and Notations</a></li>
<li><a href="general/conceptual-history.html">Conceptual History of Elvish</a></li>
<li><a href="general/phonetic-descriptions.html">Phonetic Descriptions</a></li>
<li><a href="general/elvish-fonts.html">Elvish Fonts</a></li>
<li><a href="general/version-history.html">Version History</a></li>
</ul>
<% if ("true".equals(request.getAttribute("PUB_MODE"))) { %>
<p><b>Downloads</b></p>
<ul>
<li>Raw data - <a href="content/data-model/eldamo-data.xml">eldamo-data.xml</a> [right-click and choose “Save As...”]</li>
<li>Schema documentation - in <a href="general/eldamo-schema.html">HTML</a> and <a href="general/eldamo-schema.xsd">formal XSD</a></li>
<!--
<li>Full lexicon downloads at <a href="https://sourceforge.net/projects/eldamo/">Sourceforge</a></li>
-->
<li>Full lexicon downloads at <a href="https://github.com/pfstrack/eldamo/releases">Github</a></li>
</ul>
<hr/>
<p>
© 2008 - <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %>, Paul Strack.
This work is licensed under the Creative Commons Attribution 4.0 International License. To view a copy of this license,
visit <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">http://creativecommons.org/licenses/by/4.0/</a>.
</p>
<p>
The <i>Tengwar Eldamar</i> font is © Måns Björkman and is used with permission (see 
<a rel="license" href="http://at.mansbjorkman.net">http://at.mansbjorkman.net</a> for more information and the latest
version of this font). The version of this font used by this lexicon is the web font
(<a href="css/tengwar-eldamar-glaemscrafu.woff">tengwar-eldamar-glaemscrafu.woff</a>)
created by Benjamin Babut and Bertrand Bellet for the <a rel="license" href="https://glaemscrafu.jrrvf.com">Glǽmscrafu</a>
web site, also used with permission. Please consult the owners of this font and the relevant licenses before using it in
other projects.
</p>
<p>
The tengwar transcriptions in this lexicon are processed via the 
<a href="https://github.com/BenTalagan/glaemscribe">Glǽmscribe Javascript Library</a>, © Benjamin Babut, used in
accordance with its
<a rel="license" href="https://raw.githubusercontent.com/BenTalagan/glaemscribe/master/LICENSE.txt">license</a>.
</p>
<% } %>
<% if (!"true".equals(request.getAttribute("PUB_MODE"))) { %>
<hr>
<p><a href="content/errors/unmatched-links.html">Unmatched Links</a></p>
<p><a href="content/errors/misordered-rules.html">Misordered Rules</a></p>
<p><a href="merge.jsp">Merge Data</a></p>
<p><a href="content/compare-refs.html">Compare Refs</a></p>
<% } %>
</body>
</html>
