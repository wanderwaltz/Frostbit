Frostbit
========

A multi-purpose Objective-C set of classes/categories for use with Cocoa Touch projects mostly. 
This library contains solutions for problems which I've faced at various points of time while
working on iOS projects. Some of these are very specific to a certain task, others may be useful
in different scenarios.

I initially intended to use this library as a private scrapbook with snippets of code/useful classes,
but eventually decided to make it open just in case someone stumbles on it and finds something useful.

(This generally means that I'm not updating this library as frequently as I possibly should to make 
it an actual 'product')

Structure
---------

I'm trying to keep this as modular as possible without strong dependencies between the modules. 
The point is that 'multi-purpose' library is rarely needed as a whole in a single project. So
the goal is to allow extracting bits of the library and using these in your code without much
hassle.

To help achieving this result the library contains a podspec file to allow downloading it using
[CocoaPods](http://cocoapods.org). As more modules/classes will be added, I'll try to make all
of them available via subspecs of the main podspec. So including all the library into your project
won't be necessary.

This podspec is not yet available through the general specs repo, so if you'd like to use this library
with cocoapods, you'll need to setup your podfile as following:

    platform :ios, '6.0'
    pod 'Frostbit/Common', :git => 'https://github.com/wanderwaltz/Frostbit.git'

Please note that iOS6 SDK is required. This does not means that the library actyally *needs* the iOS6
SDK, but I simply don't want to check all the code to determine whether iOS6-specific APIs are being
used at some point. When (if?) the next SDK will be out, this lib and its podspec most probably will require
iOS7 etc. 

Current state
-------------

Current root directory structure/contents of the library is the following:

* **Common** - Some `#define` macros which I end up redefining in many of the projects. 
Aliases for standard types (such as `FRBFloat` for `double`) to have a common terminology
through the project.

* **CommonCrypto** - SHA1, MD5, Base64 as simple C functions and `NSString`, `NSData` categories for these.

* **DataStructures** - some special case data structures such as `FRBKeyedSet` for example which is a 
dictionary of `NSSets` and was created for a single purpose, but still seems worthy to be included here.
* **Dispatch** - GCD-related stuff and dispatching messages between objects. Currently contains the following:
    
    * *FRBDispatchFunctions* - contains GCD-based functions which implement `switch`-like constructions 
    allowing to perform a certain block depending on the `NSString` or `Class` argument passed. Sometimes it
    seems reasonable enough to have a piece of code look like `switch` statement, perform like `switch` statement,
    but switch the strings or classes instead of just ints.

    * *FRBKeyedTargetAction* - a class which allows sending multiple different messages to a single target object
    with the actual message being sent depending on the arbitrary `NSCopying`-compliant key. Another system
    which allows making a switch-like constructs for running code, but now `@selector`-based.

* **Geometry** - A couple of nice little functions for manipulating `CGPoint`s, `CGRect`s and `CGSize`s. All of these
are aliased to their FRB-prefixed cousins. So maybe at some point we'll go away from the Core Graphics and implement
these as fully custom structs.

* **ManagedObjects** - Not to confuse with `NSManagedObject`, not related to Core Data in any way. This module
contains a class which implements `NSDictionary`-based key-value storage with dynamic property accessor implementation.
So you generally can make a property, then add `@dynamic propertyName;` in the .m file and have this property's value 
stored in an internal `NSDictionary` maintained by `FRBManagedObject`. Seems useful for small model classes which
contain almost no methods, but a lot of properties.

* **UIKit** - UIKit-dependent small or not very small UI components.
