//
//  HomeViewController.swift
//  MoviesProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 25.12.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var movieList: [Title] = [] // Initialize an empty array of movies

    @IBOutlet weak var TrandingMoviesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UITableView
        TrandingMoviesTable.dataSource = self
        TrandingMoviesTable.delegate = self
        TrandingMoviesTable.register(TrandingMoviesTableViewCell.nib(), forCellReuseIdentifier: TrandingMoviesTableViewCell.identifier)
        
        // Fetch trending movies
        fetchTrendingMovies()
    }
    
    private func fetchTrendingMovies() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movieList = movies
                DispatchQueue.main.async {
                    self?.TrandingMoviesTable.reloadData() // Reload table view on the main thread
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrandingMoviesTableViewCell.identifier, for: indexPath) as! TrandingMoviesTableViewCell
        
        let currentMovie = movieList[indexPath.row]
        cell.configure(with: currentMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else { return }

        vc.selectedMovie = movieList[indexPath.row] // Pass the selected movie
        navigationController?.pushViewController(vc, animated: true)
    }
}
