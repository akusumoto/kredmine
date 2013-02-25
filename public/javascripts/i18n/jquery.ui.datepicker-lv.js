/* Latvian (UTF-8) initialisation for the jQuery UI date picker plugin. */
/* @author Arturas Paleicikas <arturas.paleicikas@metasite.net> */
jQuery(function($){
	$.datepicker.regional['lv'] = {
		closeText: 'Aizvﾄ途t',
		prevText: 'Iepr',
		nextText: 'Nﾄ〔a',
		currentText: 'ﾅodien',
		monthNames: ['Janvﾄ〉is','Februﾄ〉is','Marts','Aprﾄｫlis','Maijs','Jﾅｫnijs',
		'Jﾅｫlijs','Augusts','Septembris','Oktobris','Novembris','Decembris'],
		monthNamesShort: ['Jan','Feb','Mar','Apr','Mai','Jﾅｫn',
		'Jﾅｫl','Aug','Sep','Okt','Nov','Dec'],
		dayNames: ['svﾄ鍍diena','pirmdiena','otrdiena','treﾅ｡diena','ceturtdiena','piektdiena','sestdiena'],
		dayNamesShort: ['svt','prm','otr','tre','ctr','pkt','sst'],
		dayNamesMin: ['Sv','Pr','Ot','Tr','Ct','Pk','Ss'],
		weekHeader: 'Nav',
		dateFormat: 'dd-mm-yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['lv']);
});