class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  #If the user has viewed fewer than 3 pages, render a JSON response with the article data.

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1
    unless session[:page_views] > 3
    article = Article.find(params[:id])
    render json: article
    else
      render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
