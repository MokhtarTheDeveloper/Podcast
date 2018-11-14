//
//  EpisodesPresenter.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import Foundation

protocol EpisodePresneterDelegate : class {
    func reloadTableView()
}

class EpisodePresenter {
    
    weak var delegate: EpisodePresneterDelegate?
    
    var podcast: Podcast? {
        didSet {
//            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    var episodes = [Episode]()
    
    var hasFavorited : Bool {
        get {
            let savedPodcasts = UserDefaults.standard.savedPodcasts()
            let hasFavorited = savedPodcasts.index(where: { $0.trackName == podcast?.trackName && $0.artistName == podcast?.artistName }) != nil
            return hasFavorited
        }
    }

    fileprivate func fetchEpisodes() {
        print("Looking for episodes at feed url:", podcast?.feedUrl ?? "")
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            self.delegate?.reloadTableView()
        }
    }
    
    func favoriatePodcast() {
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast!)
        do {
            let data = try JSONEncoder().encode(listOfPodcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)

        } catch let encodingErr {
            print("Failed to encode Podcasts", encodingErr)
        }
    }
    
    func downloadEpisode(indexPath: IndexPath) {
        // download the podcast episode
        let episode = episodes[indexPath.row]
        UserDefaults.standard.downloadEpisode(episode: episode)
        APIService.shared.downloadEpisode(episode: episode)

    }
}
