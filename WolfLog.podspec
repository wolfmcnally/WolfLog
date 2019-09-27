Pod::Spec.new do |s|
    s.name             = 'WolfLog'
    s.version          = '2.0.3'
    s.summary          = 'A Swift framework for debug logging.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/wolfmcnally/WolfLog'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfLog.git', :tag => s.version.to_s }

    s.source_files = 'Sources/WolfLog/**/*'

    s.swift_version = '5.0'

    s.ios.deployment_target = '9.3'
    s.macos.deployment_target = '10.13'
    s.tvos.deployment_target = '11.0'

    s.module_name = 'WolfLog'

    s.dependency 'WolfCore'
end
