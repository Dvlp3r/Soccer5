# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'soccer5' do
pod 'Alamofire', '~> 3.2.1’
pod 'AlamofireImage', '~> 2.0'
pod ‘Bolts‘
pod ‘FBSDKCoreKit‘
pod ‘FBSDKShareKit‘
pod ‘FBSDKLoginKit‘
pod 'IQKeyboardManagerSwift'
pod 'SlideMenuControllerSwift’, ‘~> 2.0.3'
pod "ElasticTransition"
end

post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`

end
target 'soccer5Tests' do

end

