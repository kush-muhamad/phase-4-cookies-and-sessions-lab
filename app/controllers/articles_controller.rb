class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    if session[:page_views].to_i < 3
      session[:page_views] = session[:page_views].to_i + 1
    article = Article.find(params[:id])
    render json: article
    else
      render json: { error: "You need to be logged in to view extra pages" }, status: :unauthorized
  end
end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
