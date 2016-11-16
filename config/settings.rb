class Settings < Settingslogic
  source File.expand_path('settings.yml', __dir__)
  namespace ENV['SETTINGS_ENV'] || Rails.env
  load!
end
