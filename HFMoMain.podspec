#
# Be sure to run `pod lib lint HFMoMain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HFMoMain'
  s.version          = '0.1.0'
  s.summary          = '主结构'
  s.description      = <<-DESC
APP住结构组件
                       DESC
  s.homepage         = 'https://github.com/Components-iOS/HFMoMain'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuhongfei' => '13718045729@163.com' }
  s.source           = { :git => 'https://github.com/Components-iOS/HFMoMain.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.dependency 'HFRouter'

  s.subspec 'PublicAPI' do |p|
      p.source_files = 'HFMoMain/Classes/PublicAPI/**/*'
      p.dependency 'HFMoMain/Controller'
      p.dependency 'HFMoMain/View'
  end
  
  s.subspec 'Controller' do |c|
      c.source_files = 'HFMoMain/Classes/Controller/**/*'
      c.dependency 'HFMoMain/View'
  end
  
  s.subspec 'View' do |v|
      v.source_files = 'HFMoMain/Classes/View/**/*'
  end
end
