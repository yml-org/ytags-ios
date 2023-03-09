//
//  TagView.swift
//  YTags
//
//  Created by Dev Karan on 23/02/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YMatterType
import YCoreUI

/// A view that represents a `Tag`.
open class TagView: UIView {
    /// An image view to display the optional icon.
    public let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// A label to display text.
    public let titleLabel: TypographyLabel = {
        let label = TypographyLabel(typography: .systemLabel)
        label.numberOfLines = 0
        return label
    }()
    
    /// An optional close button.
    public let closeButton = UIButton()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    /// Close button delegate.
    weak var delegate: TagViewCloseButtonDelegate?
    
    // Constraints
    private var iconHeight: NSLayoutConstraint?
    private var iconWidth: NSLayoutConstraint?
    private var closeButtonHeight: NSLayoutConstraint?
    private var closeButtonWidth: NSLayoutConstraint?
        
    /// Appearance for `Tag`.
    public var appearance: TagView.Appearance {
        didSet {
            updateViewAppearance()
        }
    }
    
    /// Initializes a tag view.
    /// - Parameters:
    ///   - title: title.
    ///   - appearance: tag appearance.
    public init(title: String, appearance: TagView.Appearance = .default) {
        self.titleLabel.text = title
        self.appearance = appearance
        super.init(frame: .zero)
        
        build()
        updateViewAppearance()
    }

    /// :nodoc:
    required public init?(coder: NSCoder) { nil }

    /// :nodoc:
    open override func layoutSubviews() {
        super.layoutSubviews()

        updateShape()
    }
    
    /// Unit testing
    internal func simulateTagDidClose() {
        tagDidClose()
    }
}

private extension TagView {
    func build() {
        buildViews()
        buildConstraints()
        setupCloseButton()
    }
    
    func buildViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(closeButton)
    }
    
    func buildConstraints() {
        stackView.constrainEdges(with: appearance.layout.contentInset)
    }
    
    func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(tagDidClose), for: .touchUpInside)
        closeButton.accessibilityIdentifier = AccessibilityIdentifiers.buttonId
    }
    
    func updateViewAppearance() {
        backgroundColor = appearance.backgroundColor
        layer.borderColor = appearance.borderColor.cgColor
        layer.borderWidth = appearance.borderWidth
        titleLabel.textColor = appearance.title.textColor
        titleLabel.typography = appearance.title.typography
        stackView.spacing = appearance.layout.gap
        updateIcon()
        updateCloseButton()
        updateShape()
    }
    
    func updateIcon() {
        iconImageView.image = appearance.icon?.image
        iconImageView.isHidden = !appearance.hasIcon
        iconImageView.tintColor = appearance.icon?.tintColor
        
        if let iconSize = appearance.icon?.size,
           iconHeight == nil {
            let icon = iconImageView.constrainSize(iconSize)
            iconHeight = icon[.height]
            iconWidth = icon[.width]
        } else {
            iconHeight?.constant = appearance.icon?.size.height ?? 0
            iconWidth?.constant = appearance.icon?.size.width ?? 0
        }
    }
    
    func updateCloseButton() {
        closeButton.isHidden = !appearance.hasCloseButton
        closeButton.tintColor = appearance.closeButton?.tintColor
        closeButton.setImage(appearance.closeButton?.image, for: .normal)
        closeButton.accessibilityLabel = appearance.closeButton?.accessibilityLabel
        
        if let iconSize = appearance.closeButton?.size,
           closeButtonHeight == nil {
            let icon = closeButton.constrainSize(iconSize)
            closeButtonHeight = icon[.height]
            closeButtonWidth = icon[.width]
        } else {
            closeButtonHeight?.constant = appearance.closeButton?.size.height ?? 0
            closeButtonWidth?.constant = appearance.closeButton?.size.width ?? 0
        }
    }
    
    func updateShape() {
        switch appearance.shape {
        case .capsule:
            layer.cornerRadius = bounds.height * 0.5
        case .rectangle:
            layer.cornerRadius = 0
        case .roundRect(let radius):
            layer.cornerRadius = radius
        }
    }
    
    @objc func tagDidClose() {
        delegate?.tagDidClose(self)
    }
}
