// ==UserScript==
// @name gitlab review
// @include   https://gitlab.cas.de/*/-/merge_requests/*
//
// ==/UserScript==

(function () {
  // Make ticket numbers in the merge request title clickable
  [...document.getElementsByClassName("title page-title")].forEach((e) => {
    const ticket = e.innerHTML.match(/\[MER-\d+\]/g)[0];
    if (ticket) {
      e.innerHTML = e.innerHTML.replace(
        ticket,
        `<a target='_blank' href='https://jira.cas.de/browse/${ticket
          .replace("[", "")
          .replace("]", "")}'>${ticket}</a>`
      );
    }
  });

  document.addEventListener(
    "keydown",
    function (e) {
      const reviewdCheckbox = document.querySelector(
        "[data-testid = fileReviewCheckbox]"
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
      }

      const toggleTreeViewButton = document.querySelector(
        "[data-qa-selector = file_tree_button]"
      );
      // pressed alt+w to toggle the code review file tree
      if (
        toggleTreeViewButton != null &&
        e.keyCode == 87 &&
        !e.shiftKey &&
        !e.ctrlKey &&
        e.altKey &&
        !e.metaKey
      ) {
        toggleTreeViewButton.click();
      }
    },
    false
  );
})();
