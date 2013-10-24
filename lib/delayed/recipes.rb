# Capistrano Recipes for managing delayed_job
#
# Add these callbacks to have the delayed_job process restart when the server
# is restarted:
#
#   after "deploy:stop",    "delayed_job:stop"
#   after "deploy:start",   "delayed_job:start"
#   after "deploy:restart", "delayed_job:restart"
#
# If you want to use command line options, for example to start multiple workers,
# define a Capistrano variable delayed_job_args:
#
#   set :delayed_job_args, "-n 2"
#
# If you've got delayed_job workers running on a servers, you can also specify
# which servers have delayed_job running and should be restarted after deploy.
#
#   set :delayed_job_server_role, :worker
#

namespace :delayed_job do
  def args
    fetch(:delayed_job_args, "")
  end

  def delayed_job_roles
    fetch(:delayed_job_server_role, :app)
  end

  desc "Stop the delayed_job process"
  task :stop do
    on roles delayed_job_roles do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :delayed_job, 'stop'
        end
      end
    end
  end

  desc "Start the delayed_job process"
  task :start do
    on roles delayed_job_roles do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :delayed_job, "stop #{args}"
        end
      end
    end
  end

  desc "Restart the delayed_job process"
  task :restart do
    on roles delayed_job_roles do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :delayed_job, "restart #{args}"
        end
      end
    end
  end
end
