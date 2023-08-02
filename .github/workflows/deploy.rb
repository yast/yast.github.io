#! /usr/bin/env ruby

# Publish the page preview at surge.sh using the "surge" tool
# See https://surge.sh/help/getting-started-with-surge
# The access tokens are set at
# https://github.com/yast/yast.github.io/settings/secrets/actions
# For security reasons this does not work across forks.
# Additionally it reports the status and the target URL back to GitHub.

require "octokit"
require "yaml"

# secure variable not present, cannot deploy
if ENV["SURGE_TOKEN"].to_s.empty?
  puts "Cannot deploy a preview, required credentials not available!"
  puts "The credentials are not available in GitHub forks!"
  puts
  puts "You still might want to build and publish the preview manually,"
  puts "see https://surge.sh/help/getting-started-with-surge."
  exit 0
end

# create an Octokit client for communication with GitHub
def client
  return @client if @client
  @client = Octokit::Client.new(:access_token => ENV["GH_STATUS_TOKEN"])
  @client
end

def pull_request?
  ENV["GITHUB_EVENT_NAME"] == "pull_request"
end

# make an unique domain name for the preview, based on the branch name or
# the pull request number
def domain
  return @domain if @domain

  repo_user = ENV["GITHUB_REPOSITORY"].split("/", 2).first

  # use a repo user prefix if this is a fork
  if repo_user == "yast"
    repo_user = ""
  else
    repo_user << "-"
  end

  refs = (ENV["GITHUB_REF"] || "").split("/")

  if pull_request?
    # for pull requests the ref is "refs/pull/<pr_number>/merge"
    domain_id = "pull-#{refs[-2]}"
  else
    # for pushes the ref is "refs/heads/<branch_name>"
    domain_id = "#{repo_user}branch-#{refs.last}"
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
  sha = ENV["GITHUB_SHA"]
  repo = ENV["GITHUB_REPOSITORY"]

  opts = {
    description: description
  }
  opts[:target_url] = url if status == "success"
  opts[:context] = pull_request? ? "site-preview-pr" : "site-preview"

  puts "Setting GitHub status, repo: #{repo}, sha: #{sha}, status: #{status}, opts: #{opts.inspect}"

  client.create_status(repo, sha, status, opts)
end

# report success at GitHub
def report_success
  set_status("success", pull_request? ? "PR Preview" : "Branch Preview")
end

# report failure at GitHub and exit
def report_failure_and_exit
  set_status("failure", "Preview failed!")
  exit 1
end

# update the configuration - change the site URL to the preview target
def update_config
  puts "Updating the config, target URL: #{url}"
  conf_file = "_config.yml"
  config = YAML.load_file(conf_file)
  config["url"] = url
  File.write(conf_file, config.to_yaml)
end

puts "Rebuilding the pages with the new target URL..."
update_config
report_failure_and_exit unless system("bundle exec jekyll build")

puts "Publishing the pages..."
report_failure_and_exit unless system("npx surge --project ./_site --domain #{domain}")

report_success
puts "\nFinished, see the #{url} page for the site preview."

