class TextileController < ApplicationController
  def show
    render :inline => RedCloth.new(params[:textile]).to_html
  end
end
