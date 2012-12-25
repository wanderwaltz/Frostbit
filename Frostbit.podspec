Pod::Spec.new do |spec|
	spec.name         = 'Frostbit'
	spec.version      = '1.0.0'   

	spec.author       = { 'Egor Chiglintsev' => 'egor.chiglintsev@gmail.com' }                                                               
	spec.license	  = 'MIT'
	spec.homepage     = ''

	spec.summary      = 'A multi-purpose Objective-C library for use with Cocoa Touch projects mostly.'
	
	spec.platform     = :ios
	spec.source       = { :git => ''}
	
	spec.source_files = 'Frostbit/Common/**/*.{h,m}'

	# Subspecs (modules)

	spec.subspec 'Geometry' do |geometry|
    	geometry.source_files = 'Frostbit/Geometry/**/*.{h,m}'
    	geometry.framework    = 'UIKit'
	end


	spec.subspec 'Dispatch' do |dispatch|
    	dispatch.source_files = 'Frostbit/Dispatch/**/*.{h,m}'
	end
end