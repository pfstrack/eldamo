function addQueries() {
	var anchors = document.getElementsByTagName('a');
	for (var i = 0; i < anchors.length; i++) {
		var a = anchors[i];
		var query = a.getAttribute("query");
		if (query && a.href && !(a.href.indexOf('?') > 0)) {
			a.href = a.href + "?" + query;
		}
	}
}

window.onload = addQueries;
