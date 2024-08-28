//
//  GistCell.swift
//  GistsApp
//
//  Created by jvic on 28/08/24.
//

import NetworkService
import SnapKit
import UIKit

class GistCell: UITableViewCell {
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

    func configure(with gist: Gist) {
        fileCountLabel.text = "\(gist.fileCount) arquivo(s)"
        let description = gist.name ?? "Sem descrição"
        titleLabel.text = "\(gist.owner.login) / \(description)"

        avatarImageView.image = nil
        Task { @MainActor in
            await avatarImageView.image = NetworkUtil.fetchImage(from: gist.owner.avatarUrl)
        }
    }
}
