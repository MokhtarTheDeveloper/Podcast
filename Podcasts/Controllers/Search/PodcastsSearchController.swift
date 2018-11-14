//
//  PodcastsSearchController.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import UIKit

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    var presenter : PodcastSearchPresenter!
    
    // lets implement a UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        setupSearchBar()
        setupTableView()
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupSearchBar() {
        
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchFor(text: searchText)
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        let podcast = presenter.podcasts[indexPath.row]
        let episodesPresenter = EpisodePresenter()
        episodesPresenter.podcast = podcast
        episodesController.presenter = episodesPresenter
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // ternary operator
        return presenter.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    
    var podcastSearchView = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: self, options: nil)?.first as? UIView
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return podcastSearchView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return presenter.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.podcasts.count
    }
    
    fileprivate func setupCellWithPodcast(cell: PodcastCell, podcast: Podcast) {
        cell.trackNameLabel.text = podcast.trackName
        cell.artistNameLabel.text = podcast.artistName
        cell.episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
        if let url = URL(string: podcast.artworkUrl600 ?? "") {
            cell.podcastImageView.sd_setImage(with: url, completed: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        
        let podcast = presenter.podcasts[indexPath.row]
        setupCellWithPodcast(cell: cell, podcast: podcast)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}





extension PodcastsSearchController : PodcastSearchPresenterDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}








