//
//  HomeViewController.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 28.06.23.
//

import UIKit

enum SectionName: Int {
    case PopularFilm = 0
    case ComingSoon = 2

}

class HomeViewController: UIViewController {

    let category = ["Now Plaing","Popular","Trending TV", "Upcoming movies", "Top rated"]


    private let homeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identefier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let header = MovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 350))

        homeTableView.tableHeaderView = header
        homeTableView.dataSource = self
        homeTableView.delegate = self

        setNavigationBarItem()

        view.addSubview(homeTableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }

    func setNavigationBarItem() {


        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .plain, target: nil, action: nil)
        ]

        navigationController?.navigationBar.tintColor = .red
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identefier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
            case 0: APICaller.shared.getNowPlaingMovie { result in
                switch result {
                    case .success(let movies):
                        cell.configure(movies: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
            case 1:
                APICaller.shared.getPopularMovie { result in
                switch result {
                    case .success(let movies):
                        cell.configure(movies: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
            case 2 :
                APICaller.shared.getPopularTv { result in
                    switch result {
                        case .success(let movies):
                            cell.configure(movies: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case 3 :
                APICaller.shared.getComingSoonMovie { result in
                    switch result {
                        case .success(let movies):
                            cell.configure(movies: movies)
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                }
            case 4 : APICaller.shared.getTopRated { result in
                switch result {
                    case .success(let movies):
                        cell.configure(movies: movies)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
            default: break
        }


        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return   category[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.textColor = .red
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let saveArea = view.safeAreaInsets.top
        let offset = saveArea + scrollView.contentOffset.y

        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    }
}
