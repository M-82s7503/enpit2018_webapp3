class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def entry
    @project = Project.new
  end

  def create
    @project = Project.new()
    @project.name = params[:project]["name"]
    @project.users_id = current_user.id
    @project.commit_num = get_commit_num()
    if @project.save
      save_commit_log(@project)
      redirect_to projects_entry_path
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      render 'projects/entry'
    end
  end

  private

  def get_commit_num
    commit_logs = JSON.parse(`curl https://api.github.com/repos/TakumiNomura/challing_web2/commits`)
    commit_logs.length
  end
  def save_commit_log(project)
    commit_logs = JSON.parse(`curl https://api.github.com/repos/TakumiNomura/challing_web2/commits`)
    for log in commit_logs do
      params = {}
      params['id'] = log['id']
      params['message'] = log['commit']['message']
      params['users_id'] = current_user.id
      params['project_id'] = project.id
      github_commit_logs = GithubCommitLog.new(params)
      github_commit_logs.save
    end
  end
end
