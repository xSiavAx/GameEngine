protocol Releasable: AnyObject {
    func release()
}

class ClosureReleasable: Releasable {
    var onRelease: (() -> Void)?

    init(onRelease: (() -> Void)? = nil) { 
        self.onRelease = onRelease
    }

    func release() {
        onRelease?()
        onRelease = nil
    }

    deinit {
        release()
    }
}

final class AnyReleasable: ClosureReleasable {
    private let wrappe: Releasable

    init<C: Releasable>(wrappe: C) {
        self.wrappe = wrappe
        super.init() {
            wrappe.release()
        }
    }
}

extension AnyReleasable: Equatable {
    static func == (lhs: AnyReleasable, rhs: AnyReleasable) -> Bool {
        return lhs.wrappe === rhs.wrappe
    }
}

extension AnyReleasable: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(wrappe))
    }
}

extension Releasable {
    func erase() -> AnyReleasable {
        return AnyReleasable(wrappe: self)
    }

    func store(into bag: inout Set<AnyReleasable>) {
        bag.insert(self.erase())
    }
}
