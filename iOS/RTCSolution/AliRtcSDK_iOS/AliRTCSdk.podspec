Pod::Spec.new do |s|

  s.name         = "AliRTCSdk"
  s.version      = "1.19.3.2012296" 
  s.summary      = "AliRTCSdk_iOS"
  s.description  = <<-DESC
                   It's an SDK for aliyun video rtc, which implement by Objective-C.
                   DESC
  s.homepage     = "https://github.com/aliyunvideo/AliRtcSDK_iOS"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "aliyunvideo" => "videosdk@service.aliyun.com"}
  s.source       = { :git => "https://github.com/aliyunvideo/AliRtcSDK_iOS.git", :tag => "#{s.version}" }

  s.platform            = :ios, "8.0"
  s.requires_arc        = true
  s.pod_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => 'lObjC'
  }

  s.subspec 'AliRTCSdk' do |rtcsdk|
    rtcsdk.vendored_frameworks = 'AliRTCSdk.framework'
    # rtcsdk.resource = 'AlivcLibFaceResource.bundle'
    rtcsdk.frameworks = 'AudioToolbox','VideoToolbox','CoreVideo','CoreMedia','OpenGLES','AVFoundation','UIKit','CoreTelephony','SystemConfiguration'
    rtcsdk.libraries = 'c++','resolv'
  end

end
