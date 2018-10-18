class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def entry
    # ↓ これがないと、「ArgumentError in Projects#entry」になる。
    @project = Project.new
    @c_proj = current_user.projects
    user_repos = JSON.parse(`curl https://api.github.com/users/#{current_user.username}/repos`)
    @form_repos = user_repos.map{|t| [t['name'], t['name']]}
=begin
    print( "\n\n【@form_repos】\n")
    print(@form_repos)
    print( "\n\n【current_user.projects】\n" )
    print( @c_proj.map{|t| [t.name, t.name]} )
=end
    # DB から登録済みのプロジェクトを取得し、一覧から削除する。
    @form_repos = @form_repos - @c_proj.map{|t| [t.name, t.name]}
=begin
    print( "\n\n【@form_repos 改】\n" )
    print(@form_repos)
    print( "\n\n" )
=end
  end

  def show
    id = params[:id]
    @commit_logs = GithubCommitLog.where(project_id: id)
  end

  def create
    @project = Project.new()
    @project.name = params[:project]["name"]
    @project.users_id = current_user.id
    @project.commit_num = get_commit_num(params[:project]["name"])
    if @project.save
      save_commit_log(@project)
      redirect_to users_index_path
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      redirect_to project_entry_path
    end
  end

  private

  def get_commit_num(name)
    commit_logs = JSON.parse(`curl https://api.github.com/repos/#{current_user.username}/#{name}/commits`)
    if commit_logs.class != Array
      0
    else
      commit_logs.length
    end
  end

  def save_commit_log(project)
    commit_logs = JSON.parse(`curl https://api.github.com/repos/#{current_user.username}/#{project.name}/commits`)
    return 0 if commit_logs.class != Array
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
