class Account::PostsController < AccountController
  before_action :find_project

  authorize_resource

  def index
    @posts = @project.posts.recent
  end

  def new
    @post = @project.posts.build
  end

  def create
    @post = @project.posts.build(post_params)
    if @project.save
      redirect_to account_project_posts_path, notice: "动态创建成功"
    else
      render :new
    end
  end

  def destroy
    @post = @project.posts.find(params[:id])
    @post.destroy
    redirect_to :back, alert: "动态删除成功"
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def post_params
    params.require(:post).permit(:description)
  end
end
