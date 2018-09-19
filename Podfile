platform :ios, '9.0'
install! 'cocoapods',:deterministic_uuids => false
target 'SmartMain' do
    inhibit_all_warnings!
	use_frameworks!

   	pod 'Moya' 
	pod 'Moya/RxSwift'
	pod 'RxDataSources'
    pod 'SnapKit'
    pod 'EZSwiftExtensions', :git => 'https://github.com/goktugyil/EZSwiftExtensions.git', :branch => 'swift4tag' 
  	pod 'IQKeyboardManagerSwift'
	pod 'ObjectMapper'
    pod 'SwiftyJSON'
	pod 'SVProgressHUD', :git => 'https://github.com/Fidetro/SVProgressHUD.git'
	pod 'Kingfisher'
   	pod 'VTMagic'   , :git => 'https://github.com/aycgithub/VTMagic.git'
#    pod 'FSPagerView'
	pod 'MJRefresh'
	pod 'DZNEmptyDataSet'
    	pod 'KMNavigationBarTransition'
        pod 'ReachabilitySwift'
        pod 'FCUUID'
        pod 'Hyphenate', '~> 3.5.1'
#        pod 'EaseUI', :git => 'https://github.com/easemob/easeui-ios-hyphenate-cocoapods.git'
#        pod 'SwiftMQTT'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
