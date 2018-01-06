Pry.config.output_prefix = "\e[1;37m⨠  \e[0m"

Pry.config.prompt = [
  proc { |target_self, nest_level| "\e[0;31m💎\e[0m (\e[0;35m#{Pry.view_clip(target_self)}\e[0m)#{":#{nest_level}" unless nest_level.zero?}> " },
  proc { '...  ' }
]
