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
    -- those are regex lua patterns % is used to escape
    ["tsconfig.*%.json"] = "jsonc",
    ["gitconfig.*"] = "gitconfig",
    [".*bashrc"] = "sh",
    [".*zshrc"] = "sh",
    [".*zprofile"] = "sh",
    [".*vrapperrc"] = "vim",
    ["i18n/.*%.properties"] = "jproperties",
  },
})
