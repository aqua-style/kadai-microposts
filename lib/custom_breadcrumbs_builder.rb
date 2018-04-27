class CustomBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder

  def render
    puts '@content:' + @content.inspect
    puts 'elements:' + @elements.inspect
    @context.render "/layouts/breadcrumbs", elements: @elements
  end
end