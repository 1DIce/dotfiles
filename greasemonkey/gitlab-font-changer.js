// ==UserScript==
// @name        Github font changer
// @namespace   local.greasemonkey.gitlabfontchanger
// @include     https://gitlab.cas.de/*
// @version     1
// @grant       none
// ==/UserScript==

var fontdef = "UbuntuMono, Monaco, Monospace ! important"; // Set your font here.

// Function helper to inject css
function addGlobalStyle(css) {
  var head, style;
  head = document.getElementsByTagName("head")[0];
  if (!head) {
    return;
  }
  style = document.createElement("style");
  style.type = "text/css";
  style.innerHTML = css;
  head.appendChild(style);
}

// Apply the font-family definition to code styles.
addGlobalStyle(
  ".code { font-family: " +
    fontdef +
    "; font-size: 16px; } " +
    ".diff-line-num { font-family: " +
    fontdef +
    "; } " +
    ""
);
