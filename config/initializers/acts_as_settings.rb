require Rails.root.join('lib',"acts_as_setting.rb")
ActiveRecord::Base.send(:include,     Alces::Acts::SettingsModel)
