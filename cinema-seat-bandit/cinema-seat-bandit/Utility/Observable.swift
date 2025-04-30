import Foundation

final class Observable<T> {
    var onChange: ((T) -> Void)?
    
    var value: T {
        didSet {
            onChange?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        self.onChange = closure
        // 바인딩할 때 현재 값도 전달
        closure(value)
    }
}
