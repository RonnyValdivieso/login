class PostsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_post, only: [:show, :edit, :update, :destroy, :like]
	before_action :owned_post, only: [:edit, :update, :destroy]

=begin
	def index
		@posts = Post.all.order('created_at DESC').page params[:page]
	end
=end

	def show		
	end

	def new
		@user = User.find(current_user.id)
		@user.posts.build
	end

	def create
		@user = User.find(current_user.id)
		@post = @user.posts.build(post_params)
		if @post.save
			flash[:success] = "Your post has been created!"
			redirect_to root_path
	    else
			flash[:alert] = "Your new post couldn't be created!  Please check the form."
			render :new
	    end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			flash[:success] = "Post updated."
			redirect_to root_path
	    else
			flash[:alert] = "Update failed.  Please check the form."
			render :edit
	    end
=begin
		@post = Post.find(params[:id])
		@post.update(post_params)
		redirect_to(post_path(@post))
=end
	end

	def destroy
		p @post
		@post.destroy
		redirect_to root_path
	end

	private

	def post_params
		params.require(:post).permit(:image, :caption)
	end

	def set_post
		@post = Post.find(params[:id])
	end

	def owned_post
	    unless current_user.id == @post.user.id
			flash[:alert] = "That post doesn't belong to you!"
			redirect_to root_path
	    end
	end
end
