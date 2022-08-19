//
//  SlidingView.swift and HolderSlidingView.swift
//  custom sliding view with shadows that expands to full screen
//
//  Created by BorisElkin on 18.08.2022.
//

import Foundation
import UIKit

// MARK: SlidingView and supporting data
class SlidingView: UIView {
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var parentHeightWithoutSafeArea: CGFloat!
    
    var lastIterationFrame: CGRect! // is used for iterations
    var topPosFrame: CGRect!
    var naturalYFrame: CGRect!
    
    var settings: SlidingViewSettings!
    
    var delegate: SlidingViewFadeManager?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        addGestureRecognizer(panGestureRecognizer!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCornerRadius(){
        clipsToBounds = true
        layer.cornerRadius = settings.topCornerRadius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setUpWithMainSettings(parentView: UIView, settings: SlidingViewSettings){
        self.settings = settings
        setCornerRadius()
        parentHeightWithoutSafeArea = parentView.frame.height - settings.safeAreaHeight
        parentView.addSubview(self)
        frame = CGRect(x: 0, y: parentView.frame.maxY, width: parentView.frame.width, height: parentView.frame.height - settings.topAreaHeightWithSafeArea)
        
        // Set up initial values
        naturalYFrame = CGRect(x: 0, y: parentView.frame.height - frame.height, width: self.frame.width, height: frame.height)
        topPosFrame = CGRect(x: 0,
                            y: settings.safeAreaHeight,
                            width: self.frame.width,
                            height: parentHeightWithoutSafeArea)
        
        // this line is for DidSet to work properly
        self.percentsOfBottomArea = 0
        UIView.animate(withDuration: settings.slideInAnimationTime, animations: {
            self.frame = self.naturalYFrame
            self.percentsOfTopArea = 0
            self.percentsOfBottomArea = 1
        }, completion: { (isCompleted) in
            if isCompleted {
                self.lastIterationFrame = self.frame
            }
        })
    }
    
    func setUpContents(contentView: UIView){
        print("setting up table view")
        self.addSubview(contentView)
        
        contentView.fillSuperview()
    }
    
    func closeSlidingView(){
        UIView.animate(withDuration: settings.snapAnimationTime, animations: {
            self.frame = self.frame.offsetBy(dx: 0, dy: self.frame.height)
            self.percentsOfTopArea = 0
            self.percentsOfBottomArea = 0
        }, completion: { (isCompleted) in
            if isCompleted {
                self.removeFromSuperview()
            }
        })
    }
    
    @objc private func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: self)
        
        if panGesture.state == .changed {
            let sizeChange:CGFloat = CGFloat(translation.y)
            self.frame = CGRect(x: self.frame.origin.x,
                                y: max(settings.safeAreaHeight, self.lastIterationFrame.origin.y + sizeChange),
                                width: self.frame.width,
                                height: min(parentHeightWithoutSafeArea, self.lastIterationFrame.height - sizeChange))
            
            calculateFadeAndNotifyDelegate()
            
            //print("percentsOfTopArea: \(percentsOfTopArea), percentsOfBottomArea: \(percentsOfBottomArea)")
        }
        else if panGesture.state == .ended {
            self.lastIterationFrame = frame

            let middlePointToSwipeTop = naturalYFrame.minY / 2
            let middlePointToSwipeOut = naturalYFrame.minY + naturalYFrame.size.height / 2
            
            var finalRect: CGRect = CGRect.zero
            var fadeResultOfTopArea: CGFloat = 0
            var fadeResultOfBottomArea: CGFloat = 0
            
            var isClosing = false
            var isExpanding = false
            if self.frame.minY < middlePointToSwipeTop { // swipe top
                finalRect = topPosFrame
                fadeResultOfTopArea = 1
                fadeResultOfBottomArea = 1
                isExpanding = true
            } else if self.frame.minY > middlePointToSwipeOut { // swipe out/close
                finalRect = self.frame.offsetBy(dx: 0, dy: self.frame.height)
                isClosing = true
                fadeResultOfTopArea = 0
                fadeResultOfBottomArea = 0
            } else { // snap to middle
                finalRect = naturalYFrame
                fadeResultOfTopArea = 0
                fadeResultOfBottomArea = 1
                // This thing with 'expanding or not' is to make sure there's not gaps in the process of size change because
                // only origin of view interpolates with animation for some reason, so, we change size when it's not visible by user
                if self.frame.minY < naturalYFrame.minY{ // snap to middle frop top
                    // add code if you need to execute something in this case
                }else{ // snap to middle frop bottom
                    isExpanding = true
                }
            }
            
            UIView.animate(withDuration: settings.snapAnimationTime, animations: {
                if(isExpanding){
                    self.frame = finalRect
                }else{
                    self.frame.origin = finalRect.origin
                }
                print("self.frame.height: \(self.frame.height)")
                self.percentsOfTopArea = fadeResultOfTopArea
                self.percentsOfBottomArea = fadeResultOfBottomArea
            }, completion: { (isCompleted) in
                if isCompleted {
                    if(!isExpanding){
                        self.frame = finalRect
                    }
                    
                    self.frame.size = finalRect.size
                    if(isClosing){
                        self.removeFromSuperview()
                        self.delegate?.slidingViewDestroyed()
                    }else {
                        self.lastIterationFrame = self.frame
                    }
                }
            })
        }
    }
    
    private var percentsOfTopArea: CGFloat = 0
    private var percentsOfBottomArea: CGFloat = 0 {
        didSet {
            delegate?.onFadeChange(topAreaFadePercents: percentsOfTopArea, bottomAreaFadePercents: percentsOfBottomArea)
        }
    }
    
    private func calculateFadeAndNotifyDelegate(){
        percentsOfTopArea = self.frame.minY > naturalYFrame.minY ? 0 : (1 - (self.frame.minY - settings.safeAreaHeight) / settings.topAreaHeight)
        percentsOfBottomArea = self.frame.minY < naturalYFrame.minY ? 1 : (1 - ((self.frame.minY - naturalYFrame.minY) / settings.bottomAreaHeight))
        delegate?.onFadeChange(topAreaFadePercents: percentsOfTopArea, bottomAreaFadePercents: percentsOfBottomArea)
    }
    
    deinit{
        print("Sliding view is about to get deinitialized")
    }
    
    public static func remap(value: CGFloat, from1: CGFloat, to1: CGFloat, from2: CGFloat, to2: CGFloat) -> CGFloat {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2
    }
}

struct SlidingViewSettings {
    var totalHeightWithSafeArea: CGFloat
    var topAreaHeight: CGFloat
    var safeAreaHeight: CGFloat
    var topAreaHeightWithSafeArea: CGFloat!
    var bottomAreaHeight: CGFloat!
    
    var slideInAnimationTime: CGFloat
    var snapAnimationTime: CGFloat
    var topCornerRadius: CGFloat
    
    init(totalHeightWithSafeArea: CGFloat, topAreaHeight: CGFloat, safeAreaHeight: CGFloat, slideInAnimationTime: CGFloat = 0.4, snapAnimationTime: CGFloat = 0.3, topCornerRadius: CGFloat = 15){
        self.totalHeightWithSafeArea = totalHeightWithSafeArea
        self.topAreaHeight = topAreaHeight
        self.safeAreaHeight = safeAreaHeight
        self.topAreaHeightWithSafeArea = safeAreaHeight + topAreaHeight
        self.bottomAreaHeight = totalHeightWithSafeArea - topAreaHeightWithSafeArea
        
        self.slideInAnimationTime = slideInAnimationTime
        self.snapAnimationTime = snapAnimationTime
        self.topCornerRadius = topCornerRadius
    }
}

protocol SlidingViewFadeManager {
    func onFadeChange(topAreaFadePercents: CGFloat, bottomAreaFadePercents: CGFloat)
    
    func slidingViewDestroyed()
}

// MARK: HolderSlidingView and supporting data
class HolderSlidingView: UIView {
    
    private var holderSettings: HolderSlidingViewSettings!
    private var slidingSettings: SlidingViewSettings!
    weak var slidingView: SlidingView?
    
    private lazy var topFade: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var bottomFade: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setUpWithMainSettings(parentView: UIView, holderSettings: HolderSlidingViewSettings, slidingSettings: SlidingViewSettings){
        self.holderSettings = holderSettings
        self.slidingSettings = slidingSettings
        
        parentView.addSubview(self)
        frame = CGRect(x: parentView.frame.minX, y: parentView.frame.minY, width: parentView.frame.width, height: parentView.frame.height) // parentView.frame.height - settings.topAreaHeightWithSafeArea)
        
        addSubview(topFade)
        topFade.frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: slidingSettings.topAreaHeightWithSafeArea)
        
        addSubview(bottomFade)
        bottomFade.frame = CGRect(x: 0, y: slidingSettings.topAreaHeightWithSafeArea, width: parentView.frame.width, height: slidingSettings.bottomAreaHeight)
        
        // MARK: set up sliding view
        let slidingView = SlidingView()
        slidingView.delegate = self
        slidingView.setUpWithMainSettings(parentView: self, settings: slidingSettings)
        self.slidingView = slidingView
    }
    
    func setUpContents(contentView: UIView){
        slidingView?.setUpContents(contentView: contentView)
    }
    
    deinit{
        print("holder sliding view is about to get deinitialized")
    }
}

extension HolderSlidingView: SlidingViewFadeManager {
    func slidingViewDestroyed() {
        self.removeFromSuperview()
    }
    
    func onFadeChange(topAreaFadePercents: CGFloat, bottomAreaFadePercents: CGFloat) {
        
        let topFadeValue: CGFloat = SlidingView.remap(value: topAreaFadePercents, from1: 0, to1: 1, from2: 0, to2: holderSettings.topFadeColorMaxAlpha)
        let bottomFadeValue: CGFloat = SlidingView.remap(value: bottomAreaFadePercents, from1: 0, to1: 1, from2: 0, to2: holderSettings.bottomFadeColorMaxAlpha)
        
        topFade.backgroundColor = holderSettings.topFadeColor.withAlphaComponent(topFadeValue)
        bottomFade.backgroundColor = holderSettings.bottomFadeColor.withAlphaComponent(bottomFadeValue)
    }
}

struct HolderSlidingViewSettings {
    var topFadeColor: UIColor
    var bottomFadeColor: UIColor
    var topFadeColorMaxAlpha: CGFloat = 1
    var bottomFadeColorMaxAlpha: CGFloat = 1
}

