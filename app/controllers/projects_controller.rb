class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def entry
    @project = Project.new # これがないと、「ArgumentError in Projects#entry」になる。
    @c_proj = current_user.projects
    user_repos = JSON.parse(RestClient.get('https://api.github.com/user/repos',
                              {:params => {:access_token => current_user.github_token}}))
    # user_repos = JSON.parse(`curl -H "Authorization: token #{current_user.github_token}" https://api.github.com/user/repos`)
    @form_repos = user_repos.map { |t| [t['name'], t['full_name']]}
    # DB から登録済みのプロジェクトを取得し、一覧から削除する。
    # @form_repos -= @c_proj.map { |t| [t.name, t.name] }
    @form_repos -= @c_proj.map { |t| [t.name, t.owner + '/' + t.name] }

  end

  def edit
    @project = Project.find(params[:id])
  end

  def show
    # 1. 要素を全て「未獲得」で埋めたリストを作る： @trophy_list
    trophies = Trophy.all
    trophy_num = trophies.count

    @trophy_list = Array.new()
    @trophy_date_list = Array.new()

    # 2. 獲得済み trophy を取得
    @project = Project.find(params[:id])
    @ach_trophy_ids = @project.achieve_trophy.pluck(:trophy_id)

    # 3. 1.に代入する
    trophy_num.times do |t_No|
      if @ach_trophy_ids.include?(trophies[t_No].id)
        # 獲得済み
        @trophy_list.push(
            [trophies[t_No], 
              trophies[t_No].created_at.in_time_zone('Tokyo').strftime('%Y/%m/%d')]
          )
      else
        # 未獲得
        @trophy_list.push( [Trophy.new(
            name: "『？』",
            img_path: "TrophyYagis/futu_yagi.png",
            sentence: trophies[t_No].condition,
            condition: ""
          ), 
          '????/??/??']
        )
      end
      #@trophy_list[ach_t_id-unach_trophy.id] = Trophy.find(ach_t_id)
    end
  end


  def create
    if params[:project]['name'].nil?
      redirect_to users_path
      return
    end
    # https://api.github.com/repos/M-82s7503/enpit2018_webapp3/commits/develop
    # みたく、最後に /develop 追加すると、developブランチ のを取得できた。
    commit_logs = JSON.parse(RestClient.get('https://api.github.com/repos/' + params[:project]['name'] + '/commits',
                              {:params => {:access_token => current_user.github_token}}))

    project = Project.new()
    own_pro_name_list = params[:project]['name'].split('/')
    project.name = own_pro_name_list[1]
    project.owner = own_pro_name_list[0]
    project.users_id = current_user.id
    project.day_interval = params[:project]["day_interval"]
    project.day_counter = params[:project]["day_interval"]
    project.goat_eat_speed = params[:project]["goat_eat_speed"]
    project.commit_num = get_commit_num(commit_logs, current_user.username)

    if project.save
      project.save_commit_log(commit_logs)
      NotificationMailer.add_project_notification(project).deliver_later
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

  def update
    project = Project.find(params[:id])
    project.update(day_interval: params[:project][:day_interval], goat_eat_speed: params[:project][:goat_eat_speed])
    redirect_to users_path
  end

  private

  def get_commit_num(commit_logs, name)
    if commit_logs.class != Array
      0
    else
      commit_name_list = commit_logs.map{ |t| t['commit']['committer']['name']}
      commit_name_list.select{|t| t == name}.length
    end
  end
end
