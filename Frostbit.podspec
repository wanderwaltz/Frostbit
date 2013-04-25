Pod::Spec.new do |spec|
	spec.name         = 'Frostbit'
	spec.version      = '0.0.1'   

	spec.author       = { 'Egor Chiglintsev' => 'wanderwaltz@gmail.com' }                                                               
	spec.license	  = { :type => 'MIT', :file => 'LICENSE.txt' }
	spec.homepage     = 'https://github.com/wanderwaltz/Frostbit'

	spec.summary      = 'A multi-purpose Objective-C library for use with Cocoa Touch projects mostly.'
	
	spec.platform     = :ios, '6.0'
	spec.source       = { :git => 'https://github.com/wanderwaltz/Frostbit.git', :tag => '0.0.1' }
	#spec.source       = { :git => '.', :tag => '0.0.1', :branch => 'develop' }


	# Subspecs (modules)
	spec.subspec 'Headers' do |headers|
		headers.source_files = 'Frostbit/*.{h}'
	end

	spec.subspec 'Common' do |common|
		common.dependency 'Frostbit/Headers'
		common.source_files = 'Frostbit/Common/**/*.{h,m}'
		common.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_COMMON_INCLUDED=1' }
	end

	spec.subspec 'Geometry' do |geometry|
		geometry.dependency 'Frostbit/Common'
    	geometry.source_files = 'Frostbit/Geometry/**/*.{h,m}'
    	geometry.framework    = 'CoreGraphics'
    	geometry.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_GEOMETRY_INCLUDED=1' }
	end


	spec.subspec 'Dispatch' do |dispatch|
		dispatch.dependency 'Frostbit/Common'
    	dispatch.source_files = 'Frostbit/Dispatch/**/*.{h,m}'
    	dispatch.requires_arc = true
    	dispatch.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_DISPATCH_INCLUDED=1' }
	end


	spec.subspec 'DataStructures' do |dataStructures|
		dataStructures.dependency 'Frostbit/Common'
		dataStructures.requires_arc = true
		dataStructures.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_DATA_STRUCTURES_INCLUDED=1' }

		dataStructures.subspec 'Headers' do |headers|
			headers.source_files = 'Frostbit/DataStructures/*.h'
		end

		dataStructures.subspec 'FRBKeyedSet' do |keyedSet|
			keyedSet.dependency 'Frostbit/DataStructures/Headers'
			keyedSet.source_files = 'Frostbit/DataStructures/Classes/FRBKeyedSet/*.{h,m}'
			keyedSet.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_KEYED_SET_INCLUDED=1' }
		end
	end


	spec.subspec 'ManagedObjects' do |managedObjects|
		managedObjects.dependency 'Frostbit/Common'
		managedObjects.source_files = 'Frostbit/ManagedObjects/**/*.{h,m}'
		managedObjects.requires_arc = true
		managedObjects.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_MANAGED_OBJECTS_INCLUDED=1' }
	end



	# CommonCrypto subspec contains functions for easy access of
	# the <CommonCrypto/CommonDigest.h> functionality. 
	spec.subspec 'CommonCrypto' do |commonCrypto|
		commonCrypto.dependency 'Frostbit/Common'
		commonCrypto.requires_arc = true
		commonCrypto.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_COMMON_CRYPTO_INCLUDED=1' }

		commonCrypto.subspec 'Headers' do |headers|
			headers.source_files = 'Frostbit/CommonCrypto/*.h'
		end

		commonCrypto.subspec 'Functions' do |functions|
			functions.dependency 'Frostbit/CommonCrypto/Headers'
			functions.source_files = 'Frostbit/CommonCrypto/Functions/**/*.{h,m}'
			functions.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_COMMON_CRYPTO_FUNCTIONS_INCLUDED=1' }
		end

		commonCrypto.subspec 'Categories' do |categories|
			categories.dependency 'Frostbit/CommonCrypto/Headers'
			categories.xcconfig = { 'OTHER_CFLAGS' => '-DFRB_COMMON_CRYPTO_CATEGORIES_INCLUDED=1' }

			categories.subspec 'NSData' do |nsdata|
				nsdata.source_files = 'Frostbit/CommonCrypto/Categories/NSData/**/*.{h,m}'
				nsdata.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_COMMON_CRYPTO_NSDATA_CATEGORIES_INCLUDED=1' }
			end


			categories.subspec 'NSString' do |nsstring|
				nsstring.source_files = 'Frostbit/CommonCrypto/Categories/NSString/**/*.{h,m}'
				nsstring.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_COMMON_CRYPTO_NSSTRING_CATEGORIES_INCLUDED=1' }
			end
		end
	end


	# UIKit subspec contains Cocoa Touch UI classes dependent on UIKit frameworks
	# Each individual UI element will be available as a separate subspec, also
	# bundles of all UI classes and all UI categories will be available as subspecs
	spec.subspec 'UIKit' do |uikit|
		uikit.dependency 'Frostbit/Common'

		uikit.framework    = 'UIKit'
		uikit.requires_arc = true
		uikit.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_UIKIT_INCLUDED=1' }

		uikit.subspec 'Headers' do |headers|
			headers.source_files = 'Frostbit/UIKit/*.{h,m}'
		end

		# UI classes
		uikit.subspec 'Classes' do |uiclasses|
			uiclasses.dependency 'Frostbit/UIKit/Headers'
			uiclasses.xcconfig = { 'OTHER_CFLAGS' => '-DFRB_UICLASSES_INCLUDED=1' }

			uiclasses.subspec 'FRBDatePickerPopover' do |dpp|
				dpp.source_files = 'Frostbit/UIKit/Classes/FRBDatePickerPopover/**/*.{h,m}'
				dpp.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_UICLASSES_DATE_PICKER_POPOVER_INCLUDED=1' }

				dpp.dependency 'Frostbit/UIKit/Categories/UIViewController'
			end
		end

		# UI categories
		uikit.subspec 'Categories' do |uicategories|
			uicategories.dependency 'Frostbit/UIKit/Headers'
			uicategories.xcconfig = { 'OTHER_CFLAGS' => '-DFRB_UICATEGORIES_INCLUDED=1' }

			uicategories.subspec 'UIViewController' do |vc|
				vc.dependency 'Frostbit/Common'
				vc.source_files = 'Frostbit/UIKit/Categories/UIViewController/**/*.{h,m}'
				vc.xcconfig     = { 'OTHER_CFLAGS' => '-DFRB_UICATEGORIES_VIEW_CONTROLLER_INCLUDED=1' }
			end
		end
	end
end