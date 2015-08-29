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
    if (array.length < 6) continue;
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
    word.match = toMatch(word.value);
    word.matchgloss = toMatch(word.gloss);
    words.push(word);
}

function charReplace(value) {
	var charReplace1 = 'ƕıǝðþθʒɣçƀɟḷḹẏýṃṇṛṝñŋᴬᴱᴵᴼᵁáéíóúýäëïöüāēīōūâêîôûŷăĕĭŏŭæǣǭχřš -–·¹²³⁴⁵⁶⁷⁸⁹?.‘’[]{}()!̆,`¯̯̥́̄̂'; 
	var charReplace2 = 'hietttggcbjllyymnrrnnaeiouaeiouyaeiouaeiouaeiouyaeiouaeoxrs    ';

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
    else if (lang === 'mq')
        converted = 'ᴹQ. ';
    else if (lang === 'mt')
        converted = 'ᴹT. ';
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
	if (speech === 'masc-name') speech = 'm.';
	else if (speech === 'fem-name') speech = 'f.';
	else if (speech === 'place-name') speech = 'loc.';
	else if (speech === 'collective-name') speech = 'coll.';
	else if (speech === 'collective-noun') speech = 'coll.';
	else if (speech === 'proper-name') speech = 'pn.';
	else if (speech === 'vb') speech = 'v.';
	else if (speech === 'adj n') speech = 'adj. and n.';
	else if (speech === 'n adj') speech = 'n. and adj.';
	else if (speech === 'n adv') speech = 'n. and adv.';
	else if (speech === 'adj adv') speech = 'adj. and adv.';
	else if (speech === 'adv adj') speech = 'adv. and adj.';
	else if (speech === 'adv conj') speech = 'adv. and conj.';
	else if (speech === 'prep pref') speech = 'prep. and pref.';
	else if (speech === 'prep adv') speech = 'prep. and adv.';
	else if (speech === 'adv interj') speech = 'adv. and interj.';
	else if (speech === 'pron conj') speech = 'pron. and conj.';
	else speech += '.';
	return speech;
};

function initSearchBox() {
    var matchCount = document.getElementById('matchCount');
    matchCount.innerHTML = langs.length;
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

var pos = 0;
var max = 0;

function doSearch() {
    var matchCount = document.getElementById('matchCount');
    var searchBox = document.getElementById('searchBox');
    var noNamesBox = document.getElementById('noNamesBox');
    var noNames = noNamesBox.checked == true;
    var langSelect = document.getElementById('langSelect');
    var lang = langSelect.options[langSelect.selectedIndex].value;
    var targetSelect = document.getElementById('targetSelect');
    var target = targetSelect.options[targetSelect.selectedIndex].value;
    var positionSelect = document.getElementById('positionSelect');
    var position = positionSelect.options[positionSelect.selectedIndex].value;
    var langs = [];
    if (lang.length > 0) {
    	langs = lang.split('|');
    }
    var resultDiv = document.getElementById('resultDiv');
    var searchText = toMatch(searchBox.value);
    var first = [];
    var second = [];
    var third = [];
    var last = [];
    for (var i = 0; i < words.length; i++) {
    	var word = words[i];
    	if (isMatch(word, searchText, target, position)) {
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
    var html = '';
    var count = pos;
    for (; count < result.length && count < pos + 10; count++) {
    	var word = result[count];
    	var markclass = (word.deletemark === '-') ? 'deleted' : (word.deletemark === '|') ? 'deleted-section' : ''; 
        html += '';
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
        html += '<span style="font-weight: bold" class="' + markclass + '">' + word.value + '</span></a>'
        if (!word.see) {
            html += '</a>'
        }
        html += ' <i>' + convertSpeech(word.speech) + '</i> ';
        if (word.gloss) {
        	html += ' “' + word.gloss + '”';
        }
        if (word.see) {
            html += ' see <a href="../words/word-' + word.key + '.html">';
            html += '<span style="font-weight: bold" class="' + markclass + '">' + word.see + '</span></a>'
        }
        html += '<br/>';
    }
    resultDiv.innerHTML = html;
    var start = pos + 1;
    if (count === 0) start = 0;
    var matchCountText = '&#160;Matches ' + start + ' - ' + count + ' of ';
    matchCountText += max + '&#160;';
    matchCount.innerHTML = matchCountText;
}

function isMatch(word, searchText, target, position) {
	var matcher = containsMatch;
	if (position == 'start') {
		matcher = startMatch;
	} else if (position == 'end') {
		matcher = endMatch;
	}
	if (matcher(word.match, searchText) && target.indexOf('word') >= 0) {
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

function maxPos() {
	var result = max - 1;
	result = result - (result % 10);
	return result;
}

function goBack() {
    pos -= 10;
    if (pos < 0) pos = 0;
    doSearch();
}

function goForward() {
    pos += 10;
    if (pos > maxPos()) pos = maxPos();
    doSearch();
}

function goFirst() {
    pos = 0;
    doSearch();
}

function goLast() {
    pos = maxPos();
    doSearch();
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
    var noNamesBox = document.getElementById('noNamesBox');
    noNamesBox.checked = false;
    doSearch();
}
