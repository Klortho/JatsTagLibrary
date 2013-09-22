JatsTagLibrary
==============

This repository contains a few tools exploring different ways to improve the JATS
Tag Library documentation, which can be found here:

  * [Archiving and Interchange - NISO JATS
    1.0](http://jats.nlm.nih.gov/archiving/tag-library/1.0/)
  * [Publishing - NISO JATS 1.0](http://jats.nlm.nih.gov/publishing/tag-library/1.0/)
  * [Article Authoring - NISO JATS
    1.0](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/)

Alternative Interface to the Tag Suite Library
----------------------------------------------

This is a project that I've started, to adapt the [jqapi](http://jqapi.com/)
documentation framework to the tag library.

Work is being done in [my fork of that software](https://github.com/Klortho/jqapi/tree/dtdanalyzer).


Browser Extension - TagLibPermalink
-----------------------------------

The first (and only, so far) tool is a small browser extension that will add a "permalink" to
each of the documentation pages, making it much easier to bookmark them and to share
links to them.

This extension works in Firefox and in Chrome.  It may work in other browsers, but hasn't
been tested.

You can watch a [short video](http://www.ncbi.nlm.nih.gov/staff/maloneyc/JatsTagLibrary/TagSetPermalink.mp4)
about how to install it, and what it does.


### To install in Firefox

1.  Install the [Greasemonkey
    add-on](https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/)
2.  Go to the GitHub description page for this extension,
    [here](https://github.com/Klortho/JatsTagLibrary/blob/master/PermalinkUserScript/TagLibPermalink.user.js)
3.  Click the "Raw" button.  You should see a pop-up window asking if you want to install this
    user script.
4.  Click "Install".  You should see a message, "TagLibPermalink installed successfully."

### To install in Google Chrome (native)

1.  Go to the GitHub description page for this extension,
    [here](https://github.com/Klortho/JatsTagLibrary/blob/master/PermalinkUserScript/TagLibPermalink.user.js)
2.  '''Right-click''' on "Raw", and choose "Save link as", and then save the file to disk.
3.  On the button for the just-downloaded file, at the bottom of the browser window,
    right-click and select "show in folder" to bring up the file in the filesystem window (for
    example, Windows Explorer).
4.  In the Chrome window, click on the settings button, and click "Settings".  On the left-hand
    side, click "Extensions"
5.  Now, drag the user script from the filesystem window onto the Chrome extensions window.
    You should see a pop-up asking if you want to "Add TagLibraryPermalink?"
6.  Click "Add".

### To install in Google Chrome (tampermonkey)

If your Google Chrome extensions are restricted by your admins (as is the case in one
government organization that I know of) you might be able to install it anyway with
Tampermonkey.

1.  Find Tampermonkey in the [Chrome web store](https://chrome.google.com/webstore),
    and install it.
2.  Go to the GitHub description page for this extension,
    [here](https://github.com/Klortho/JatsTagLibrary/blob/master/PermalinkUserScript/TagLibPermalink.user.js)
3.  Click the "Raw" button.  The script should open in a new Tampermonkey tab, and a dialog box
    should appear asking if you want to install it.
4.  Click "OK".

### Try it out

Navigate to any element documentation page.  For example, starting at the
[Article Authoring Tag Library](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/),
navigate to _Elements_ → _&lt;abbrev&gt;_.  You should see "permalink" in the upper-right hand corner.
Click on that, and verify that your browser address bar now has
"http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/?elem=abbrev".


Public domain
-------------

This work is in the public domain and may be reproduced, published or otherwise
used without permission of the National Library of Medicine (NLM).

Although all reasonable efforts have been taken to ensure the accuracy and
reliability of the software and data, the NLM and the U.S. Government do not
and cannot warrant the performance or results that may be obtained by using
this software or data. The NLM and the U.S. Government disclaim all warranties,
express or implied, including warranties of performance, merchantability or
fitness for any particular purpose.


