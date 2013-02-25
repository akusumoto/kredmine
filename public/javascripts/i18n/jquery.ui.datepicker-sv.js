/* Swedish initialisation for the jQuery UI date picker plugin. */
/* Written by Anders Ekdahl ( anders@nomadiz.se). */
jQuery(function($){
    $.datepicker.regional['sv'] = {
		closeText: 'St辰ng',
        prevText: '&laquo;F旦rra',
		nextText: 'N辰sta&raquo;',
		currentText: 'Idag',
        monthNames: ['Januari','Februari','Mars','April','Maj','Juni',
        'Juli','Augusti','September','Oktober','November','December'],
        monthNamesShort: ['Jan','Feb','Mar','Apr','Maj','Jun',
        'Jul','Aug','Sep','Okt','Nov','Dec'],
		dayNamesShort: ['S旦n','M奪n','Tis','Ons','Tor','Fre','L旦r'],
		dayNames: ['S旦ndag','M奪ndag','Tisdag','Onsdag','Torsdag','Fredag','L旦rdag'],
		dayNamesMin: ['S旦','M奪','Ti','On','To','Fr','L旦'],
		weekHeader: 'Ve',
        dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
    $.datepicker.setDefaults($.datepicker.regional['sv']);
});
