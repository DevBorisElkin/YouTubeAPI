import UIKit

class PannableViewController: UIViewController {
    private var viewsOriginalTransform: CGAffineTransform!
    private var originalPosition: CGPoint?
    private var viewHeight: CGFloat!
    private var initialCornerRadius: CGFloat!
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private let initialScale: CGFloat = 1
    
    // default configuration
    private var panPercentageToDismiss: CGFloat = 0.2
    private var minVelocityToDismiss: CGFloat = CGFloat.greatestFiniteMagnitude
    private var scaleSetting: ScaleSetting = ScaleSetting(scaleStrength: CGPoint(x: 0, y: 0), targetPanPercentageForMaxResult: CGPoint(x: 0.1, y: 0.1))
    private var cornerRadiusSetting: CornerRadiusSetting = CornerRadiusSetting(maxCornerRadius: 0, panPercentageForMaxResult: 1)
    private var cancelAnimationTime: TimeInterval = 0.2
    private var closeAnimationTime: TimeInterval = 0.2
    
    // Don't forget to set correct presentation style
    //referenceToThisVC.modalPresentationStyle = .overCurrentContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsOriginalTransform = view.transform
        originalPosition = view.center
        viewHeight = view.bounds.size.height
        initialCornerRadius = view.layer.cornerRadius
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
    }
  
    /// Note that you don't need to call this method, hovewer, it's better to configure this VC to have all animation abilities
    /// Note that percentages 0% to 100% would be 0.0 to 1.0. So 55% would be 0.55
    func configureAnimationValues(
        panPercentageToDismiss: CGFloat? = nil, // 0.2 == 20% from top to dismiss, 0.9 == 90% from top and then dismissing
        minVelocityToDismiss: CGFloat? = nil, // 1500 = optimal value. If you swipe too fast and release = will close independant of panPercentageToDismiss parameter
        scaleSetting: ScaleSetting? = nil, // reult scale value, panPercentageForMaxResult -> 0.2 means max result will be achieved at 20% pan from top
        cornerRadiusSetting: CornerRadiusSetting? = nil,
        cancelAnimationTime: TimeInterval = 0.3,
        closeAnimationTime: TimeInterval = 0.3
    )
    {
        if let panPercentageToDismiss = panPercentageToDismiss {
            self.panPercentageToDismiss = panPercentageToDismiss
        }
        if let minVelocityToDismiss = minVelocityToDismiss {
            self.minVelocityToDismiss = minVelocityToDismiss
        }
        if let scaleSetting = scaleSetting {
            self.scaleSetting = scaleSetting
        }
        if let cornerRadiusSetting = cornerRadiusSetting {
            self.cornerRadiusSetting = cornerRadiusSetting
        }
        self.cancelAnimationTime = cancelAnimationTime
        self.closeAnimationTime = closeAnimationTime
    }
    
    /// example how to set up
    func configureWithOptimalValues(){
        configureAnimationValues(panPercentageToDismiss: 0.2,
                                  minVelocityToDismiss: 1500,
                                  scaleSetting: ScaleSetting(scaleStrength: CGPoint(x: 0.6, y: 0.6), targetPanPercentageForMaxResult: CGPoint(x: 0.07, y: 0.07)),
                                  cornerRadiusSetting: CornerRadiusSetting(maxCornerRadius: 15, panPercentageForMaxResult: 0.07))
    }
    
    @objc private func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downMovementAbsValue = CGFloat(max(translation.y, 0))
        let progress = CGFloat(fminf(downwardMovement, 1.0))
        
        let xScale = max(0, initialScale - (min(progress, scaleSetting.targetPanPercentageForMaxResult.x) * scaleSetting.scaleStrength.x))
        let yScale = max(0, initialScale - (min(progress, scaleSetting.targetPanPercentageForMaxResult.y) * scaleSetting.scaleStrength.y))
        
        let cornerRadius = min(PannableViewController.remap(value: progress, from1: 0, to1: cornerRadiusSetting.panPercentageForMaxResult, from2: 0, to2: cornerRadiusSetting.maxCornerRadius), cornerRadiusSetting.maxCornerRadius)

        if panGesture.state == .changed {
            // todo add ability to move up and to move by x
            view.frame.origin = CGPoint(
                x: view.frame.origin.x,
                y: downMovementAbsValue
            )
            view.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            view.layer.cornerRadius = cornerRadius
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= minVelocityToDismiss || progress >= panPercentageToDismiss {
                executeClosingAnimation()
            } else {
                executeCancelAnimation()
            }
        }
    }
    
    private func executeClosingAnimation(){
        UIView.animate(withDuration: cancelAnimationTime
                       , animations: {
            print("self.view.bounds: \(self.view.bounds)")
            print("self.view.frame: \(self.view.frame)")
            let boundsToApply = self.view.frame.offsetBy(dx: 0, dy: self.viewHeight)
            self.view.frame = boundsToApply
        }, completion: { (isCompleted) in
            if isCompleted {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    private func executeCancelAnimation(){
        UIView.animate(withDuration: closeAnimationTime, animations: {
            self.view.center = self.originalPosition!
            self.view.transform = self.viewsOriginalTransform
            self.view.layer.cornerRadius = self.initialCornerRadius
        })
    }
    
    struct ScaleSetting {
        var scaleStrength: CGPoint
        var targetPanPercentageForMaxResult: CGPoint
    }
    
    struct CornerRadiusSetting {
        var maxCornerRadius: CGFloat
        var panPercentageForMaxResult: CGFloat
    }
    
    public static func remap(value: CGFloat, from1: CGFloat, to1: CGFloat, from2: CGFloat, to2: CGFloat) -> CGFloat {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2
    }
}
