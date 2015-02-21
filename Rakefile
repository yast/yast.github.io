#! /usr/bin/env ruby

require "bundler"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "raspell"

task :spellcheck do
  speller = Aspell.new("en_US")
  speller.suggestion_mode = Aspell::NORMAL
  speller.set_option("mode", "html")

  # read the custom dictionary
  custom = File.read(".spell.dict").split("\n")
  success = true

  Dir["**/*.{md,html}"].each do |file|
    lines = File.read(file).split("\n")

    lines.each_with_index do |text, index|
      misspelled = speller.list_misspelled([text]) - custom
      
      if !misspelled.empty?
        success = false

        puts "#{file}:#{index + 1}: #{text.inspect}"

        misspelled.each do |word|
          puts "    #{word.inspect} => #{speller.suggest(word)}"
        end

        puts
      end
    end
  end

  if !success
    raise "Spellcheck failed! (Fix it or add the words to '.spell.dict'" \
      " file if it is OK.)"
  end
end

task default: [:spellcheck]

