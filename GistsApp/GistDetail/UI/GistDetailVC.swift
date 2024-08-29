//
//  GistDetailVC.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import UIKit
import Combine

class GistDetailVC: UIViewController {
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CGFloat.spacing48 / 2.0
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()

    lazy var headerContainer: UIStackView = {
        let avatarContent = UIView()
        avatarContent.addSubview(avatarImageView)
        let stack = UIStackView(arrangedSubviews: [avatarContent, titleLabel])
        stack.spacing = .spacing8
        return stack
    }()

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.6
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = UIFont(name: "Menlo", size: 14)
        return textView
    }()

    lazy var mainContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerContainer, textView])
        stack.axis = .vertical
        stack.spacing = .spacing8
        return stack
    }()

    let viewModel: GistDetailVM

    init(viewModel: GistDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainContainer)
        remakeConstraints()

        setupBindings()

        viewModel.connect()
    }

    func setupBindings() {
        title = viewModel.title
        titleLabel.text = viewModel.headerTitle

        // avatar
        viewModel.$avatarImage
            .receive(on: DispatchQueue.main)
            .sink { image in
            self.avatarImageView.image = image
        }
        .store(in: &cancellables)

        // arquivo
        viewModel.$fileContent
            .receive(on: DispatchQueue.main)
            .sink { fileContent in
            self.textView.text = fileContent
        }
        .store(in: &cancellables)
    }

    func remakeConstraints() {
        mainContainer.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(CGFloat.spacing8)
        }
        headerContainer.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.spacing64)
        }
        avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(CGFloat.spacing48)
            make.width.equalToSuperview()
        }
    }
}
