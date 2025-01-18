protocol GLObjectName {
    var id: UInt32 { get }
}

class GLObjectNames<Name: GLObjectName> {
    typealias MakeName = (Int, UInt32) -> Name
    typealias OnGenerate = (Int32, UnsafeMutablePointer<UInt32>) -> Void
    typealias OnDelete = (Int32, UnsafePointer<UInt32>) -> Void

    private let onDelete: OnDelete

    let names: [Name]

    init(
        count: Int, 
        makeName: MakeName,
        generate: OnGenerate,
        delete: @escaping OnDelete
    ) {
        self.names = Self.initNames(count: count, makeName: makeName, generate: generate)
        self.onDelete = delete
    }

    private static func initNames(
        count: Int, 
        makeName: MakeName,
        generate: OnGenerate
    ) -> [Name] {
        let bufferPtr = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: count)

        defer { bufferPtr.deallocate() }

        if let ptr = bufferPtr.baseAddress {
            generate(Int32(count), ptr)
        }

        return (0..<count).map { idx in makeName(idx, bufferPtr[idx]) }
    }

    deinit {
        names.map(\.id).withUnsafeBufferPointer { ptr in
            guard let baseAddress = ptr.baseAddress else { return }
            onDelete(Int32(names.count), baseAddress);
        }
    }
}
