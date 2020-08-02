//
//  PulsingButton.swift
//  TagsView
//
//  Created by Won on 2020/08/02.
//  Copyright © 2020 Won. All rights reserved.
//

import UIKit

class PulsingButton: UIButton {

	override open var isHighlighted: Bool {
		didSet {
			guard oldValue != isHighlighted, isEnabled else { return }
			alpha = isHighlighted ? 0.6 : 1.0

			UIView.animate(
				withDuration: 0.1,
				animations: { [weak self] in
					guard let self = self else { return }
					self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
			})
		}
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		adjustsImageWhenHighlighted = false
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		adjustsImageWhenHighlighted = false
	}
}

