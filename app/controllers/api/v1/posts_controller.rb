module Api
  module V1
    class PostsController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :authenticate, only: [:create, :destroy]

      def index
        @posts = Post.all.order('created_at DESC')
      end

      def create
        @post = @user.posts.new(post_params)
        if @post.save
          render json: @post, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @post = @user.posts.find_by(params[:id])
        if @post
          @post.destroy
        else
          render json: {post: "not found"}, status: :not_found
        end
      end

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          @user = User.find_by(token: token)
        end
      end


      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
