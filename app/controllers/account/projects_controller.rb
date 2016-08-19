class Account::ProjectsController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to account_projects_path, notice: "项目创建成功"
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])
    @project.is_hidden = true
    if @project.update(project_params)
      flash[:notice] = "项目更新成功"
      redirect_to account_projects_path
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    plans = @project.plans
    plans.destroy
    @project.destroy
    flash[:alert] = "项目删除成功"
    redirect_to :back
  end

  def publish
    @project = Project.find(params[:id])
    @project.publish!
    redirect_to :back
  end

  def hide
    @project = Project.find(params[:id])
    @project.hide!
    redirect_to :back
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :fund_goal, :image, :is_hidden)
  end
end
