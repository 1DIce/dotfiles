// ==UserScript==
// @name gitlab review
// @include   https://gitlab.cas.de/*/-/merge_requests/*
//
// ==/UserScript==

(function () {
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
      // pressed alt+t to toggle code review file tree
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
