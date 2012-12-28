Pod::Spec.new do |spec|
	spec.name         = 'Frostbit'
	spec.version      = '0.0.1'   

	spec.author       = { 'Egor Chiglintsev' => 'wanderwaltz@gmail.com' }                                                               
	spec.license	  = { :type => 'MIT', :file => 'LICENSE.txt' }
	spec.homepage     = 'https://github.com/wanderwaltz/Frostbit'

	spec.summary      = 'A multi-purpose Objective-C library for use with Cocoa Touch projects mostly.'
	
	spec.platform     = :ios, '6.0'
	spec.source       = { :git => 'https://github.com/wanderwaltz/Frostbit.git', :commit => :head }

	# Subspecs (modules)
	spec.subspec 'Common' do |common|
		common.source_files = 'Frostbit/Common/**/*.{h,m}'
	end

	spec.subspec 'Geometry' do |geometry|
    	geometry.source_files = 'Frostbit/Geometry/**/*.{h,m}'
    	geometry.framework    = 'CoreGraphics'
	end


	spec.subspec 'Dispatch' do |dispatch|
    	dispatch.source_files = 'Frostbit/Dispatch/**/*.{h,m}'
    	dispatch.requires_arc = true
	end

	# CommonCrypto subspec contains functions for easy access of
	# the <CommonCrypto/CommonDigest.h> functionality. 
	spec.subspec 'CommonCrypto' do |commonCrypto|
		commonCrypto.source_files = 'Frostbit/CommonCrypto/*.{h,m}'
		commonCrypto.requires_arc = true

		commonCrypto.subspec 'Functions' do |functions|
			functions.source_files = 'Frostbit/CommonCrypto/Functions/**/*.{h,m}'
		end

		commonCrypto.subspec 'Categories' do |categories|

			categories.subspec 'NSData' do |nsdata|
				nsdata.source_files = 'Frostbit/CommonCrypto/Categories/NSData/**/*.{h,m}'
			end


			categories.subspec 'NSString' do |nsstring|
				nsstring.source_files = 'Frostbit/CommonCrypto/Categories/NSString/**/*.{h,m}'
			end
		end
	end


	# UIKit subspec contains Cocoa Touch UI classes dependent on UIKit frameworks
	# Each individual UI element will be available as a separate subspec, also
	# bundles of all UI classes and all UI categories will be available as subspecs
	spec.subspec 'UIKit' do |uikit|
		uikit.source_files = 'Frostbit/UIKit/*.{h,m}'
		uikit.framework    = 'UIKit'
		uikit.requires_arc = true

		# UI classes
		uikit.subspec 'Classes' do |uiclasses|
			uiclasses.subspec 'FRBDatePickerPopover' do |dpp|
				dpp.source_files   = 'Frostbit/UIKit/Classes/FRBDatePickerPopover/**/*.{h,m}'
			
				dpp.dependency 'Frostbit/UIKit/Categories/UIViewController'
			end
		end

		# UI categories
		uikit.subspec 'Categories' do |uicategories|
			uicategories.subspec 'UIViewController' do |vc|
				vc.source_files   = 'Frostbit/UIKit/Categories/UIViewController/**/*.{h,m}'
			end
		end
	end



end