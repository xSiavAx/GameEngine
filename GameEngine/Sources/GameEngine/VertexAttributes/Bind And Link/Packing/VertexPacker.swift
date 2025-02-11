final class VertexPacker {
    static func pack<T: PackingVertex>(
        _ vertices: [T], 
        properties: [KeyPath<T, PackingBoundVertexAtttribute>],
        _ block: (_ address: UnsafeRawPointer, _ size: Int) -> Void
    ) -> [LinkingVertextAttribute]? {
        let filtered = vertices.map { vertex in properties.map { vertex[keyPath: $0] } }
        guard let first = filtered.first else { return nil }
        let links = first.map { $0.bound }
        let size = vertices.count * links.stride
        let bytesPtr = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: 1)
        var offsetPtr = bytesPtr
        let sample = vertices.first!

        defer { bytesPtr.deallocate() }

        for properties in filtered {
            for property in properties {
                property.value.pack(into: &offsetPtr)
            }
        }

        block(bytesPtr, size)

        return T.attributes.map {
            return LinkingVertextAttribute(enabled: properties.contains($0), attribute: sample[keyPath: $0].bound)
        }
    }
}
