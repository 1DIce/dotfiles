; copied from https://github.com/nvim-treesitter/nvim-treesitter-angular

(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "%[.*%]"))) @keyword

(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "%(.*%)"))) @keyword

(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "^%*.*"))) @keyword
