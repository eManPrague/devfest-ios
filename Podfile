# Set pod sources
source 'git@git.eman.cz:eman-ios.git'
source 'https://github.com/CocoaPods/Specs.git'

# set correct minimum target ios version
platform :ios, '9.0'

# Use frameworks if our target platform is iOS8+
use_frameworks!

# Uncomment if all warnings from pods should be ignored
inhibit_all_warnings!

# Workspace
workspace 'Devfest.xcworkspace'

# workaround for transitive dependencies
#pre_install do |installer|
#    def installer.verify_no_static_framework_transitive_dependencies; end
#end

# DevFest
target 'Devfest' do
    # Project
    project 'Project/Riga/RigaDevDays.xcodeproj'
    
    # Firebase, Google, Facebook
    pod 'Firebase/Core'        
    pod 'Firebase/Database'    
    pod 'Firebase/Auth'       
    pod 'Firebase/RemoteConfig'
    
    pod 'TwitterKit',       '2.7'
    pod 'FirebaseUI',       '4.1.1'
    
    pod 'GoogleSignIn'
    pod 'GoogleMaps'
    #pod 'Google-Maps-iOS-Utils'
    
    pod 'FacebookCore',     '~> 0.2'
    pod 'FacebookLogin',    '~> 0.2'
    pod 'FacebookShare',    '~> 0.2'
    
    pod 'FBSDKCoreKit',     '~> 4.25.0'
    pod 'FBSDKLoginKit',    '~> 4.25.0'
    pod 'FBSDKShareKit',    '~> 4.25.0'
    
    # Other pods
    pod "HockeySDK"
    pod 'Kingfisher'
    pod 'RxSwift',          '~> 3.0'
    pod 'RxCocoa',          '~> 3.0'
    pod 'RxOptional',       '~> 3.1'
    pod 'SnapKit',          '~> 3.0.2'
    pod 'SDWebImage',       '~> 4.0'
end
