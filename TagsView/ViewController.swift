//
//  ViewController.swift
//  TagsView
//
//  Created by Won on 2020/07/22.
//  Copyright © 2020 Won. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


	let underlinedTagsView: TagsView = {
		let view = TagsView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let sharpTagsView: TagsView = {
		let view = TagsView(style: .roundedStartWithSharp)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 50
		stackView.distribution = .fillProportionally
		return stackView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(stackView)

		stackView.addArrangedSubview(underlinedTagsView)
		stackView.addArrangedSubview(sharpTagsView)

		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
			stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
			underlinedTagsView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			sharpTagsView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
		])

		underlinedTagsView.tags = ["스토리", "로맨스", "일상", "Swift is the best programming lang", "미스테리", "판타지", "공포", "드라마", "스토리", "유머"]
		sharpTagsView.tags = ["스토리", "로맨스", "일상", "Swift is the best programming lang", "미스테리", "판타지", "공포", "드라마", "스토리", "유머"]
	}
}
