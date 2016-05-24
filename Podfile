# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'soccer5' do
pod 'Alamofire', '~> 3.2.1’
pod 'AlamofireImage', '~> 2.0'
pod 'Bolts'
pod 'FBSDKCoreKit'
pod 'FBSDKShareKit'
pod 'FBSDKLoginKit'
pod 'IQKeyboardManagerSwift'
pod 'ENSwiftSideMenu', '~> 0.1.1'
pod 'ElasticTransition'
pod 'AKPickerView-Swift'
pod 'THCalendarDatePicker', '~> 1.2.6'
pod 'Firebase', '>= 2.5.1'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'

# AWS related frameworks
pod 'AWSCore'
pod 'AWSS3'
pod 'AWSCognito'

# Image caching
pod 'Kingfisher', '~> 2.3'
end

post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`

end
target 'soccer5Tests' do

end

