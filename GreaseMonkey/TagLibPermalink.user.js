// Greasemonkey script to add a permalink to the tag library documentation pages.
//
// ==UserScript==
// @name          TagLibPermalink
// @namespace     TagLibPermalink
// @description   Greasemonkey script to add a permalink to the tag library documentation pages.
// @include       http://jats.nlm.nih.gov/archiving/tag-library/*
// @include       http://jats.nlm.nih.gov/articleauthoring/tag-library/*
// @include       http://jats.nlm.nih.gov/publishing/tag-library/*
// @include       http://dtd.nlm.nih.gov/book/tag-library/*
// @include       http://dtd.nlm.nih.gov/archiving/tag-library/*
// @include       http://dtd.nlm.nih.gov/articleauthoring/tag-library/*
// @include       http://dtd.nlm.nih.gov/publishing/tag-library/*
// @require       http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js
// ==/UserScript==

// Prevent it executing when inside one of the frame documents
if (window.top == window.self) {

    // Store the original, default value for the src attribute of the main frame.
    // This will be the filename of the title page.  E.g. "n-c000.html".
    var mainFrame = $('frame[name="main"]');
    var titleFile = mainFrame.attr('src');

    mainFrame.load( function() {
        var mainDoc = top.frames["main"].document;

        // Get the main frame's filename (e.g. "n-fm00.html")
        var fnm = mainDoc.location.toString().match("[-a-zA-Z0-9]+\.html");
        if (!fnm) return;
        var mainFilename = fnm[0];

        // If the browser is pointed at a URL like "...?elem=attrib", then the mainFrame will
        // load twice:  once with the page that is hard-coded in the src attribute (the title
        // page, e.g. "n-c000.html") and once with the page that is found by the Mulberry
        // JavaScript.  We are only interested in the latter.
        if (mainFilename == titleFile) return;

        var hw = $('body.main div.pageheader', mainDoc).next(); // header wrapper
        var header = hw.is('h1') ? hw : hw.children('h1, h3').filter(':first');

        var types = {
            "elem": elems,
            "attr": attrs,
            "pe": pes,
            "chap": chaps
        };
        for (var type in types) {
            var xref = types[type];
            for (var name in xref) {
                if (xref[name] == mainFilename) {
                    var slug = name;
                    break;
                }
            }
            if (typeof(slug) != "undefined") break;
        }

        var permalink;
        if (typeof(slug) == "undefined") {
            // Couldn't find this page.  This happens for several of the "chap"
            // pages.
            permalink = $('<em>[ no permalink ]</em>');
        }
        else {
            var loc = window.location.toString().replace(/\?.*/, "");   // strip off query string and fragment
            var permahref = loc + "?" + type + "=" + slug;
            permalink = $('<a href="' + permahref + '" target="_top">permalink</a>');
        }
        permalink.css({ "float": "right" });
        header.before(permalink);
    });
}


