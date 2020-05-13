class SearchService
  
  SCOPES = %w[thinking_sphinx question answer comment user].freeze

  def self.call(search_params)
    return unless SCOPES.include?(search_params[:scope])

    query = search_params[:query]
    scope = search_params[:scope]
    
    klass_search = scope.classify.constantize
    klass_search.search ThinkingSphinx::Query.escape(query)
  end
end
