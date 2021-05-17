/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: DE (German, Deutsch)
 */
(function ($) {
    $.extend($.validator.messages, {
        required: "Dieses Feld ist ein Pflichtfeld.",
        maxlength: $.validator.format("Maximal {0} Zeichen erlaubt"),
        minlength: $.validator.format("Bitte mindestens {0} Zeichen eingeben."),
        rangelength: $.validator.format("Bitte mindestens {0} und maximal {1} Zeichen eingeben."),
        email: "Bitte eine gültige E-Mail Adresse eingeben.",
        url: "Bitte eine gültige URL eingeben.",
        date: "Bitte ein gültiges Datum eingeben.",
        number: "Bitte eine Nummer eingeben",
        digits: "Bitte nur Ziffern eingeben.",
        equalTo: "Bitte denselben Wert wiederholen.",
        fileSize: "Diese Datei ist zu groß, erlaubt sind {0} MB",
        range: $.validator.format("Bitte einen Wert zwischen {0} und {1} eingeben."),
        max: $.validator.format("Bitte einen Wert kleiner oder gleich {0} eingeben."),
        min: $.validator.format("Bitte einen Wert größer oder gleich {0} eingeben."),
    });
}(jQuery));
