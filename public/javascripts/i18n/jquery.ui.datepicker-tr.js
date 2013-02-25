/* Turkish initialisation for the jQuery UI date picker plugin. */
/* Written by Izzet Emre Erkan (kara@karalamalar.net). */
jQuery(function($){
	$.datepicker.regional['tr'] = {
		closeText: 'kapat',
		prevText: '&#x3c;geri',
		nextText: 'ileri&#x3e',
		currentText: 'bugﾃｼn',
		monthNames: ['Ocak','ﾅ柆bat','Mart','Nisan','Mayﾄｱs','Haziran',
		'Temmuz','Aﾄ殷stos','Eylﾃｼl','Ekim','Kasﾄｱm','Aralﾄｱk'],
		monthNamesShort: ['Oca','ﾅ柆b','Mar','Nis','May','Haz',
		'Tem','Aﾄ殷','Eyl','Eki','Kas','Ara'],
		dayNames: ['Pazar','Pazartesi','Salﾄｱ','ﾃ㌢rﾅ歛mba','Perﾅ歹mbe','Cuma','Cumartesi'],
		dayNamesShort: ['Pz','Pt','Sa','ﾃ㌢','Pe','Cu','Ct'],
		dayNamesMin: ['Pz','Pt','Sa','ﾃ㌢','Pe','Cu','Ct'],
		weekHeader: 'Hf',
		dateFormat: 'dd.mm.yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['tr']);
});