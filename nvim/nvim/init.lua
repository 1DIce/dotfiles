pcall(require, "impatient")

if require "ld.first-load"() then
  return
end


require "ld.plugins"

require "ld.utils"

require "ld.theme"

require "ld.defaults"

require "ld.lsp"
require "ld.remaps"
