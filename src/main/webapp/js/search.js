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

words = [];
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
    word.match = toMatch(word.value);
    word.matchgloss = toMatch(word.gloss);
    word.normalized = (word.lang == 'mq' && !(word.speech.indexOf('name') >= 0)) ? word.normalized = normalizeSpelling(word.match) : '';
    words.push(word);
}

function normalizeSpelling(value) {
	return value.replace('k', 'c').replace('q', 'qu').replace('quu', 'qu').replace('ks', 'x');
}

function doReplace(charReplace1, charReplace2, value) {
	var result = value;
	for (var i = 0; i < charReplace1.length; i++) {
		if (i < charReplace2.length) {
			result = result.replace(charReplace1[i], charReplace2[i]);
		} else {
            result = result.replace(charReplace1[i], '');
		}
	}
	return result;
}

function charReplace(value) {
	var charReplace1 = 'ƕıǝðþθʒɣçƀɟḷḹẏýṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúýäëïöüāēīōūâêîôûŷăĕĭŏŭæǣǭχřš -–·¹²³⁴⁵⁶⁷⁸⁹?.‘’[]{}()!̆,`¯̯̥́̄̂'; 
	var charReplace2 = 'hietttggcbjllyymnrrnnaeiouaeiouyaeiouaeiouaeiouyaeiouaeoxrs    ';
	return doReplace(charReplace1, charReplace2, value);
}

function toMatch(value) {
    return charReplace(value.toLowerCase());
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

function doSearch() {
	searchIt(50);
}

function searchIt(buffer) {
	BUFFER = buffer;
	pos = 0; // Clear buffer
    var searchBox = document.getElementById('searchBox');
    var langSelect = document.getElementById('langSelect');
    var lang = langSelect.options[langSelect.selectedIndex].value;
    var targetSelect = document.getElementById('targetSelect');
    var target = targetSelect.options[targetSelect.selectedIndex].value;
    var positionSelect = document.getElementById('positionSelect');
    var position = positionSelect.options[positionSelect.selectedIndex].value;
    var partsOfSpeechSelect = document.getElementById('partsOfSpeechSelect');
    var partsOfSpeech = partsOfSpeechSelect.options[partsOfSpeechSelect.selectedIndex].value;
    var noNames = (partsOfSpeech == 'no-names');
    var partsOfSpeech = (partsOfSpeech == 'no-names') ? '' : partsOfSpeech;
    var langs = [];
    if (lang.length > 0) {
    	langs = lang.split('|');
    }
    var resultList = document.getElementById('resultList');
    var searchText = toMatch(searchBox.value);
    var first = [];
    var second = [];
    var third = [];
    var last = [];
    for (var i = 0; i < words.length; i++) {
    	var word = words[i];
    	if (isMatch(word, searchText, target, position, partsOfSpeech)) {
    		if (noNames && word.speech.indexOf('name') > 0) {
    			continue;
    		}
    		if (langs.length === 0 || langs.includes(word.lang)) {
    			var set = last;
                if (word.match.indexOf(searchText) == 0) set = first;
                if (word.match.indexOf(' ' + searchText) > 0) set = second;
                if (word.matchgloss.indexOf(searchText) == 0) set = third;
                if (word.matchgloss.indexOf(' ' + searchText) > 0) set = third;
    			set.push(word);
    		}
    	}
    }
    var result = first.concat(second).concat(third).concat(last);
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
        if (word.altlang && (word.altlang.indexOf('√') > 0 || word.altlang.indexOf('✶') > 0)) {
            html += '[' + word.altlang.substring(0, 1) +']';
        }
        html += convertLang(word.lang, word.speech);
        if (word.altlang && !(word.altlang.indexOf('√') > 0 || word.altlang.indexOf('✶') > 0)) {
            html += '[' + word.altlang +'] ';
        }
        html += word.mark;
        if (!word.see) {
            html += '<a href="../words/word-' + word.key + '.html">';
        }
        var value = word.value;
        html += '<span style="font-weight: bold" class="' + markclass + '">' + value + '</span></a>';
        if (!word.see) {
            html += '</a>';
        }
        if ((word.lang == 'mq') && (normalizeSpelling(value) != value)) {
            html += ' [Q. <b>' + normalizeSpelling(value) + '</b>] ';
        }
        html += ' <i>' + convertSpeech(word.speech) + '</i> ';
        if (word.gloss) {
        	html += ' “' + word.gloss + '”';
        }
        if (word.see) {
            html += ' see ';
            if (word.seeLang) {
                html += word.seeLang;
            }
            html += '<a href="../words/word-' + word.key + '.html">';
            html += '<span style="font-weight: bold">' + word.see + '</span></a>';
        }
        html += '</dt>';
    }
    return html;
}

function isMatch(word, searchText, target, position, partsOfSpeech) {
	if (partsOfSpeech != '') {
		if ((' ' + word.speech + ' ').indexOf(' ' + partsOfSpeech + ' ') < 0) {
			return false;
		}
	}
	var matcher = containsMatch;
	if (position == 'start') {
		matcher = startMatch;
	} else if (position == 'end') {
		matcher = endMatch;
	} else if (position == 'interior') {
		matcher = interiorMatch;
	}
	if ((matcher(word.match, searchText) || matcher(word.normalized, searchText)) && target.indexOf('word') >= 0) {
		return true;
	}
	if (matcher(word.matchgloss, searchText) && target.indexOf('gloss') >= 0) {
		return true;
	}
	return false;
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
