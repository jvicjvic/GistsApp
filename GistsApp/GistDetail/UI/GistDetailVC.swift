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
        textView.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        textView.isSelectable = true
        return textView
    }()

    lazy var mainContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerContainer, textView])
        stack.axis = .vertical
        stack.spacing = .spacing8
        return stack
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
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
        view.addSubview(activityIndicator)
        remakeConstraints()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                            style: .plain, target: self, action: #selector(didTapFavorite))
        navigationItem.rightBarButtonItem?.isEnabled = false

        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.connect()
    }

    @objc func didTapFavorite() {
        viewModel.didTapFavorite()
    }

    func remakeConstraints() {
        mainContainer.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(CGFloat.spacing16)
        }
        headerContainer.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.spacing64)
        }
        avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(CGFloat.spacing48)
            make.width.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(textView)
        }
    }
}

// MARK: - Bindings

extension GistDetailVC {
    func setupBindings() {
        // cabecalho
        viewModel.$gist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gist in
                guard let self else { return }

                self.title = self.viewModel.title
                self.titleLabel.text = self.viewModel.headerTitle
                self.avatarImageView.image = self.viewModel.avatarImage
            }
            .store(in: &cancellables)

        // botao de favorito
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isFavorite in
                guard let self else { return }

                let imageName = isFavorite ? "star.fill" : "star"
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
            }
            .store(in: &cancellables)

        // arquivo
        viewModel.$fileContent
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fileContent in
                self?.textView.text = fileContent
        }
        .store(in: &cancellables)

        // spinner de ocupado
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
}
