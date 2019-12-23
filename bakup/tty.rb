require "tty-prompt"
prompt = TTY::Prompt.new
system "clear"
ans = prompt.ask('What is your name?')
p ans

prompt.yes?('Do you like Ruby?')

ans = prompt.select("Choose your destiny?", %w(Scorpion Kano Jax))
p ans
