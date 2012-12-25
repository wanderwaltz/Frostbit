Pod::Spec.new do |spec|
	spec.name         = 'Frostbit'
	spec.version      = '0.0.1'   

	spec.author       = { 'Egor Chiglintsev' => 'wanderwaltz@gmail.com' }                                                               
	spec.license	  = { :type => 'MIT', :file => 'LICENSE.txt' }
	spec.homepage     = 'https://github.com/wanderwaltz/Frostbit'

	spec.summary      = 'A multi-purpose Objective-C library for use with Cocoa Touch projects mostly.'
	
	spec.platform     = :ios
	spec.source       = { :git => 'git://github.com/wanderwaltz/Frostbit.git', :commit => :head }
	
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