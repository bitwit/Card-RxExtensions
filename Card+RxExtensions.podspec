Pod::Spec.new do |s|
  s.name             = "Card+RxExtensions"
  s.version          = "0.0.1"
  s.summary          = "Rx Extensions for Card"
  s.description      = "Includes RxDataSourceManager"
  s.license          = "MIT"

  s.homepage         = "http://www.bitwit.ca"
  s.author           = { "Kyle Newsome" => "kyle@bitwit.ca" }
  s.source           = { :git => "https://github.com/bitwit/Card+RxExtensions.git", :tag => s.version.to_s }

  s.ios.deployment_target = "11.0"
  s.tvos.deployment_target = "11.0"
  s.requires_arc = true

  s.source_files = 'Sources/**/*.swift'

  s.dependency 'Card'
  s.dependency 'RxSwift'

end
