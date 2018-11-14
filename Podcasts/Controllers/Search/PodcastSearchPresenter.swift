//
//  PodcastSearchPresenter.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import Foundation
protocol PodcastSearchPresenterDelegate : class {
    func reloadData()
}

class PodcastSearchPresenter {
    weak var delegate : PodcastSearchPresenterDelegate?
    var podcasts = [Podcast]()
    var timer: Timer?
    
    
    func searchFor(text: String) {
        podcasts = []
        delegate?.reloadData()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            APIService.shared.fetchPodcasts(searchText: text) { (podcasts) in
                self.podcasts = podcasts
                self.delegate?.reloadData()
            }
        })
    }
    
    
}
