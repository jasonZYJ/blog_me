class BlogsController < ApplicationController

  layout 'shared/home'

  before_action :load_blogs, only: [:index, :show, :edit, :update, :destroy]

  def index
    @blogs = @blogs.page(params[:page]).per(15).includes(:category)
  end

  def show
    @blog = @blogs.find(params[:id])
  end

  def new
    @blog = Blog.new
  end

  # def index
  #   @blogs = Blog.visible.order("created_at desc").page(params[:page]).per(8)
  # end
  #
  # def show
  #   @blog = Blog.visible.find(params[:id])
  # end

  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user

    handle_save(@blog, 'blog')
  end

  def edit
    @blog = @blogs.find(params[:id])
  end

  def update
    @blog = @blogs.find(params[:id])
    
    handle_update(@blog, 'blog', blog_params)
  end

  def destroy
    @blog = @blogs.find(params[:id])
    @blog.destroy

    flash[:notice] = t('activerecord.message.blog.delete_successful')
    redirect_to admin_blogs_path
  end

  private

  def load_blogs
    @blogs ||= (resource_class.all.order('updated_at desc') || current_user.blogs) #TODO
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :category_id, :user_id, :status, :created_at)
  end
end
