set :rvm_ruby_string, '1.9.3@bennu' 
# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rails_env, "production"
set :asset_env, "RAILS_GROUPS=assets"
# get Capistrano to ignore upload directories (Carrierwave)
# http://astonj.com/tech/how-to-get-capistrano-to-ignore-upload-directories-carrierwave/
set :shared_children, shared_children + %w{public/uploads}

require "rvm/capistrano"

# will bundle update after deploy
require "bundler/capistrano"


server "bennu.shanghai-tech.com", :web, :app, :db, primary: true

set :user, "shanghaitech"
set :application, "bennu.shanghai-tech.com"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

# source code is in a public github repo
set :scm, "git"
set :repository, "git@github.com:sguyon/bennu.git"
set :branch, "master"

ssh_options[:forward_agent] = true

before "deploy", "deploy:setup"

after 'deploy:update_code', 'deploy:migrate'
after 'deploy:update_code', 'deploy:assets:precompile'

# if you want to clean up old releases on each deploy uncomment this:
set :keep_releases, 7
after "deploy:restart", "deploy:cleanup"

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
    desc "Populates the Production Database"
    task :seed do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=production"
    end

    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end
end
namespace :log do
    desc "|DarkRecipes| Tail all application log files"
    task :tail, :roles => :app do
      run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end   
    task :info, :roles => :app do
      run "tail -f #{shared_path}/log/info.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end 
    end       
end
namespace :bundler do
  desc "|DarkRecipes| Installs bundler gem to your server"
  task :setup, :roles => :app do
    run "if ! gem list | grep --silent -e 'bundler'; then #{try_sudo} gem uninstall bundler; #{try_sudo} gem install --no-rdoc --no-ri bundler; fi"
  end
  
  desc "|DarkRecipes| Runs bundle install on the app server (internal task)"
  task :install, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle install --deployment --without=development test"
  end
end
namespace :deploy do
  # http://stackoverflow.com/questions/9016002/speed-up-assetsprecompile-with-rails-3-1-3-2-capistrano-deployment
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision) rescue nil
      
      if from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
    task :preforce, :roles => :web, :except => { :no_release => true } do
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end    
  end
end
namespace :deploy do
  task :cold do       # Overriding the default deploy:cold
    update
    load_schema       # My own step, replacing migrations.
    start
  end

  task :load_schema, :roles => :app do
    run "cd #{current_path}; rake db:schema:load RAILS_ENV=${rails_env}"
  end
end