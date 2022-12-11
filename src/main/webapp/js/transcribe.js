// Glaemscribe initialization
Glaemscribe.resource_manager.load_modes(["quenya", "sindarin-beleriand"]);
var quenyaTranscriber = Glaemscribe.resource_manager.loaded_modes["quenya"];
var sindarinTranscriber = Glaemscribe.resource_manager.loaded_modes["sindarin-beleriand"];
//sindarin-beleriand | sindarin-classical
var eldamarCharset = Glaemscribe.resource_manager.loaded_charsets["tengwar_ds_eldamar"]

function doTranscribe(lang, value) {
	var transcriber = (lang == 'q' || lang == 'mq' || lang == 'eq' || lang == 'nq') ? quenyaTranscriber 
			: (lang == 's' || lang == 'n' || lang == 'en' || lang == 'g' || lang == 'ns') ? sindarinTranscriber : null;
	if (transcriber == null) return null;

	// Transcription pre-processing to fix extraneous characters
	var transcribed = transcriber.transcribe(preprocessTranscription(value, lang), eldamarCharset);

	// Do nothing for failed transcription
	if (transcribed == null || transcribed.length < 2) return null;

	// Transcription post-processing fixes for Tengwar Eldamar font
	return postprocessTranscription(transcribed[1].trim());
}

function preprocessTranscription(value, lang) {
	var base = doReplace('-¹²³⁴⁵⁶⁷⁸⁹()[]', ' ', value);
	base = base.replace('ñd', 'nd');
	base = base.replace('ñg', 'ng');
	if (lang == 'q') {
		base = base.replace('þt', 'st');
		base = base.replace('rg', 'rñ');
	}
	base = base.replace('χ', 'h');
	return base;
}

String.prototype.replaceAll = function(search, replacement) {
	return this.split(search).join(replacement);
}

function postprocessTranscription(result) {
	// Quenya transcription fixes
	result = result.replaceAll('-', ' -').replaceAll('=', ' =').replaceAll('À', ' À').replaceAll('Á', ' Á')  // ',', '?'

	// Mode of Beleriand transcription fixes
	// result = result.replaceAll(']d', '‡d').replaceAll(']s', '‡s').replaceAll(']g', '‡g').replaceAll(']a', '‡a') // a(ch|g|ng|c) - PE22/36
	
	// Sindarin Classical Mode transcription fixes
	return result;
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

function transcribeSpans() {
	var isNeo = window.location.toString().indexOf('?neo') > 0;
	if (isNeo) {
		var baseNavBlock = document.getElementById('nav-block');
		if (baseNavBlock) {
			var neoNavBlock = document.getElementById('neo-nav-block');
			if (neoNavBlock) {
				baseNavBlock.style.display = 'none';
				neoNavBlock.style.display = 'block';
			}
		}
		var neoLangWord = document.getElementById('neo-lang-word');
		if (neoLangWord) {
			var langWord = document.getElementById('lang-word');
			langWord.style.display = 'none';
			neoLangWord.style.display = 'block';
		}
		var anchors = document.getElementsByTagName('a');
		for (var i = 0; i < anchors.length; i++) {
			var a = anchors[i];
			if (a.name) continue;
            if (a.href.indexOf('#') > 0) continue;
            if (!(a.href.indexOf('word') > 0) && !(a.href.indexOf('search') > 0)) continue;
			a.href = a.href + "?neo";
		}
	} else {
		var neoElements = document.getElementsByClassName('neo');
		for (var i = 0; i < neoElements.length; i++) {
			var x = neoElements[i];
			x.style.display = 'none';
		}
	}

	var clsElements = document.getElementsByClassName("transcribe");
	for (var i = clsElements.length - 1; i >= 0; i--) {
		var transcribeSpan = clsElements[i];
		var value = transcribeSpan.getAttribute("data-value");
		var lang = transcribeSpan.getAttribute("data-lang");
		var transcribed = doTranscribe(lang, value);
		if (transcribed != null) {
			transcribeSpan.innerText = transcribed;
			transcribeSpan.setAttribute("class", "tengwar");
		}
	}
}

// Start transcription after window loading
window.onload = transcribeSpans;