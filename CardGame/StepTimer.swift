
import Foundation

protocol CallBack_TimerChange {
    func timerChanged(seconds: Int)
}
class StepTimer {
    var callback: CallBack_TimerChange?
    var timer: Timer?
    
    var seconds: Int = 0

    init(callback: CallBack_TimerChange) {
        self.callback = callback
    }
    
    func startTimer(seconds: Int) {
        self.seconds = seconds
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: secondly(t:))
    }
    
    func secondly(t: Timer) {
        seconds -= 1
       
        if (seconds <= 0) {
            t.invalidate()
            seconds = 0
        }
        
        callback?.timerChanged(seconds: seconds)
    }
}

