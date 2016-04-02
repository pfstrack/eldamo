// Glaemscribe initialization
Glaemscribe.resource_manager.load_modes(["quenya", "sindarin-beleriand"]);
var quenyaTranscriber = Glaemscribe.resource_manager.loaded_modes["quenya"];
var sindarinTranscriber = Glaemscribe.resource_manager.loaded_modes["sindarin-beleriand"];
// sindarin-beleriand | sindarin-classical

function doTranscribe(lang, value) {
	var transcriber = (lang == 'q') ? quenyaTranscriber : (lang == 's') ? sindarinTranscriber : null;
	if (transcriber == null) return null;

	// Transcription pre-processing to fix extraneous characters
	var transcribed = transcriber.transcribe(preprocessTranscription(value, lang));

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

function postprocessTranscription(result) {
	// Quenya transcription fixes
	result = result.replace('9D', '9C').replace('9ÍD', '9ÍC') // h(y)a-
	result = result.replace('9G', '9B') // hi-
	result = result.replace('3E', '3D') // tha
	result = result.replace('cE', 'c#').replace('cR', 'c$').replace('cT', 'c%') // // hw(a|e|i)
	result = result.replace('1Í', '1Î').replace('7Í', '7Ï') // (t|r)y

	// Mode of Beleriand transcription fixes
	result = result.replace(']Õ', ']Ö').replace('lÕ', 'lÖ').replace('.Õ', '.Ö') // (a|e|u)i
	result = result.replace(']d', '‡d').replace(']s', '‡s').replace(']g', '‡g') // a(ch|g|ng) - PE22/36

	// Sindarin Classical Mode transcription fixes
	result = result.replace('yD', 'yE') // au
	result = result.replace('9E', '9C') // ah
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