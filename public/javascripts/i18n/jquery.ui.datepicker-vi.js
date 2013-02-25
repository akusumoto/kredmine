/* Vietnamese initialisation for the jQuery UI date picker plugin. */
/* Translated by Le Thanh Huy (lthanhhuy@cit.ctu.edu.vn). */
jQuery(function($){
	$.datepicker.regional['vi'] = {
		closeText: 'ﾄ静ｳng',
		prevText: '&#x3c;Trﾆｰ盻嫩',
		nextText: 'Ti蘯ｿp&#x3e;',
		currentText: 'Hﾃｴm nay',
		monthNames: ['Thﾃ｡ng M盻冲', 'Thﾃ｡ng Hai', 'Thﾃ｡ng Ba', 'Thﾃ｡ng Tﾆｰ', 'Thﾃ｡ng Nﾄノ', 'Thﾃ｡ng Sﾃ｡u',
		'Thﾃ｡ng B蘯｣y', 'Thﾃ｡ng Tﾃ｡m', 'Thﾃ｡ng Chﾃｭn', 'Thﾃ｡ng Mﾆｰ盻拱', 'Thﾃ｡ng Mﾆｰ盻拱 M盻冲', 'Thﾃ｡ng Mﾆｰ盻拱 Hai'],
		monthNamesShort: ['Thﾃ｡ng 1', 'Thﾃ｡ng 2', 'Thﾃ｡ng 3', 'Thﾃ｡ng 4', 'Thﾃ｡ng 5', 'Thﾃ｡ng 6',
		'Thﾃ｡ng 7', 'Thﾃ｡ng 8', 'Thﾃ｡ng 9', 'Thﾃ｡ng 10', 'Thﾃ｡ng 11', 'Thﾃ｡ng 12'],
		dayNames: ['Ch盻ｧ Nh蘯ｭt', 'Th盻ｩ Hai', 'Th盻ｩ Ba', 'Th盻ｩ Tﾆｰ', 'Th盻ｩ Nﾄノ', 'Th盻ｩ Sﾃ｡u', 'Th盻ｩ B蘯｣y'],
		dayNamesShort: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
		dayNamesMin: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
		weekHeader: 'Tu',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['vi']);
});
