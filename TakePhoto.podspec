Pod::Spec.new do |s|
s.name         = 'TakePhoto'
s.version      = '1.0.0'
s.summary      = 'A TakePhoto Tool for iOS Developer'
s.homepage     = 'https://github.com/csfuwwc/TakePhoto'
s.license      = 'MIT'
s.authors      = {'csfuwwc' => 'csfuwwc@126.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/csfuwwc/TakePhoto.git', :tag => s.version}
s.source_files = 'TakePhoto/HeaderFile.h'
s.public_header_files = 'TakePhoto/HeaderFile.h'
s.requires_arc = true
end