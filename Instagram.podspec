Pod::Spec.new do |s|
s.name             = 'Instagram'
s.version          = '0.1.0'
s.summary          = 'By far the most Instagram view I have seen in my entire life. No joke.'

s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
DESC

s.homepage         = 'https://github.com/<milanVarasada11398>/Instagram'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '<Milan>' => '<milan.varasada@solutionanalysts.com>' }
s.source           = { :git => 'https://github.com/<milanVarasada11398>/InstagramCloneApp.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'Instagram/Instagram.swift'

end
