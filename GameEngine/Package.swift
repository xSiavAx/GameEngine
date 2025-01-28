// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Windows)
let platform = PlatformSettings.windows
#elseif os(Linux)
let platform = PlatformSettings.linux
#else
let platform = PlatformSettings.macos
#endif

let shaders = ["VertexShader", "FragmentShader"]

let textures = [
    "awesomeface.png",
    "wooden_box.jpg",
]

let platforms: [Platform] = [
    .macOS(.v10_15),
    .windows,
    .linux,
]

let package = Package(
    name: "GameEngine",
    platforms: platforms,
    dependencies: [
        .package(path: "../MapReduce"),
        .package(url: "https://github.com/keyvariable/kvSIMD.swift.git", from: "1.0.0"),
        .package(url: "https://github.com/OpenSwiftUIProject/OpenCombine.git", from: "0.15.1"),
    ],
    targets: platform.targets([
        "C_GLFW",
        "C_GL",
    ]) + [
        .target(name: "C_GLAD"),
        .target(name: "C_STB_Image"),
        .executableTarget(
            name: "GameEngine",
            dependencies: platform.dependencies([
                "C_GLFW",
                "C_GL",
            ]) + [
                "C_GLAD",
                "C_STB_Image",
                "MapReduce",
                .product(name: "kvSIMD", package: "kvSIMD.swift"),
                .product(name: "OpenCombineShim", package: "opencombine")
            ],
            exclude: platform.exclude,
            resources: platform.resourceToCopy() + shaders.asShadersResources() + textures.asTextureResources(),
            linkerSettings: platform.linkerSettings()
        )
    ]
)

struct PlatformSettings {
    let systemLibSuffix: String
    let linkerFlags: [String]
    let copy: [String]
    let exclude: [String]

    static let glfwDll = "Resources/DynamicLibraries/glfw3.dll"

    static let windows = PlatformSettings(
        systemLibSuffix: "WIN",
        linkerFlags: ["-lglfw3dll"],
        copy: [glfwDll],
        exclude: [] 
    )

    static let linux = PlatformSettings(
        systemLibSuffix: "LIN",
        linkerFlags: [""],
        copy: [],
        exclude: [glfwDll]
    )

    static let macos = PlatformSettings(
        systemLibSuffix: "MAC",
        linkerFlags: [""],
        copy: [],
        exclude: [glfwDll]
    )

    func libName(_ name: String) -> String {
        return "\(name)_\(systemLibSuffix)"
    }

    func targets(_ names: [String]) -> [Target] {
        return names.map { .systemLibrary(name: libName($0)) }
    }

    func dependencies(_ names: [String]) -> [Target.Dependency] {
        return names.map(libName).map(Target.Dependency.init(stringLiteral:))
    }

    func resourceToCopy() -> [Resource] {
        return copy.map { .copy($0) }
    }

    func linkerSettings() -> [LinkerSetting] {
        return [.unsafeFlags(linkerFlags)]
    }
}

private extension Array where Element == String {
    func asShadersResources() -> [Resource] {
        return map { .copy("Resources/Shaders/\($0).gs") }
    }

    func asTextureResources() -> [Resource] {
        return map { .copy("Resources/Textures/\($0)") }
    } 
}
