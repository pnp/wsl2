$(function () {
    $(".navbar-toggle").click(function () {
        $(this).toggleClass("change");
    })
})
$(function () {
    var copyToClipboard = function (text) {
        // Create a textblock and assign the text and add to document
        var el = document.createElement('textarea');
        el.value = text;
        document.body.appendChild(el);
        el.style.display = "block";

        // select the entire textblock
        if (window.document.documentMode)
            el.setSelectionRange(0, el.value.length);
        else
            el.select();

        // copy to clipboard
        document.execCommand('copy');

        // clean up element
        document.body.removeChild(el);
    }
    // $("code").each(function () {

    $("code.hljs").each(function () {

        var $this = $(this);
        var cssClass = $this.attr("class");
        console.log(cssClass);

        if (!cssClass.includes("yaml") && !cssClass.includes("css")) {

            var language = "PowerShell"
            var $codeHeader = $(

                '<div class="code-header">' +
                '    <span class="language">' + language + '</span>' +
                '    <button type="button" class="action" aria-label="Copy code">' +
                '		<span class="icon"><span class="glyphicon glyphicon-duplicate" role="presentation"></span></span>' +
                '		<div class="successful-copy-alert is-transparent" aria-hidden="true">' +
                '			<span class="icon is-size-large" style="color:green">' +
                '				<span class="glyphicon glyphicon-ok" role="presentation"></span>' +
                '			</span>' +
                '		</div>' +
                '	</button>' +
                '</div>'
            );
            $this.closest("pre").before($codeHeader);
            $codeHeader.find("button").click(function () {
                copyToClipboard($this.closest("pre").text());
                var successAlert = $(this).find(".successful-copy-alert");
                successAlert.removeClass("is-transparent");
                setTimeout(function () { successAlert.addClass("is-transparent"); }, 2000);
            });
        }
    });
});

