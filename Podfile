# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def podTest()
	pod 'Quick'
    pod 'Nimble'
end

target 'XcodeGenSample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for XcodeGen-Sample

  target 'XcodeGenSampleTests' do
    inherit! :search_paths
    # Pods for testing
	podTest()
  end
end

target 'AppResources' do
	use_frameworks!
	pod 'R.swift'
end
