// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


#if os(macOS)
// let platformsSystem:[Package.platforms] = [.iOS(.V10)]
let platformDependencies:[Package.Dependency] = []
let platformTargets:[Target] = [
          .target(
	   name:"LPTableView",
 	   path:"Sources",
	  linkerSettings:[
             .linkedFramework("UIKit")
	  ]
	 ),
]
let platformProducts :[Product] = [
   .library(name:"LPTableView",targets:["LPTableView"]),
]

// let linkerSystemSetting:[LinkerSetting] = [
//  .linkedFramework("UIKit")
// ]

#endif 

// let package = Package( 
//	name:"LPTableView",
//        platforms:[.iOS(.v10)],
//	products:platformProducts,
//	dependencies:platformDependencies,
//	targets:platformTargets,
//	swiftLanguageVersions:[.v5]
//)


 let package = Package(
    name: "LPTableView",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
           name: "LPTableView",
            targets: ["LPTableView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LPTableView",
            dependencies: [],
	    path:"Sources",
	    linkerSettings:[
             .linkedFramework("UIKit")
          ]
          ),
        .testTarget(
            name: "LPTableViewTests",
            dependencies: ["LPTableView"]),
    ]
)
