//
// Copyright © Cookpad Inc. All rights reserved.
//

import Foundation
import UIKit

final class RecipesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private let viewModel: RecipesViewModelType
    private var currentPage: Int = 1
    private var hasNext: Bool = false
    private var recipes: [RecipesQuery.Data.Recipe] = []

    init(viewModel: RecipesViewModelType = RecipesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Recipes"
        tabBarItem.image = UIImage(named: "tab_recipe")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.registerNib(type: RecipesCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        viewModel.outputs.recipesFetched { [weak self] recipes, page in
            self?.recipes.append(contentsOf: recipes)
            self?.hasNext = !recipes.isEmpty
            self?.currentPage = page
            self?.tableView.reloadData()
        }

        viewModel.outputs.recipesFetchFailed { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController(title: "", message: "データの取得に失敗しました。", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        viewModel.inputs.fetchRecipes(page: currentPage)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecipesCell.dequeue(from: tableView, for: indexPath, with: recipes[indexPath.row])
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecipeViewController.instantiate(with: recipes[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecipesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height, hasNext {
            viewModel.inputs.fetchRecipes(page: currentPage + 1)
        }
    }
}
