
Pod::Spec.new do |s|
  s.name             = 'MKReminder'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight and pure Swift implemented library for Responsive reminder.'
  s.swift_versions   = ['5.0']
  s.description      = <<-DESC
                        * multi-target combination
                        * Quick access
                       DESC

  s.homepage         = 'https://github.com/jackystd/MKReminder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'spring' => 'spring@gmail.com' }
  s.source           = { :git => "https://github.com/jackystd/MKReminder.git", :tag => s.version }
  s.ios.deployment_target = '13.0'

  s.source_files = 'MKReminder/*'
  s.weak_frameworks = "SwiftUI", "Combine"

end

