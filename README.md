JatsTagLibrary
==============

This repository contains a few tools exploring different ways to improve the JATS Tag Library documentation,
which can be found here:

  * [Archiving and Interchange - NISO JATS 1.0](http://jats.nlm.nih.gov/archiving/tag-library/1.0/)
  * [Publishing - NISO JATS 1.0](http://jats.nlm.nih.gov/publishing/tag-library/1.0/)
  * [Article Authoring - NISO JATS 1.0](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/)

Browser Extension - TagLibPermalink
-----------------------------------

The first (and only, so far) tool is a small browser extension that will add a "permalink" to
each of the documentation pages, making it much easier to bookmark them and to share
links to them.

This extension works in Firefox and in Chrome.  It may work in other browsers, but hasn't
been tested.

### To install in Firefox

1.  Install the [Greasemonkey add-on](https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/)
2.  Go to the GitHub description page for this extension,
    [here](https://github.com/Klortho/JatsTagLibrary/blob/master/GreaseMonkey/TagLibPermalink.user.js)
3.  Click the "Raw" button.  You should see a pop-up window asking if you want to install this
    user script.
4.  Click "Install".  You should see a message, "TagLibPermalink installed successfully."
5.  Go to any of the JATS Tag Library pages, for example, [Article Authoring, NISO JATS
    1.0](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/)
6.  Navigate to any element documentation page, for example,
    [&lt;abbrev&gt;](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/?elem=abbrev).  You
    should see "permalink" in the upper-right hand corner.

### To install in Google Chrome

1.  Go to the GitHub description page for this extension,
    [here](https://github.com/Klortho/JatsTagLibrary/blob/master/GreaseMonkey/TagLibPermalink.user.js)
2.  '''Right-click''' on "Raw", and choose "Save link as", and then save the file to disk.
3.  On the button for the just-downloaded file, at the bottom of the browser window,
    right-click and select "show in folder" to bring up the file in the filesystem window (for
    example, Windows Explorer).
4.  In the Chrome window, click on the settings button, and click "Settings".  On the left-hand
    side, click "Extensions"
5.  Now, drag the user script from the filesystem window onto the Chrome extensions window.
    You should see a pop-up asking if you want to "Add TagLibraryPermalink?"
6.  Click "Add".
7.  Navigate to any element documentation page, for example,
    [&lt;abbrev&gt;](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/?elem=abbrev).  You
    should see "permalink" in the upper-right hand corner.
