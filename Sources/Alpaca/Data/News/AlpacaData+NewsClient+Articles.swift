//
//  File.swift
//  
//
//  Created by Mike Mello on 1/23/24.
//

import Foundation

public struct NewsArticle: Codable {
    public struct Image: Codable {
        public enum Size: String, Codable {
            case thumb
            case small
            case large
        }
        public let size: Size
        public let url: URL
    }
    public let id: Int64
    public let headline: String
    public let author: String
    public let createdAt: Date
    public let updatedAt: Date
    public let summary: String
    public let content: String
    public let url: URL?
    public let images: [NewsArticle.Image]
    public let symbols: [String]
    public let source: String
}

public struct News: Decodable {
    var news: [NewsArticle]
    public let nextPageToken: String?
}

extension AlpacaDataClient.NewsClient {
    public func articles(
        symbols: [String],
        start: Date? = nil,
        end: Date? = nil,
        limit: Int = 10,
        sort: SortDirection? = nil,
        includeContent: Bool? = nil,
        excludeContentless: Bool? = nil
    ) async throws -> [NewsArticle] {
        var news: News = try await getNews(
            symbols: symbols,
            start: start,
            end: end,
            limit: limit,
            sort: sort,
            includeContent: includeContent,
            excludeContentless: excludeContentless,
            nextPageToken: nil
        )
        var articles = news.news
        
        while news.nextPageToken != nil {
            news = try await getNews(
                symbols: symbols,
                start: start,
                end: end,
                limit: limit,
                sort: sort,
                includeContent: includeContent,
                excludeContentless: excludeContentless,
                nextPageToken: news.nextPageToken
            )
            articles.append(contentsOf: news.news)
        }
        
        return articles
    }
    
    internal func getNews(
        symbols: [String],
        start: Date? = nil,
        end: Date? = nil,
        limit: Int = 10,
        sort: SortDirection? = nil,
        includeContent: Bool? = nil,
        excludeContentless: Bool? = nil,
        nextPageToken: String? = nil
    ) async throws -> News {
        try await get("/v1beta1/news", searchParams: [
            "symbols": symbols.joined(separator: ","),
            "start": start.map(Utils.iso8601DateFormatter.string),
            "end": end.map(Utils.iso8601DateFormatter.string),
            "limit": "\(limit)",
            "sort": sort.map(\.rawValue),
            "include_content": includeContent.map(String.init),
            "exclude_contentless": excludeContentless.map(String.init),
            "page_token": nextPageToken
        ])
    }
}
