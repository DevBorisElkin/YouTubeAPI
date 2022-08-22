
import Foundation
import UIKit

// MARK: SearchTitleView
class SearchTitleView: UIView {
    
    let titleViewHeight: CGFloat = 44
    let searchButtonWidth: CGFloat  = 80
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    var previousTextState = false
    let animationDuration: Double = 0.5
    
    var selfFrame: CGRect?
    
    weak var onSearchExecutedDelegate: SearchTitleOnSearchExecuted?
    var lastSearchText: String = ""
    
    // Insets
    private let textFieldInsets = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    private let searchButtonInsets = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
    
    private var searchTextField = InsertableTextField()
    
    private var searchButton: AnimatedButton = {
        let button = AnimatedButton()
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        addSubviews()
        makeOtherSettings()
    }
    
    private func makeConstraints(){
        heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    private func addSubviews() {
        addSubview(searchTextField)
        addSubview(searchButton)
    }
    func makeOtherSettings(){
        searchTextField.textChangedDelegate = self
        searchButton.addTarget(self, action: #selector(onSearchButtonPressed), for: .touchUpInside)
        searchTextField.delegate = self
    }
    
    override var intrinsicContentSize: CGSize { UIView.layoutFittingExpandedSize }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if selfFrame == nil {
            selfFrame = frame
            
            searchTextField.frame = calculateSearchTextFieldFrame(textIsOn: false)
            searchButton.frame = calculateButtonFrame(textIsOn: false, textFieldFrame: searchTextField.frame)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init() - coder has not been implemented")
    }
    
    func calculateSearchTextFieldFrame(textIsOn: Bool) -> CGRect {
        let selfFrame = selfFrame ?? CGRect.zero
        if textIsOn {
            return CGRect(x: textFieldInsets.left,
                          y: textFieldInsets.top,
                          width: selfFrame.width - textFieldInsets.left - searchButtonWidth - searchButtonInsets.left - searchButtonInsets.right,
                          height: titleViewHeight - textFieldInsets.top - textFieldInsets.bottom)
        } else {
            return CGRect(x: textFieldInsets.left, y: textFieldInsets.top, width: selfFrame.width - textFieldInsets.left - textFieldInsets.right, height: titleViewHeight - textFieldInsets.top - textFieldInsets.bottom)
        }
    }
    
    func calculateButtonFrame(textIsOn: Bool, textFieldFrame: CGRect = .zero) -> CGRect {
        if textIsOn {
            return CGRect(x: textFieldFrame.maxX + searchButtonInsets.left, y: textFieldFrame.minY, width: searchButtonWidth, height: textFieldFrame.height)
        } else {
            return CGRect(x: screenWidth, y: searchTextField.frame.minY, width: searchButtonWidth, height: textFieldFrame.height)
        }
    }
    
    
    func animateViews(textState: Bool){
        let textFieldFrame = self.calculateSearchTextFieldFrame(textIsOn: textState)
        let buttonFrame = self.calculateButtonFrame(textIsOn: textState, textFieldFrame: textFieldFrame)
        
        UIView.animate(withDuration: animationDuration) {
            self.searchTextField.frame = textFieldFrame
            self.searchButton.frame = buttonFrame
        }
    }
    
    @objc private func onSearchButtonPressed(_ sender: Any?){
        guard !lastSearchText.isEmpty else {
            return
        }
        print("OnSearchExecuted: \(lastSearchText)")
        searchTextField.resignFirstResponder()
        onSearchExecutedDelegate?.onSearchExecuted(for: lastSearchText)
    }
}

// dismiss keyboard on 'return' pressed
extension SearchTitleView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.endEditing(true)
        return false
    }
}

extension SearchTitleView: TextFieldOnTextChangedDelegate {
    
    func onTextChanged(text: String, isNotEmpty: Bool) {
        
        lastSearchText = text
        
        if (previousTextState != isNotEmpty){
            previousTextState = isNotEmpty
            animateViews(textState: isNotEmpty)
        }
    }
}
// MARK: InsertableTextField
class InsertableTextField: UITextField{

    weak var textChangedDelegate: TextFieldOnTextChangedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = #colorLiteral(red: 0.9360918617, green: 0.9360918617, blue: 0.9360918617, alpha: 1)
        placeholder = "Search"
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true

        leftViewMode = .always

        let imageView = UIImageView(image: UIImage(named: "search_1"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        iconContainer.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        leftView = iconContainer
        
        setUpOnTextEdited()
    }

    func setUpOnTextEdited(){
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        textChangedDelegate?.onTextChanged(text: text, isNotEmpty: !text.isEmpty)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error with coder")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
}

protocol TextFieldOnTextChangedDelegate: AnyObject {
    func onTextChanged(text: String, isNotEmpty: Bool)
}
// search text is never empty
protocol SearchTitleOnSearchExecuted: AnyObject {
    func onSearchExecuted(for text: String)
}

// MARK: AnimatedButton

class AnimatedButton: UIButton {
    
    private var animationTime: Double = 0.2
    private var minScale: CGFloat = 0.93
    private var normalScale: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
        addTarget(self, action: #selector(buttonTouchedUp), for: .touchCancel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(animationTime: Double, minScale: CGFloat = 0.93){
        self.animationTime = animationTime
        self.minScale = minScale
    }
    
    @objc private func buttonTouchedDown(_ sender: Any?){
        UIView.animate(withDuration: self.animationTime) { [weak self] in
            if let self = self {
                self.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
            }
        }
    }
    @objc private func buttonTouchedUp(_ sender: Any?){
        UIView.animate(withDuration: self.animationTime) { [weak self] in
            if let self = self {
                self.transform = CGAffineTransform(scaleX: self.normalScale, y: self.normalScale)
            }
        }
    }
}
