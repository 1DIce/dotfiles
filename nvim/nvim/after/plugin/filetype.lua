vim.filetype.add({
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

-- Detecting jenkins files
vim.filetype.add({
  extension = {
    jenkins = "Jenkinsfile",
    jenkinsfile = "Jenkinsfile",
    Jenkinsfile = "Jenkinsfile",
  },
  filename = {
    ["Jenkinsfile"] = "Jenkinsfile",
  },
  pattern = {
    ["Jenkinsfile*"] = "Jenkinsfile",
  },
})
