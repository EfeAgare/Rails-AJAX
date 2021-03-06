class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:create]

  def create
    @comment = @post.comments.create(comment_params)
    redirect_to @post
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.post, notice: "Comment updated."
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.post, notice: "Comment successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end