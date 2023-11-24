//
//  PostModel.swift
//  TableViewPagination
//
//  Created by Pulkit Dhirana on 24/11/23.
//

import Foundation

struct PostModel: Decodable {
    let albumID, id: Int?
    let title: String?
    let url, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
