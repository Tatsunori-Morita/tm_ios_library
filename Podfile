# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

install! 'cocoapods',
            :warn_for_unused_master_specs_repo => false

target 'tm_ios_library' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'FMPhotoPicker', '~> 1.3.0'
  pod 'DKImagePickerController'
  pod 'CropViewController'

  # Pods for tm_ios_library

  target 'tm_ios_libraryTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'tm_ios_libraryUITests' do
    # Pods for testing
  end

end
