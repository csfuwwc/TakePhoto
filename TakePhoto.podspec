Pod::Spec.new do |s|
s.name         = 'TakePhoto'
s.version      = '1.0.1'
s.summary      = 'A TakePhoto Tool for iOS Developer'
s.description  = <<-DESC
                   A TakePhoto Tool for iOS Developer.
                   DESC
s.homepage     = 'https://github.com/csfuwwc/TakePhoto'
s.license      = 'MIT'
s.authors      = {'csfuwwc' => 'csfuwwc@126.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/csfuwwc/TakePhoto.git', :tag => s.version}
s.source_files  = 'TakePhoto/**/*.{h,m}','TakePhoto/Other/Masonry/*.{h,m}'
s.requires_arc = true
end