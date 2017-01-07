namespace :custom do
  desc 'run rake db:seed'
  task :run_db_task do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:seed"
        end
      end
    end
  end
end
