Pod::Spec.new do |s|
  s.name         = 'TakePhoto'
  s.version      = '1.0.2'
  s.summary      = 'A TakePhoto Tool for iOS Developer'

  s.homepage     = 'https://github.com/csfuwwc/TakePhoto'
  s.authors      = {'csfuwwc' => 'csfuwwc@126.com'}
  s.source       = {:git => 'https://github.com/csfuwwc/TakePhoto.git', :tag => s.version}
  s.source_files = 'TakePhoto/TakePhoto.{h,m}','TakePhoto/TakePhotosList/*.{h,m}','TakePhoto/TakePhotosDetail/*.{h,m}'
  s.public_header_files = 'TakePhoto/TakePhoto.h','TakePhoto/TakePhotosList/*.h','TakePhoto/TakePhotosDetail/*.h'
  s.requires_arc = true


  s.subspec 'Other' do |ss|
  
     ss.source_files = 'TakePhoto/Other/{MDPresentTransition,SystemManager,BoomPresentView}.{h,m}'
     ss.public_header_files = 'TakePhoto/Other/{MDPresentTransition,SystemManager,BoomPresentView}.h'

  end

  s.subspec 'UIKit' do |ss|

     ss.source_files = 'TakePhoto/Other/{UIImage+More,UIView+More}.{h,m}'
     ss.public_header_files = 'TakePhoto/Other/{UIImage+More,UIView+More}.{h,m}'

  end

end