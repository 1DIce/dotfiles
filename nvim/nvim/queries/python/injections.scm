; Injection query for SQL in Python strings
((string_content) @injection.content
  (#match? @injection.content "^\\s*(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER|WITH)")
  (#set! injection.language "sql"))
