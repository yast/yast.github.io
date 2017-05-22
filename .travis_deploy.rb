#! /usr/bin/env ruby

# Publish the page preview at surge.sh using the "surge" tool
# See https://surge.sh/help/getting-started-with-surge
# The access tokens are set at https://travis-ci.org/yast/yast.github.io/settings
# For security reasons this does not work across forks.
# Additionally it reports the status and the target URL back to GitHub.

require "octokit"
require "yaml"

# secure variables not present, cannot deploy
if ENV["TRAVIS_SECURE_ENV_VARS"] != "true"
  puts "Cannot deploy a preview, required credentials not available!"
  puts "You still might want to build and publish the preview manually,"
  puts "see https://surge.sh/help/getting-started-with-surge."
  exit 0
end

# create an Octokit client for communication with GitHub
def client
  return @client if @client
  @client = Octokit::Client.new(:access_token => ENV["GITHUB_ACCESS_TOKEN"])
  @client.user.login
  @client
end

def pull_request?
  ENV["TRAVIS_PULL_REQUEST"] != "false"
end

# make an unique domain name for the preview, based on the branch name or
# the pull request number
def domain
  return @domain if @domain

  repo_user = ENV["TRAVIS_REPO_SLUG"].split("/", 2).first

  # use a repo user prefix if this is a fork
  if repo_user == "yast"
    repo_user = ""
  else
    repo_user << "-"
  end

  if pull_request?
    domain_id = "pull-#{ENV["TRAVIS_PULL_REQUEST"]}"
  else
    domain_id = "#{repo_user}branch-#{ENV["TRAVIS_BRANCH"]}"
  end

  # make a valid domain name
  domain_id.downcase!
  domain_id.gsub!(/[^a-z0-9]/, "-")
  domain_id.gsub!(/\.\//, "-")

  @domain = "yast-#{domain_id}.surge.sh"
end

# full target preview URL
def url
  "https://#{domain}"
end

# set GitHub status
def set_status(status, description)
  sha = ENV["TRAVIS_PULL_REQUEST_SHA"]
  sha = ENV["TRAVIS_COMMIT"] if sha.empty?
  repo = ENV["TRAVIS_REPO_SLUG"]

  opts = {
    description: description
  }
  opts[:target_url] = url if status == "success"
  opts[:context] = pull_request? ? "site-preview-pr" : "site-preview"

  puts "Setting GitHub status, repo: #{repo}, sha: #{sha}, status: #{status}"

  client.create_status(repo, sha, status, opts)
end

# report success at GitHub
def report_success
  set_status("success", "Preview available")
end

# report failure at GitHub and exit
def report_failure_end_exit
  set_status("failure", "Preview failed!")
  exit 1
end

# update the configuration - change the site URL to the preview target
def update_config
  puts "Updating the config, target URL: #{url}"
  conf_file = "_config.yml"
  config = YAML.load_file(conf_file)
  config["url"] = url
  # allow rendering future posts for non-master branches
  config["future"] = true if ENV["TRAVIS_BRANCH"] != "master"
  File.write(conf_file, config.to_yaml)
end

puts "Rebuilding the pages with the new target URL..."
update_config
report_failure_and_exit unless system("bundle exec jekyll build")

puts "Publishing the pages..."
report_failure_and_exit unless system("`npm bin`/surge --project ./_site --domain #{domain}")

report_success
puts "\nFinished, see the #{url} page for the site preview."

