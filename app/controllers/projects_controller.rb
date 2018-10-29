class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def entry
    @project = Project.new # これがないと、「ArgumentError in Projects#entry」になる。
    @c_proj = current_user.projects
    user_repos = JSON.parse(`curl https://api.github.com/users/#{current_user.username}/repos`)
    @form_repos = user_repos.map { |t| [t['name'], t['name']] }
    # DB から登録済みのプロジェクトを取得し、一覧から削除する。
    @form_repos -= @c_proj.map { |t| [t.name, t.name] }
  end

  def show
    id = params[:id]
    @commit_logs = GithubCommitLog.where(project_id: id)
  end

  def create
    if params[:project]['name'].nil?
      redirect_to users_path
      return
    end
    @project = Project.new()
    @project.name = params[:project]["name"]
    @project.users_id = current_user.id
    @project.day_interval = params[:project]["day_interval"]
    @project.goat_eat_speed = params[:project]["goat_eat_speed"]
    # https://api.github.com/repos/M-82s7503/enpit2018_webapp3/commits/develop
    # みたく、最後に /develop 追加すると、developブランチ のを取得できた。
    commit_logs = JSON.parse(`curl https://api.github.com/repos/#{current_user.username}/#{@project.name}/commits`)
    @project.commit_num = get_commit_num(commit_logs)
    if @project.save
      @project.save_commit_log(commit_logs)
      NotificationMailer.add_project_notification(@project).deliver_now
      redirect_to users_path
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      redirect_to project_entry_path
    end
  end

  def destroy
    project = Project.find(params[:project_id])
    project.github_commit_logs.destroy_all
    project.destroy
    redirect_to users_path
  end

  private

  def get_commit_num(commit_logs)
    if commit_logs.class != Array
      0
    else
      commit_logs.length
    end
  end
end
