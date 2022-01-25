#!/bin/bash

GIT_ROOT_DIR=$(git rev-parse --show-toplevel)

pushd "$GIT_ROOT_DIR/m.sales.neo"
git-format-staged --formatter "node_modules/.bin/prettier --config $GIT_ROOT_DIR/m.sales.neo/src/.prettierrc --stdin-filepath \"{}\"" 'src/*.js' 'src/*.json' 'src/*.ts' 'src/*.less' 'src/*.css' 'src/*.html'
# "prettier-all": "prettier --write \"src/app/**/*.{ts, json, css, less, html}\"",
popd

QUOTE_VIEW_APP_PATH=$(echo "$GIT_ROOT_DIR/quote-view/quote-view.app")
pushd "$QUOTE_VIEW_APP_PATH"
git-format-staged --formatter "node_modules/.bin/prettier --config $QUOTE_VIEW_APP_PATH/.prettierrc --ignore-path $QUOTE_VIEW_APP_PATH/.prettierignore --stdin-filepath \"{}\"" '*.js' '*.json' '*.ts' '*.less' '*.css' '*.scss' '*.html'
popd

QUOTE_VIEW_E2E_PATH=$(echo "$GIT_ROOT_DIR/quote-view/quote-view.e2e")
pushd "$QUOTE_VIEW_E2E_PATH"
git-format-staged --formatter "node_modules/.bin/prettier --config $QUOTE_VIEW_E2E_PATH/.prettierrc.json --ignore-path $QUOTE_VIEW_E2E_PATH/.prettierignore --stdin-filepath \"{}\"" '*.js' '*.json' '*.ts' '*.less' '*.css' '*.scss' '*.html'
popd

NG_LIBS_PATH=$(echo "$GIT_ROOT_DIR/merlin-ng-libs")
pushd "$NG_LIBS_PATH"
git-format-staged --formatter "node_modules/.bin/prettier --config $NG_LIBS_PATH/.prettierrc --stdin-filepath \"{}\"" '*.js' '*.json' '*.ts' '*.less' '*.css' '*.scss' '*.html'
popd


