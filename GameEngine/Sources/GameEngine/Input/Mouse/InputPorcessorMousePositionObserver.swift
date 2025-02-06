import OpenCombineShim

extension InputProcessor.Mouse {
    final class PositionObserver {
        let onChange: (_ x: Double, _ y: Double) -> Void

        init(onChange: @escaping (_ x: Double, _ y: Double) -> Void) {
            self.onChange = onChange
        }

        func setOnCancel(_ onCancel: @escaping () -> Void) -> AnyCancellable {
            return AnyCancellable {
                onCancel()
            }
        }
        
        func fire(x: Double, y: Double) {
            onChange(x, y)
        }
    }
}