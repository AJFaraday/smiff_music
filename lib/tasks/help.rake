namespace :help do

  desc 'Build single help file'
  task :build => :environment do
    result = "# SMIFF music help\n\n"
    result << I18n.t('help.file_warning')
    result = "\n\n"

    Help.pages.each do |page|
      result << page['content']
      if page['children']
        page['children'].each do |child|
          result << child['content']
          if child['children']
            child['children'].each do |grandchild|
              result << grandchild['content']
            end
          end
        end
      end
    end

    file_path = File.join(Rails.root, 'docs', 'help', 'help.html')
    File.delete(file_path)
    File.open(file_path, 'w') do |file|
      file.write(result)
    end
  end


end