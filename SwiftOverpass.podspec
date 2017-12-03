Pod::Spec.new do |spec|
  spec.name = "SwiftOverpass"
  spec.version = "1.0.0"
  spec.summary = "A wrapper of Overpass API."
  spec.homepage = "https://github.com/holyturt/SwiftOverpassWrapper"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Sho Kamei" => 'holyturt@gmail.com' }
  spec.social_media_url = "http://twitter.com/kameaulait"

  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/holyturt/SwiftOverpassWrapper.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "SwiftOverpass/**/*.{h,swift}"

  spec.dependency 'AEXML', '~> 4.2.2'
  spec.dependency 'Alamofire', '~> 4.5'
end