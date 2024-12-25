//
//  SearchViewController.swift
//  MoviesProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 25.12.2024.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var movies: [Title] = [] // Array to store search results

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the search bar
        searchBar.delegate = self

        // Set up the table view
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(TrandingMoviesTableViewCell.nib(), forCellReuseIdentifier: TrandingMoviesTableViewCell.identifier)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        searchMovies(query: query)
    }

    private func searchMovies(query: String) {
        APICaller.shared.search(with: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error)")
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrandingMoviesTableViewCell.identifier, for: indexPath) as? TrandingMoviesTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]
        cell.TrandingMovieTitle.text = movie.original_title ?? "Unknown Title"
        
        cell.ratingScore.text = "\(String(format: "%.1f", movie.vote_average))"

        if let posterPath = movie.poster_path {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.TrandingMovieImage.kf.setImage(with: posterURL)
        } else {
            cell.TrandingMovieImage.image = UIImage(named: "placeholder")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
//
//        let movie = movies[indexPath.row]
//        vc.movieId = "\(movie.id)"
//        navigationController?.pushViewController(vc, animated: true)
    }
}
