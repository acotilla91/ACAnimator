Pod::Spec.new do |s|
    s.name             = 'ACAnimator'
    s.version          = '1.0.1'
    s.summary          = 'Animate anything on iOS or tvOS'
    
    s.description      = <<-DESC
    ACAnimator lets you animate almost anything on iOS or tvOS (including non-animatable properties). Can also be used to "animate" logical changes not just visual (e.g. fade in/out audio). It supports over 30 different easing functions and it uses `CADisplayLink` for optimal performance.
    DESC
    
    s.homepage         = 'https://github.com/acotilla91/ACAnimator'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Alejandro Cotilla' => 'acotilla91@gmail.com' }
    s.source           = { :git => 'https://github.com/acotilla91/ACAnimator.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/acotilla91'
    
    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
    s.swift_version = '5.0'
    
    s.source_files = 'ACAnimator/Classes/**/*'
    
end
