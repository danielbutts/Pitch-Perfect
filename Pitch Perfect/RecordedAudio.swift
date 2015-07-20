//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Daniel Butts on 7/17/15.
//  Copyright (c) 2015 Cool Vector. All rights reserved.
//

import Foundation


class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl: NSURL!,title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }

}