vim.filetype.add({
  extension = {
    jenkins = "Jenkinsfile",
  },
  filename = {
    ["angular.json"] = "jsonc",
    ["profile_bash"] = "sh",
    [".lua-format"] = "yaml",
  },
  pattern = {
    ["tsconfig.*%.json"] = "jsonc",
    ["gitconfig.*"] = "gitconfig",
    [".*bashrc"] = "sh",
    [".*zshrc"] = "sh",
    [".*zprofile"] = "sh",
    [".*vrapper"] = "vim",
  },
})
