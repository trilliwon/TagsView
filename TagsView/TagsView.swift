//
//  TagsView.swift
//  TagsView
//
//  Created by Won on 2020/08/02.
//  Copyright © 2020 Won. All rights reserved.
//

import UIKit

final class TagsView: UIView {

	var didSelectTagItem: ((TagItem) -> Void) = { _ in }

	typealias TagItem = String
	typealias TagItemView = UIButton

	var tags: [TagItem] = [] {
		didSet {
			removeTagViews()
			layoutTagItemViews(tags, style: itemViewStyle)
		}
	}

	func removeTagViews() {
		verticalContainerStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
		layoutIfNeeded()
	}

	func layoutTagItemViews(_ tags: [TagItem], style: TagItemViewStyle) {

		let tagItemViews: [TagItemView] = tags.enumerated().map { createTagItemView(style: style, $0) }
		var horiStackViews = [UIStackView]()

		var horiStackView = createHoriStackView(spacing: style.options.hSpacing)
		horiStackViews.append(horiStackView)

		var currHoriStackViewWidth: CGFloat = .zero

		for tagButton in tagItemViews {
			let expectedWidth = (currHoriStackViewWidth + tagButton.frame.width + style.options.hSpacing)
			if expectedWidth < frame.width {
				horiStackView.addArrangedSubview(tagButton)
				currHoriStackViewWidth = expectedWidth
			} else {
				if horiStackView.arrangedSubviews.isEmpty {
					horiStackView.addArrangedSubview(tagButton)
					horiStackView = createHoriStackView(spacing: style.options.hSpacing)
					currHoriStackViewWidth = .zero
				} else {
					horiStackView = createHoriStackView(spacing: style.options.hSpacing)
					horiStackView.addArrangedSubview(tagButton)
					currHoriStackViewWidth = tagButton.frame.width
				}
				horiStackViews.append(horiStackView)
			}
		}

		horiStackViews.forEach(verticalContainerStackView.addArrangedSubview)
	}

	func createTagItemView(style: TagItemViewStyle, _ enumeratedTagElement: EnumeratedSequence<[TagItem]>.Element) -> TagItemView {
		let itemRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
		let itemView = PulsingButton(frame: itemRect)
		itemView.tag = enumeratedTagElement.offset
		itemView.addTarget(self, action: #selector(tagDidTap(_:)), for: .touchUpInside)
		itemView.titleLabel?.lineBreakMode = .byTruncatingTail
		itemView.titleLabel?.font = UIFont.systemFont(ofSize: 18)
		itemView.setTitleColor(.label, for: .normal)

		switch style {
		case .underlined:
			itemView.setTitle(enumeratedTagElement.element, for: .normal)
			itemView.backgroundColor = UIColor.clear
			addBottomLine(below: itemView)
			itemView.sizeToFit()

		case .roundedStartWithSharp:
			itemView.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
			itemView.setTitle("#" + enumeratedTagElement.element, for: .normal)
			itemView.backgroundColor = UIColor.systemGray5
			itemView.sizeToFit()
			itemView.clipsToBounds = true
			itemView.layer.cornerRadius = itemView.frame.height / 2
		}
		itemView.sizeToFit()
		return itemView
	}

	func addBottomLine(below view: TagItemView) {
		let bottomLine = UIView()
		bottomLine.translatesAutoresizingMaskIntoConstraints = false
		bottomLine.backgroundColor = .label
		view.addSubview(bottomLine)
		NSLayoutConstraint.activate([
			bottomLine.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
			bottomLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			bottomLine.heightAnchor.constraint(equalToConstant: 1),
			bottomLine.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
		view.setNeedsLayout()
	}

	func createHoriStackView(spacing: CGFloat) -> UIStackView {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = spacing
		stackView.alignment = .center
		stackView.distribution = .fillProportionally
		return stackView
	}

	var verticalContainerStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fillProportionally
		return stackView
	}()

	enum TagItemViewStyle {
		case underlined
		case roundedStartWithSharp

		var options: TagsViewOptions {
			switch self {
			case .underlined:
				return TagsViewOptions(vSpacing: 12, hSpacing: 32)
			case .roundedStartWithSharp:
				return TagsViewOptions(vSpacing: 8, hSpacing: 6)
			}
		}
	}

	struct TagsViewOptions {
		var vSpacing: CGFloat
		var hSpacing: CGFloat
	}

	let itemViewStyle: TagItemViewStyle

	init(style: TagItemViewStyle = .underlined) {
		self.itemViewStyle = style
		self.verticalContainerStackView.spacing = style.options.vSpacing
		super.init(frame: .zero)

		addSubview(verticalContainerStackView)
		NSLayoutConstraint.activate([
			verticalContainerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
			verticalContainerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
			verticalContainerStackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
			verticalContainerStackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
			verticalContainerStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
			verticalContainerStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc
	func tagDidTap(_ tagItemView: UIButton) {
		didSelectTagItem(tags[tagItemView.tag])
	}
}
