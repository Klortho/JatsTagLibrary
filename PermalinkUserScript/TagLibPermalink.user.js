// Greasemonkey script to add a permalink to the tag library documentation pages.
//
// ==UserScript==
// @name          TagLibPermalink
// @namespace     TagLibPermalink
// @version       1.0.2
// @description   Greasemonkey script to add a permalink to the tag library documentation pages.
// @include       http://jats.nlm.nih.gov/*/tag-library/*
// @include       http://dtd.nlm.nih.gov/*/tag-library/*
// ==/UserScript==


// a function that loads jQuery and calls a callback function when jQuery has finished loading;
// from here:  http://stackoverflow.com/questions/2246901/how-can-i-use-jquery-in-greasemonkey-scripts-in-google-chrome
function addJQuery(callback) {
    var script = document.createElement("script");
    script.setAttribute("src", "//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js");
    script.addEventListener('load', function() {
        var script = document.createElement("script");
        script.textContent = "window.jQ=jQuery.noConflict(true);(" + callback.toString() + ")();";
        document.body.appendChild(script);
    }, false);
    document.body.appendChild(script);
}

// the guts of this userscript
function main() {
    (function($) {
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
                    // strip off query string and fragment
                    var loc = window.location.toString().replace(/\?.*/, "");
                    var permahref = loc + "?" + type + "=" + slug;
                    permalink = $('<a href="' + permahref + '" target="_top">permalink</a>');
                }
                permalink.css({ "float": "right" });
                header.before(permalink);
            });
        }
    })(jQ);
}

// load jQuery and execute the main function
addJQuery(main);
