require 'mongrel_cluster/recipes'

set :application, "xuanjianghui"
set :scm, "?"
set :repository,  "?"
set :branch, "master"
set :user, "?"
set :use_sudo, false
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "?"
role :web, "?"
role :db,  "?", :primary => true

task :after_update_code do 
  run "cp #{current_release}/config/database.yml.production #{current_release}/config/database.yml"
  run "cp #{current_release}/config/xiaonei.yml.production #{current_release}/config/xiaonei.yml"
end
