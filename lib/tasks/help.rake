namespace :help do

  desc 'Build single help file'
  task :build => :environment do
    result = "# SMIFF music help\n\n"
    result << I18n.t('help.file_warning')
    result = "\n\n"

    Help.pages.each do |page|
      result << File.read(File.join(Rails.root, page['file']))
      if page['children']
        page['children'].each do |child|
          result << File.read(File.join(Rails.root, child['file']))
          if child['children']
            child['children'].each do |grandchild|
              result << File.read(File.join(Rails.root, grandchild['file']))
            end
          end
        end
      end
    end

    file_path = File.join(Rails.root, 'docs', 'help', 'help.md')
    File.delete(file_path)
    File.open(file_path, 'w') do |file|
      file.write(result)
    end
  end


end