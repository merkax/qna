class SearchController < ApplicationController

  skip_authorization_check

  def index
    @results = SearchService.call(search_params)
  end
  
  private

  def search_params
    params.require(:search).permit(:query, :scope)
  end
  
end
