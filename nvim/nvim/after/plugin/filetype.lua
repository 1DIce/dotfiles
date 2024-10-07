vim.filetype.add({
  filename = {
    ["angular.json"] = "jsonc",
    ["profile_bash"] = "sh",
    [".lua-format"] = "yaml",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
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

    -- Sets the filetype to `yaml.docker-compose` if it matches the pattern
    [".*%.compose%.yml"] = "yaml.docker-compose",
    [".*%.compose%.yaml"] = "yaml.docker-compose",
    [".*%.docker-compose%.yml"] = "yaml.docker-compose",
    [".*%.docker-compose%.yaml"] = "yaml.docker-compose",
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
