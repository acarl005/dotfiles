; extends

((comment) @comment
  (template_string (string_fragment) @injection.content)
  (#lua-match? @comment "/%*%s*%w+%s*%*/")
  (#inject-lang-from-block-comment! @comment))
