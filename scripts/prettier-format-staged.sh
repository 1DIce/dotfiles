#!/bin/sh

GIT_ROOT_DIR=$(git rev-parse --show-toplevel)

CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR | sed 's| |\\ |g')
CHANGES_M_SALES=$(echo "$CHANGED_FILES" | grep '^m.sales.neo')

if [ ! -z "$CHANGES_M_SALES" ]; then
  M_SALES_PATH=$(echo "$GIT_ROOT_DIR/m.sales.neo")
	git-format-staged --formatter ''"$M_SALES_PATH"'/node_modules/.bin/prettier --config '"$M_SALES_PATH"'/src/.prettierrc --stdin-filepath "{}"' 'm.sales.neo/src/*.js' 'm.sales.neo/src/*.json' 'm.sales.neo/src/*.ts' 'm.sales.neo/src/*.less' 'm.sales.neo/src/*.css' 'm.sales.neo/src/*.html'
	if [ $? -ne 0 ]; then
		echo "Error while formatting m.sales.neo"
		exit $?
	fi
fi

if [ ! -z $(echo "$CHANGED_FILES" | grep '^quote-view/quote-view.app') ]; then
  QUOTE_VIEW_REL_PATH="quote-view/quote-view.app"
	QUOTE_VIEW_APP_PATH=$(echo "$GIT_ROOT_DIR/$QUOTE_VIEW_REL_PATH")
	git-format-staged --formatter "$QUOTE_VIEW_APP_PATH/node_modules/.bin/prettier --config $QUOTE_VIEW_APP_PATH/.prettierrc --ignore-path $QUOTE_VIEW_APP_PATH/.prettierignore --stdin-filepath \"{}\"" "$QUOTE_VIEW_REL_PATH/*.js" "$QUOTE_VIEW_REL_PATH/*.json" "$QUOTE_VIEW_REL_PATH/*.ts" "$QUOTE_VIEW_REL_PATH/*.scss" "$QUOTE_VIEW_REL_PATH/*.html"
	if [ $? -ne 0 ]; then
		echo "Error while formatting quote-view.app"
		exit $?
	fi
fi

if [ ! -z $(echo "$CHANGED_FILES" | grep '^quote-view/quote-view.e2e') ]; then
  QUOTE_VIEW_E2E_REL_PATH="quote-view/quote-view.e2e"
	QUOTE_VIEW_E2E_PATH=$(echo "$GIT_ROOT_DIR/$QUOTE_VIEW_E2E_REL_PATH")
	git-format-staged --formatter "$QUOTE_VIEW_E2E_PATH/node_modules/.bin/prettier --config $QUOTE_VIEW_E2E_PATH/.prettierrc.json --ignore-path $QUOTE_VIEW_E2E_PATH/.prettierignore --stdin-filepath \"{}\"" "$QUOTE_VIEW_E2E_REL_PATH/*.js" "$QUOTE_VIEW_E2E_REL_PATH/*.json" "$QUOTE_VIEW_E2E_REL_PATH/*.ts" "$QUOTE_VIEW_E2E_REL_PATH/*.scss" "$QUOTE_VIEW_E2E_REL_PATH/*.html"
	if [ $? -ne 0 ]; then
		echo "Error while formatting quote-view.e2e"
		exit $?
	fi
fi

if [ ! -z $(echo "$CHANGED_FILES" | grep '^merlin-ng-libs') ]; then
	NG_LIBS_PATH=$(echo "$GIT_ROOT_DIR/merlin-ng-libs")
	git-format-staged --formatter "$NG_LIBS_PATH/node_modules/.bin/prettier --config $NG_LIBS_PATH/.prettierrc --stdin-filepath \"{}\"" "merlin-ng-libs/*.js" "merlin-ng-libs/*.json" "merlin-ng-libs/*.ts" "merlin-ng-libs/*.scss" "merlin-ng-libs/*.html"
  if [ $? -ne 0 ]; then
		echo "Error while formatting merlin-ng-libs"
		exit $?
	fi
fi

