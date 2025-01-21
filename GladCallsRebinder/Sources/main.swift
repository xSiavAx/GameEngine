import Foundation

let input = """
 
"""

struct CIdentifier: CustomStringConvertible {
    let type: String
    let name: String

    var description: String { "\(type) \(name)" }

    init(rawString: String) {
        guard let sepratorIdx = rawString.lastIndex(of: " ") else { fatalError("Invalid Identifier \(rawString)") }
        let nameStart = rawString.index(sepratorIdx, offsetBy: 1)
        var type = String(rawString.prefix(upTo: sepratorIdx))
        var name = String(rawString.suffix(from: nameStart))

        while name.starts(with: "*") {
            name = String(name.suffix(name.count - 1))
            type += "*"
        }

        self.type = type
        self.name = name
    }

    func withName(prefix: String) -> String {
        return "\(type) \(prefix)\(name)"
    }
}

struct CFunction: CustomStringConvertible {
    let id: CIdentifier
    let arguments: [CIdentifier]

    var argumentsDescription: String { arguments.map { "\($0)" }.joined(separator: ", ") }
    var description: String { "\(id)(\(argumentsDescription))" }

    init(rawID: String, rawArguments: [String]) {
        self.id = CIdentifier(rawString: rawID)
        self.arguments = rawArguments.map { CIdentifier(rawString: $0) }
    }

    var asHeader: String { "\(signature);" }

    var asImplementation: String {
        return "\(signature) {\n    \(asBody)\n}\n"
    }

    var signature: String { "\(id.withName(prefix: "c_"))(\(argumentsDescription))" }

    var asCall: String {
        "\(id.name)(\(arguments.map(\.name).joined(separator: ", ")));"
    }

    var returnStmt: String? {
        return id.type == "void" ? nil : "return"
    }

    var asBody: String { [returnStmt, asCall].compactMap(\.self).joined(separator: " ") }
}

func getFunctions(input: String) -> [String] {
    return input
        .split(separator: ";\n")
        .map { String($0) }
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { $0.count > 0 }
}

func makeFunction(rawString: String) -> CFunction {
    guard let function = rawString
        .split(separator: ")")
        .first // remove ) and everything after
    else { fatalError("Can't find ) in \(rawString)") }
    let functionComponents = function.split(separator: "(").map { String($0) }
    let functionID = functionComponents.first!
    let functionArgs = makeArguments(components: functionComponents)

    return CFunction(rawID: functionID, rawArguments: functionArgs)
}

func makeArguments(components: [String]) -> [String] {
    guard components.count > 1 else { return [] }
    return components
            .last!
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
}

let functions = getFunctions(input: input)
    .map(makeFunction)

print("Header\n____________________")
print(functions.map(\.asHeader).joined(separator: "\n"))
print("--------------------------------")
print("Sources\n___________________")
print(functions.map(\.asImplementation).joined(separator: "\n"))