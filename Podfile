# Uncomment the next line to define a global platform for your project
platform :ios, '13.4'

target 'Tracker' do
  use_frameworks!

  pod 'YandexMobileMetrica/Dynamic', '4.5.2'

  target 'TrackerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
    end
  end
end