/* Slovak initialisation for the jQuery UI date picker plugin. */
/* Written by Vojtech Rinik (vojto@hmm.sk). */
jQuery(function($){
	$.datepicker.regional['sk'] = {
		closeText: 'Zavrieﾅ･',
		prevText: '&#x3c;Predchﾃ｡dzajﾃｺci',
		nextText: 'Nasledujﾃｺci&#x3e;',
		currentText: 'Dnes',
		monthNames: ['Januﾃ｡r','Februﾃ｡r','Marec','Aprﾃｭl','Mﾃ｡j','Jﾃｺn',
		'Jﾃｺl','August','September','Oktﾃｳber','November','December'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Mﾃ｡j','Jﾃｺn',
		'Jﾃｺl','Aug','Sep','Okt','Nov','Dec'],
		dayNames: ['Nedeﾄｾa','Pondelok','Utorok','Streda','ﾅtvrtok','Piatok','Sobota'],
		dayNamesShort: ['Ned','Pon','Uto','Str','ﾅtv','Pia','Sob'],
		dayNamesMin: ['Ne','Po','Ut','St','ﾅt','Pia','So'],
		weekHeader: 'Ty',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['sk']);
});
