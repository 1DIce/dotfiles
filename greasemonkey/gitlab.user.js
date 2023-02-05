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

      const diffFileContainer = document.querySelector(".diff-file");
      // scroll diff-file into view after clicking j or k
      if (
        diffFileContainer != null &&
        (e.keyCode == 74 || e.keyCode == 75) &&
        !e.shiftKey &&
        !e.ctrlKey &&
        !e.altKey &&
        !e.metaKey
      ) {
        setTimeout(() => {
          document.querySelector(".diff-file").scrollIntoView();
        }, 500);
      }

      const toggleTreeViewButton = document.querySelector(
        "[data-qa-selector = file_tree_button]"
      );
      // pressed alt+t to click "viewed" checkbox
      if (
        toggleTreeViewButton != null &&
        e.keyCode == 84 &&
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
