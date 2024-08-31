//
//  StarredGistsListVC.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import UIKit
import Combine
import NetworkService

open class FavoritesListVC<T: FavoriteItem>: UITableViewController {
    private let viewModel: FavoritesListVM<T>
    private var cancellables = Set<AnyCancellable>()
    private let cellID = "FavoriteGistCell"

    public init(viewModel: FavoritesListVM<T>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        tabBarItem.image = UIImage(systemName: "star.fill")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: cellID)

        setupBindings()
    }

    open override func viewWillAppear(_ animated: Bool) {
        viewModel.connect()
    }

    func setupBindings() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
        }
        .store(in: &cancellables)
    }

    open override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.items.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FavoriteCell
        let item = viewModel.items[indexPath.row]

        cell.fileCountLabel.text = item.favoriteSubtitle
        cell.titleLabel.text = item.favoriteTitle

        cell.setPlaceholder()
        Task { @MainActor in
            cell.avatarImageView.image = await viewModel.loadUserAvatar(item: item)
        }

        return cell
    }

    open override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        80
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
}
