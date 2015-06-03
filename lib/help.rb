require 'github-markup'
require 'github/markup'
class Help

  cattr_accessor :pages

  def Help.pages
    if @@pages
      @@pages
    else
      @@pages = Help.load_pages
    end
  end

  def Help.load_pages
    @@help = YAML.load_file(File.join(Rails.root, 'config', 'help_pages.yml'))
    @@help.each { |x| Help.get_content(x) }
    @@help
  end

  def Help.get_content(hash)
    source = File.read(File.join(Rails.root, hash['file']))
    content = GitHub::Markup.render('.md', source)
    hash['content'] = content
    if hash['children']
      hash['children'].each do |child|
        Help.get_content(child)
      end
    end
  end

end