// ==UserScript==
// @name        _Adding a jenkins login button
// @description Adds Login button to the botton of a jenkins site
// @match       *://jenkins.cas-merlin.de/view/*
// ==/UserScript==

/*--- Create a button in a container div.  It will be styled and
    positioned with CSS.
*/
var zNode = document.createElement("div");
zNode.innerHTML = '<button id="myButton" type="button">' + "Login!</button>";

zNode.setAttribute("id", "myContainer");
document.body.appendChild(zNode);
document
  .getElementById("myButton")
  .setAttribute(
    "style",
    "width: 100px;color: black;background: lightcoral;font-weight: bold;"
  );

//--- Activate the newly added button.
document
  .getElementById("myButton")
  .addEventListener("click", ButtonClickAction, false);

function ButtonClickAction(zEvent) {
  /*--- We manipulate the href to go to the login site and redirect to the current side afterwards
   */
  window.location.href = window.location.href.replace(
    "cas-merlin.de/",
    "cas-merlin.de/login?from=/"
  );
}
