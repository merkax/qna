module ApplicationHelper
  def javascript_link_tag(link)
    render inline: '<script src=' + link.url + '.js></script>'
  end
end
