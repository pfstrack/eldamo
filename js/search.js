if (![].includes) {
  Array.prototype.includes = function(searchElement /*, fromIndex*/ ) {'use strict';
    var O = Object(this);
    var len = parseInt(O.length) || 0;
    if (len === 0) {
      return false;
    }
    var n = parseInt(arguments[1]) || 0;
    var k;
    if (n >= 0) {
      k = n;
    } else {
      k = len + n;
      if (k < 0) {k = 0;}
    }
    var currentElement;
    while (k < len) {
      currentElement = O[k];
      if (searchElement === currentElement ||
         (searchElement !== searchElement && currentElement !== currentElement)) {
        return true;
      }
      k++;
    }
    return false;
  };
}

function getTrans() {
	var url = window.location.toString();
	var transPos = url.indexOf('trans=');
	var isTrans = (transPos > 0);
	if (isTrans) {
		var trans = url.substring(transPos + 6, url.length);
		var csvPath = "../../translations/eldamo-" + trans + ".txt";
		var xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
		    if (this.readyState == 4 && this.status == 200) {
		    	processTransMap(xhttp.responseText);
		    }
		};
		xhttp.open("GET", csvPath, true);
		xhttp.send();
	}
	return isTrans;
}

var isNeo = window.location.toString().indexOf('?neo') > 0;
var isTrans = getTrans();

function processTransMap(allText) {
    var allTextLines = allText.split(/\r\n|\n/);
    for (var i = 0; i < allTextLines.length; i++) {
    	var line = allTextLines[i];
    	if (line.charAt(0) == '#') continue; // Comment line
        var entries = allTextLines[i].split('\t');
        var word = wordLookup[entries[0]];
        if (word) {
        	word.trans = entries[1];
        	word.matchtrans = toMatch(entries[1]);
        }
    }
}

words = [];
combines = {};
wordLookup = {};
for (var i = 0; i < index.length; i++) {
    var item = index[i];
    var array = item.split('%');
    if (array.length < 7) continue;
    var word = {};
    word.lang = array[0];
    word.value = array[1];
    word.speech = array[2];
    word.gloss = array[3];
    word.mark = array[4];
    word.deletemark = (word.mark.indexOf('-') >= 0) ? '-' : (word.mark.indexOf('|') >= 0) ? '|' : '';
    word.mark = word.mark.replace('-', '').replace('|', '');
    word.key = array[5];
    word.altlang = array[6];
    word.see = array[7];
    word.seeLang = array[8];
    word.ngloss = array[9];
    word.combine = array[10];
    word.deprecated = array[11];
    word.tengwar = array[12];
    word.match = toMatch(word.value);
    word.matchgloss = toMatch(word.gloss);
    word.matchNgloss = toMatch(word.ngloss);
    word.normalized = (word.lang == 'mq' && !(word.speech.indexOf('name') >= 0)) ? word.normalized = normalizeSpelling(word.match) : '';
    words.push(word);
    wordLookup[word.key] = word;
    if (word.combine) {
    	if (!combines[word.combine]) {
    		combines[word.combine] = [];
    	}
		combines[word.combine].push(word);
    }
}

function normalizeSpelling(value) {
	return value.replace(/ks/g, 'x').replace(/kw/g, 'q').replace(/k/g, 'c').replace(/q/g, 'qu').replace(/quu/g, 'qu');
}

function replaceAll(c1, c2, value) {
	// FIXME: optimize
	var previous = value;
	var result = previous.replace(c1, c2);
	while (result != previous) {
		previous = result;
		result = previous.replace(c1, c2);
	}
	return result;
}

function doReplace(charReplace1, charReplace2, value) {
	var result = value;
	for (var i = 0; i < charReplace1.length; i++) {
		var c = charReplace1[i];
		if (result.indexOf(c) >= 0) {
			if (i < charReplace2.length) {
				result = replaceAll(c, charReplace2[i], result);
			} else {
	            result = replaceAll(c, '', result);
			}
		}
	}
	return result;
}

function charReplace(value) {
	var charReplace1 = 'ƕıǝðþθʒɣçƀɟḷḹẏýṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúýäëïöüāēīōūâêîôûŷăĕĭŏŭæǣǭχřšё -–·¹²³⁴⁵⁶⁷⁸⁹?.‘’[]{}()!̆,`¯̯̥́̄̂'; 
	var charReplace2 = 'hietttggcbjllyymnrrnnaeiouaeiouyaeiouaeiouaeiouyaeiouaeoxrsе    ';
	return doReplace(charReplace1, charReplace2, value);
}

function toMatch(value) {
    return charReplace(value.toLowerCase()).trim();
}

function convertLang(lang, speech) {
	var converted = '';
    if (lang === 'p')
        converted = '✶';
    else if (lang === 'mp')
        converted = 'ᴹ✶';
    else if (lang === 'ep')
        converted = 'ᴱ✶';
    else if (lang === 'np')
        converted = 'ᴺ✶';
    else if (lang === 'mq')
        converted = 'ᴹQ. ';
    else if (lang === 'maq')
        converted = 'ᴹAQ. ';
    else if (lang === 'nq')
        converted = 'ᴺQ. ';
    else if (lang === 'mt')
        converted = 'ᴹT. ';
    else if (lang === 'ns')
        converted = 'ᴺS. ';
    else if (lang === 'norths')
        converted = 'North S. ';
    else if (lang === 'ln')
        converted = 'ᴸN. ';
    else if (lang === 'en')
        converted = 'ᴱN. ';
    else if (lang === 'eon')
        converted = 'ᴱON. ';
    else if (lang === 'eoq')
        converted = 'ᴱOQ. ';
    else if (lang === 'eilk')
        converted = 'ᴱIlk. ';
    else if (lang === 'eq')
        converted = 'ᴱQ. ';
    else if (lang === 'ad')
        converted = 'Ad. ';
    else if (lang === 'pad')
        converted = '✶Ad. ';
    else if (lang === 'kh')
        converted = 'Kh. ';
    else if (lang === 'ed')
        converted = 'Ed. ';
    else if (lang === 'av')
        converted = 'Av. ';
    else if (lang === 'un')
        converted = 'Un. ';
    else if (lang.length === 1 || lang.length === 2)
        converted = lang.toUpperCase() + '. ';
    else 
        converted = lang.charAt(0).toUpperCase() + lang.substring(1) + '. ';
    if (speech === 'root') {
    	converted = converted.replace('✶', '√');
    }
    return converted;
}

function convertSpeech(speech) {
	if (speech.indexOf(' ') > 0) {
		var a = speech.split(' ');
		var result = convertSpeech(a[0]);
		for (var i = 1; i < a.length; i++) {
			result += " and " + convertSpeech(a[i]);
		}
		return result;
	}
	else if (speech === 'masc-name') speech = 'm.';
	else if (speech === 'fem-name') speech = 'f.';
	else if (speech === 'place-name') speech = 'loc.';
	else if (speech === 'collective-name') speech = 'coll.';
	else if (speech === 'collective-noun') speech = 'coll.';
	else if (speech === 'proper-name') speech = 'pn.';
	else if (speech === 'vb') speech = 'v.';
	else speech += '.';
	return speech;
};

function initSearchBox() {
}

function initSearch() {
	showNeoWarning();
	if (isTrans) hideHelp();
    var langSelect = document.getElementById('langSelect');
    for (var i = 0; i < langs.length; i++) {
        var item = langs[i];
        var array = item.split('%');
        if (array.length < 2) continue;
        var o = new Option(array[1], array[0]);
        // langSelect.options.add(o);
    }
    doSearch();
}

var BUFFER = 50;
var pos = 0;
var max = 0;

function doSearchTyping() {
	doSearch()
}

function doSearch() {
	setTimeout(asyncSearch, 10);
}

function asyncSearch() {
	searchIt(50);
}

var SEARCH_SET = '';

function searchIt(buffer) {
	BUFFER = buffer;
	pos = 0; // Clear buffer
    var searchBox = document.getElementById('searchBox');
    var searchText = searchBox.value;
    while (searchText.indexOf(' =') > 0) {
    	searchText = searchText.replace(' =', '=');
    }
    var langSelect = document.getElementById('langSelect');
    var lang = langSelect.options[langSelect.selectedIndex].value;
    var targetSelect = document.getElementById('targetSelect');
    var target = targetSelect.options[targetSelect.selectedIndex].value;
    var positionSelect = document.getElementById('positionSelect');
    var position = positionSelect.options[positionSelect.selectedIndex].value;
    var partsOfSpeechSelect = document.getElementById('partsOfSpeechSelect');
    var partsOfSpeech = partsOfSpeechSelect.options[partsOfSpeechSelect.selectedIndex].value;
    var currentSearchSet = searchText + '@' + lang + '@' + target + '@' + position + '@' + partsOfSpeech + '@' + BUFFER;
    if (currentSearchSet != SEARCH_SET) {
    	SEARCH_SET = currentSearchSet;
    } else {
    	return; // Skip
    }
    var noNames = (partsOfSpeech == 'no-names');
    var onlyNames = (partsOfSpeech == 'only-names');
    var partsOfSpeech = (partsOfSpeech == 'no-names' || partsOfSpeech == 'only-names') ? '' : partsOfSpeech;
    var langs = [];
    if (lang.length > 0) {
    	langs = lang.split('|');
    }
    var resultList = document.getElementById('resultList');
    var first = [];
    var second = [];
    var third = [];
    var last = [];
    var deprecated = [];
    var count = 0;
    for (var i = 0; i < words.length; i++) {
    	var word = words[i];
    	if (isMatch(word, searchText, target, position, partsOfSpeech)) {
            if (noNames && word.speech.indexOf('name') > 0) {
                continue;
            }
            if (onlyNames && word.speech.indexOf('name') <= 0) {
                continue;
            }
    		if (langs.length === 0 || langs.includes(word.lang)) {
    			var set = last;
    			var compare = toMatch(searchText);
                if (word.match.indexOf(compare) == 0 && target != 'gloss-only') set = first;
                //if (word.match.indexOf(' ' + compare) > 0) set = second;
                //if (word.matchgloss.indexOf(compare) == 0) set = third;
                //if (word.matchgloss.indexOf(' ' + compare) > 0) set = third;
                if (isNeo && word.deprecated) set = deprecated;
    			set.push(word);
    			if (count >= BUFFER + 1) {
    				break;
    			}
    		}
    	}
    }
    var result = first.concat(second).concat(third).concat(last).concat(deprecated);
    max = result.length;
    if (pos > maxPos()) pos = maxPos();
    var count = pos;
    var html = wordsToHtml(result, pos);
    if (pos + BUFFER < max) {
    	html += '<dt id="loadingZone">Loading...</dt>';
    }
    resultList.innerHTML = html;
	var loadingZone = document.getElementById('loadingZone');
	if (isInViewport(loadingZone)) {
		searchIt(BUFFER + 50);
	}
}

function wordsToHtml(result, pos) {
    var count = pos;
    var html = '';
    for (; count < result.length && count < pos + BUFFER; count++) {
    	var word = result[count];
    	var markclass = (word.deletemark === '-') ? 'deleted' : (word.deletemark === '|') ? 'deleted-section' : ''; 
        html += '<dt>';
        if (isNeo &&
        		(word.deprecated || word.lang == 'ep' || word.lang == 'eq' || word.lang == 'g' || word.lang == 'en'
        			|| markclass)) {
        	html += '⚠️';
        }
        if (word.altlang && (word.altlang.indexOf('√') > 0 || word.altlang.indexOf('✶') > 0)
        		&& word.mark.indexOf('!') < 0) {
            html += '[' + word.altlang.substring(0, 1) +']';
        }
        var langValue = convertLang(word.lang, word.speech);
        var combineList = '';
        if (isNeo && combines[word.key]) {
        	for (var i = 0; i < combines[word.key].length; i++) {
        		var combineWord = combines[word.key][i];
        		var convertedCombineLang = convertLang(combineWord.lang, combineWord.speech);
        		if (combineList.indexOf(convertedCombineLang) < 0) {
        			combineList = combineList.trim() + ', ' + convertedCombineLang;
        		}
        	}
        }
        if (word.altlang && !(word.altlang.indexOf('√') > 0 || word.altlang.indexOf('✶') > 0)
        		&& word.mark.indexOf('!') < 0) {
            html += langValue;
            if (combineList) {
                html += '[' + combineList.substring(1).trim() +'] ';
            } else {
                html += '[' + word.altlang +'] ';
            }
        } else if (combineList) {
            html += (langValue.trim() + combineList);
        } else {
            html += langValue;
        }
        html += word.mark;
        var ext = '.html' + (isNeo ? '?neo' : '');
        if (!word.see) {
            html += '<a href="../words/word-' + word.key + ext + '">';
        }
        var value = word.value;
        html += '<span style="font-weight: bold" class="' + markclass + '">' + value + '</span></a>';
        if (!word.see) {
            html += '</a>';
        }
        if ((word.lang == 'mq') && (normalizeSpelling(value) != value)) {
            html += ' [Q. <b>' + normalizeSpelling(value) + '</b>] ';
        }
        if (word.tengwar) {
            html += ' [<b>' + word.tengwar + '</b>] ';
        }
        html += ' <i>' + convertSpeech(word.speech) + '</i> ';
        if (isNeo && word.ngloss) {
        	html += ' “' + word.ngloss + '”';
        } else if (word.trans) {
        	html += ' “' + word.trans + '”';
	        if (word.gloss) {
	        	html += ' [English: “' + word.gloss + '”]';
	        }
        } else if (word.gloss) {
        	html += ' “' + word.gloss + '”';
        }
        if (word.see && !(isNeo && word.deprecated)) {
            html += ' see ';
            if (word.seeLang) {
                html += word.seeLang;
            }
            html += '<a href="../words/word-' + word.see + ext + '">';
            html += '<span style="font-weight: bold">' + wordLookup[word.see].value + '</span></a>';
        }
        html += '</dt>';
        if (isNeo && word.deprecated) {
        	var replacements = word.deprecated.split('|');
        	for (var i = 0; i < replacements.length; i++) {
        		var replacement = wordLookup[replacements[i]];
        		if (replacement) {
                    html += '<dd class="see-instead">';
                    html += convertLang(replacement.lang, replacement.speech);
                    html += '<a href="../words/word-' + replacement.key + ext + '">';
                    html += '<span style="font-weight: bold">' + replacement.value + '</span></a>';
                    if (replacement.ngloss) {
                    	html += ' “' + replacement.ngloss + '”';
                    } else if (replacement.gloss) {
                    	html += ' “' + replacement.gloss + '”';
                    }
                    html += '</dd>';
        		}
        	}
        }
    }
    return html;
}

function isMatch(word, searchText, target, position, partsOfSpeech) {
	var searches = searchText.split('+');
	for (var i = 0; i < searches.length; i++) {
		if (!orMatch(word, searches[i], target, position, partsOfSpeech)) return false;
	}
	if (!isNeo && (word.lang == 'np' || word.lang == 'nq' || word.lang == 'ns')) {
		return false;
	}
	return true;
}

function orMatch(word, searchText, target, position, partsOfSpeech) {
	if (searchText.startsWith('word=')) {
		target = 'word';
		searchText = searchText.substring(5);
	} else if (searchText.startsWith('gloss=')) {
		target = 'gloss';
		searchText = searchText.substring(6);
	}
	var searches = searchText.split(',');
	for (var i = 0; i < searches.length; i++) {
		if (checkMatch(word, toMatch(searches[i]), target, position, partsOfSpeech)) return true;
	}
	return false;
}

function checkMatch(word, searchText, target, position, partsOfSpeech) {
	if (isNeo && word.combine) {
		return false;
	}
	if (partsOfSpeech != '') {
		if ((' ' + word.speech + ' ').indexOf(' ' + partsOfSpeech + ' ') < 0) {
			return false;
		}
	}
	var matcher = containsMatch;
	if (searchText.indexOf('*') >= 0) {
		matcher = wildcardMatch;
	} else if (position == 'start') {
		matcher = startMatch;
	} else if (position == 'end') {
		matcher = endMatch;
	} else if (position == 'interior') {
		matcher = interiorMatch;
	}
	if (target.indexOf('word') >= 0 && (matcher(word.match, searchText) || matcher(word.normalized, searchText))) {
		return true;
	}
	if (target.indexOf('gloss') >= 0 && word.matchgloss.indexOf('unglossed') < 0 && matcher(word.matchgloss, searchText)) {
		return true;
	}
	if (isTrans && target.indexOf('gloss') >= 0 && word.matchtrans && matcher(word.matchtrans, searchText)) {
		return true;
	}
	if (isNeo && target.indexOf('gloss') >= 0 && matcher(word.matchNgloss, searchText)) {
		return true;
	}
	return false;
}

function wildcardMatch(text, searchText) {
	var parts = searchText.split('*');
	if (parts.length == 0) return true;
	var atStart = searchText.charAt(0) == '*';
	var atEnd = searchText.charAt(searchText.length - 1) == '*';

	if (!atStart && parts[0] && !startMatch(text, parts[0])) {
		return false;
	}
	if (!atEnd && parts[parts.length - 1] && !endMatch(text, parts[parts.length - 1])) {
		return false;
	}
	var pos = new Array();
	for (var i = 0; i < parts.length; i++) {
		if (!parts[i]) continue;
		pos[i] = text.indexOf(parts[i]);
		if (pos[i] < 0) return false;
		if (atStart && atEnd && !interiorMatch(text, parts[i])) return false;
		if (i > 0) {
			pos[i] = text.indexOf(parts[i], pos[i - 1]);
			if (pos[i] < 0) return false;
		}
	}
	return true;
}

function containsMatch(text, searchText) {
	return text.indexOf(searchText) >= 0;
}

function startMatch(text, searchText) {
	return text.indexOf(searchText) == 0;
}

function endMatch(text, searchText) {
	if (searchText.length > text.length) return false;
	return text.lastIndexOf(searchText) == (text.length - searchText.length);
}

function interiorMatch(text, searchText) {
	return containsMatch(text, searchText) && !startMatch(text, searchText) && !endMatch(text, searchText);
}

function maxPos() {
	var result = max - 1;
	result = result - (result % BUFFER);
	return result;
}

function reset() {
    var searchBox = document.getElementById('searchBox');
    searchBox.value = '';
    var langSelect = document.getElementById('langSelect');
    langSelect.selectedIndex = 0;
    var targetSelect = document.getElementById('targetSelect');
    targetSelect.selectedIndex = 0;
    var positionSelect = document.getElementById('positionSelect');
    positionSelect.selectedIndex = 0;
    var partsOfSpeechSelect = document.getElementById('partsOfSpeechSelect');
    partsOfSpeechSelect.selectedIndex = 0;
	window.stickyhelp = false;
    showHelp();
    doSearch();
}

function advanced() {
    var searchSelectors = document.getElementById('search-selectors');
    display = getComputedStyle(searchSelectors, null).getPropertyValue('display');
    if (display == 'block') {
    	searchSelectors.style.display = 'none';
    } else {
    	searchSelectors.style.display = 'block';
    }
}

function help() {
	window.stickyhelp = !window.stickyhelp;
    var helpDiv = document.getElementById('help-div');
    display = getComputedStyle(helpDiv, null).getPropertyValue('display');
    if (display == 'block') {
    	helpDiv.style.display = 'none';
    } else {
    	helpDiv.style.display = 'block';
    }
}

function hideHelp() {
	if (window.stickyhelp) {
		return;
	}
    var neoWarningDiv = document.getElementById('neo-warning-div');
    neoWarningDiv.style.display = 'none';
    var helpDiv = document.getElementById('help-div');
	helpDiv.style.display = 'none';
}

function showHelp() {
	if (isTrans) return;
    var helpDiv = document.getElementById('help-div');
	helpDiv.style.display = 'block';
}

function showNeoWarning() {
	if (isNeo) {
	    var neoWarningDiv = document.getElementById('neo-warning-div');
	    neoWarningDiv.style.display = 'block';
	} else {
	    var neoWarningDiv = document.getElementById('neo-warning-div');
	    neoWarningDiv.style.display = 'none';
	}
}

//-----------------//
// Infinite Scroll //
//-----------------//

function posY(elmt) {
    var test = elmt, top = 0;
    while(!!test && test.tagName.toLowerCase() !== "body") {
        top += test.offsetTop;
        test = test.offsetParent;
    }
    return top;
}

function viewportHeight() {
	var docElmt = document.documentElement;
	if (!!window.innerWidth) {
		return window.innerHeight;
	} else if (docElmt && !isNaN(docElmt.clientHeight)) {
		return docElmt.clientHeight;
	}
	return 0;
}

function scrollY() {
	if (window.pageYOffset) {
		return window.pageYOffset;
	}
	return Math.max(document.documentElement.scrollTop, document.body.scrollTop);
}

function isInViewport(elmt) {
	if (elmt == null) return false;
    return !(posY(elmt) > (viewportHeight() + scrollY()));
}

var scrollLock = false;

function checkLoading() {
	if (scrollLock) return;
	scrollLock = true;
	var loadingZone = document.getElementById('loadingZone');
	if (isInViewport(loadingZone)) {
		searchIt(BUFFER + 50);
	}
	scrollLock = false;
}

window.onscroll = checkLoading;
