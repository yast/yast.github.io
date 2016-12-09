#! /usr/bin/env ruby

require "bundler"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "yast/rake"

Yast::Tasks.configuration do |conf|
  # lets ignore license check for now
  conf.skip_license_check << /.*/
end

# convert source HTML file to destination TXT file suitable for automatic
# spell check
def site_html2txt(file)
  puts "Converting #{file}..."
  doc = Nokogiri::HTML(File.read(file))
  # remove some parts (tags) completely
  doc.css('script, link, code').remove
  target_file = file.gsub(/\A\.\/_site/, "./_site.txt")
  target_file.sub!(/html\z/, "txt")
  FileUtils.mkdir_p(File.dirname(target_file))
  # squeeze the extra white space, replace Unicode single quote by ASCII
  # (it's not handled properly by the aspell spell checker)
  text = doc.text.gsub(/^ *$\n/, "").squeeze(" ").gsub("’", "'")
  File.write(target_file, text)
end

# Convert all HTML file into plain text to read only the plain text in the spell
# check (to ignore HTML tags, embedded JavaScript, Liquid/Jekyll code, etc...).
# It converts the "_site" content to "_site.txt" directory.
task txt: [:build] do
  require "nokogiri"
  FileUtils.rm_rf("_site.txt")
  Dir["./_site/**/*.html"].each do |f|
    site_html2txt(f)
  end
end

task "check:spelling": :txt

desc "Run the tests"
task test: [:build, :"check:spelling"] do
  # check the HTML structure and verify that the links are valid
  sh("bundle exec htmlproofer ./_site --check-html --only-4xx --allow-hash-href" \
    " --assume-extension --url-ignore \"/categories#/,/tags#/,#top\"")
end

desc "Build the HTML pages, the result is saved to the \"_site\" subdirectory"
task :build do
  sh("bundle exec jekyll build")
end

desc "Start the Jekyll server and automatically rebuild the pages on change"
task :server do
  sh("bundle exec jekyll server --watch")
end

task default: :test

