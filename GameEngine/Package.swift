// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Windows)
let platform = PlatformSettings.windows
#else
let platform = PlatformSettings.linux
#endif

let shaders = [
    "VertexShader", "FragmentShader"
]

let package = Package(
    name: "GameEngine",
    dependencies: [
    ],
    targets: 
    platform.targets([
        "C_GLFW",
        "C_GL"
    ]) + [
        .target(name: "C_GLAD"),
        .executableTarget(
            name: "GameEngine",
            dependencies: platform.dependencies([
                "C_GLFW",
                "C_GL",
            ]) + [
                "C_GLAD"
            ],
            exclude: platform.exclude,
            resources: platform.resourceToCopy() + shaders.asShadersResources(),
            linkerSettings: platform.linkerSettings()
        )
    ]
)

struct PlatformSettings {
    let systemLibSuffix: String
    let linkerFlags: [String]
    let copy: [String]
    let exclude: [String]

    static let windows = PlatformSettings(
        systemLibSuffix: "WIN",
        linkerFlags: ["-lglfw3dll"],
        copy: ["Resources/DynamicLibraries/glfw3.dll"],
        exclude: [] 
    )

    static let linux = PlatformSettings(
        systemLibSuffix: "LIN",
        linkerFlags: [""],
        copy: [],
        exclude: ["glfw3.dll"]
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

extension Array where Element == String {
    func asShadersResources() -> [Resource] {
        return map { .copy("Resources/Shaders/\($0).gs") }
    }
}
