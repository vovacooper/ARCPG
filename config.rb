require 'ostruct'
require 'redcarpet'

@config = OpenStruct.new(YAML.load(File.read("data/config.yml")));

activate :directory_indexes

set :haml, format: :html5
set :sass, line_comments: false, style: :nested

set :markdown, :layout_engine => :haml
set :markdown_engine, :redcarpet

set :base_dir, File.dirname(__FILE__)

set :css_dir, 'assets/stylesheets'

set :js_dir, 'assets/javascript'

set :images_dir, 'assets/images'

set :fonts_dir, 'assets/fonts'

set :partials_dir, 'layouts/partials'


helpers do
  def title_helper
    title = "#{@config.name} - #{data.page.title ? data.page.title : @config.title}"
    strip_tags(title)
  end
  def description_helper
    description = data.page.description ? "#{data.page.description}" : "#{@config.description}"
    strip_tags(description)
  end
  def keywords_helper
    keywords = data.page.tags ? "#{data.page.tags.join(",")}" : "#{@config.keywords.join(",")}"
    strip_tags(keywords)
  end

  def markdown_render(file_path)
    # Make this shit use middlemans markdown renderer
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    markdown.render File.read(File.join(settings.base_dir,'data', file_path))
  end

  # function: gets all files in posts, looks at the date, and gives back ordered by time (source of middleman-blog has something like that.)
end

# activate :i18n, :mount_at_root => :he

configure :build do
  set :build_dir, "tmp"

  set :sass, style: :compressed
  activate :asset_hash, :exts => ['.css']

  # Create favicon/touch icon set from source/favicon_base.png
  #activate :favicon_maker

  activate :minify_css
  activate :minify_javascript
  activate :minify_html

  #activate :relative_assets

  activate :gzip  
end
