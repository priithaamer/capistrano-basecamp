require 'yaml'
require 'basecamp'

Capistrano::Configuration.instance(:must_exist).load do

  # Before starting with deploy, get the current version from the server
  before 'deploy' do
    set(:git_initial_sha, capture("cd #{current_path}; git rev-parse --verify HEAD").strip)
  end
  
  # After deploy, post the message to basecamp.
  after 'deploy' do
    post = self.fetch(:basecamp_post) do
      if Capistrano::CLI.ui.ask("Post changelog to Basecamp? (Y)") == 'Y'
        'auto'
      else
        false
      end
    end
    
    if 'auto' == post
      basecamp.post_message
    end
  end

  namespace :basecamp do
    desc <<-DESC
      After deploy, post changelog message to basecamp.
      
        set :basecamp_host,   'mycompany.basecamp.com'
    DESC
    task :post_message do
      set(:git_final_sha, capture("cd #{release_path}; git rev-parse --verify HEAD").strip)
      
      if git_initial_sha != git_final_sha
        basecamp_host = self.fetch(:basecamp_host)
        logger.info "Posting message to Basecamp (#{basecamp_host})"
        
        user_data = Hash.new
        
        if File.exists?(File.join(ENV['HOME'], '.basecamp.capistrano'))
          user_data = YAML::load(File.read(File.join(ENV['HOME'], '.basecamp.capistrano'))).fetch(basecamp_host) rescue nil
        end
        
        unless user_data
          logger.info "Please enter your Basecamp username and password for #{basecamp_host} future reference"
          user_data = {
            :username => Capistrano::CLI.ui.ask("Username:").strip,
            :password => Capistrano::CLI.ui.ask("Password:").strip
          }
          File.open(File.join(ENV['HOME'], '.basecamp.capistrano'), 'w') { |f| f.write({basecamp_host => user_data}.to_yaml) }
          logger.debug "Your Basecamp credentials have been written to #{File.join(ENV['HOME'], '.basecamp.capistrano')}"
        end
      
        basecamp_username = self.fetch(:basecamp_username, user_data[:username])
        basecamp_password = self.fetch(:basecamp_password, user_data[:password])
        basecamp_ssl = self.fetch(:basecamp_ssl, true)
        basecamp_project = self.fetch(:basecamp_project)
      
        git_log = `git log --pretty=oneline --abbrev-commit #{git_initial_sha}..#{git_final_sha} #{branch}`
      
        Basecamp.establish_connection!(basecamp_host, basecamp_username, basecamp_password, basecamp_ssl)
        message = Basecamp::Message.new(:project_id => basecamp_project)
        message.title = "#{rails_env.capitalize} update #{DateTime.now.strftime('%d.%m.%Y %H:%M')}"
        message.body = git_log.split("\n").inject('') { |memo, row| memo << "* #{row}\n" }
        if self.exists?(:basecamp_category)
          message.category_id = self.fetch(:basecamp_category)
        end
        message.save
      end
    end
  end
end
