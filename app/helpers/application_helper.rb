module ApplicationHelper
  def javascript_link_tag(link)
    render inline: '<script src=' + link.url + '.js></script>'
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
