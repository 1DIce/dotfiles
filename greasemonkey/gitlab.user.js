// ==UserScript==
// @name gitlab review
// @include   https://gitlab.cas.de/*/-/merge_requests/*
//
// ==/UserScript==

(function () {
  // Make ticket numbers in the merge request title clickable
  [...document.getElementsByClassName("title")].forEach((e) => {
    const ticket = e.innerHTML.match(/CDEV-\d+/gi)?.[0];
    if (ticket) {
      e.innerHTML = e.innerHTML.replace(
        ticket,
        `<a target='_blank' href='https://smight.atlassian.net/browse/${ticket.replace(
          ":",
          "",
        )}'>${ticket}</a>`,
      );
    }
  });

  document.addEventListener(
    "keydown",
    function (e) {
      const reviewdCheckbox = document.querySelector(
        "[data-testid = fileReviewCheckbox]",
      );
      // pressed alt+r to click "viewed" checkbox
      if (
        reviewdCheckbox != null &&
        e.keyCode == 82 &&
        !e.shiftKey &&
        !e.ctrlKey &&
        e.altKey &&
        !e.metaKey
      ) {
        reviewdCheckbox.click();
        // focusing the diff again to make scrolling down with  arrow keys work
        document.querySelector("diff-file")?.focus();
      }
    },
    false,
  );
})();
