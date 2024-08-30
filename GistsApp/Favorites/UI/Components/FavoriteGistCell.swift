//
//  FavoriteGistCell.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import NetworkService
import SnapKit
import UIKit

class FavoriteGistCell: UITableViewCell {
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CGFloat.spacing48 / 2.0
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()

    lazy var fileCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()

    lazy var containerView: UIView = {
        let container = UIView()
        container.addSubview(avatarImageView)
        container.addSubview(titleLabel)
        container.addSubview(fileCountLabel)
        return container
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        remakeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func remakeConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat.spacing16)
        }
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(CGFloat.spacing48)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(CGFloat.spacing16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        fileCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(CGFloat.spacing8)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(CGFloat.spacing72)
        }
    }

    func configure(with gist: FavoriteGist) {
        fileCountLabel.text = "\(gist.fileCount) arquivo(s)"
        titleLabel.text = "\(gist.ownerLogin) / \(gist.filename)"

        avatarImageView.image = generatePlaceholderImage(size: CGSize(width: 50, height: 50))
        Task { @MainActor in
            await avatarImageView.image = NetworkUtil.fetchImage(from: gist.avatarUrl)
        }
    }

    func generatePlaceholderImage(size: CGSize, backgroundColor: UIColor = .lightGray, text: String? = nil) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            // Preencher o fundo com a cor especificada
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            if let text = text {
                // Configurar o estilo do texto
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 30),
                    .foregroundColor: UIColor.white
                ]
                let textSize = text.size(withAttributes: attributes)
                let textRect = CGRect(x: (size.width - textSize.width) / 2,
                                      y: (size.height - textSize.height) / 2,
                                      width: textSize.width,
                                      height: textSize.height)
                text.draw(in: textRect, withAttributes: attributes)
            }
        }

        return image
    }
}
