//
//  NewsViewController.swift
//  Exam_IOS
//
//  Created by Артём Шаповалов on 19.12.2023.
//

import Foundation
import UIKit

class NewsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var collectionView: UICollectionView!

    struct BlogResponse: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Blog]
    }

    struct Blog: Decodable {
        let id: Int
        let title: String
        let url: String
        let imageUrl: String?
        let newsSite: String?
        let summary: String?
        let publishedAt: String?
        let updatedAt: String?
        let featured: Bool?
    }


    struct ArticleResponse: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Article]
    }

    struct Article: Decodable {
        let id: Int
        let title: String
        let url: String
        let imageUrl: String?
        let newsSite: String?
        let summary: String?
        let publishedAt: String?
        let updatedAt: String?
        let featured: Bool?
    }



    private var blogs: [Blog] = []
    private var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BlogCell.self, forCellWithReuseIdentifier: "BlogCell")
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "ArticleCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func loadData() {
        loadBlogs()
        loadArticles()
    }

    func loadBlogs() {
        let url = URL(string: "https://api.spaceflightnewsapi.net/v4/blogs")!

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            do {
                let blogResponse = try JSONDecoder().decode(BlogResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.blogs = blogResponse.results
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }


    func loadArticles() {
        let url = URL(string: "https://api.spaceflightnewsapi.net/v4/articles")!

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            do {
                let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.articles = articleResponse.results
                    self?.collectionView.reloadSections(IndexSet(integer: 1))
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? blogs.count : articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as? BlogCell else {
                fatalError("Unable to dequeue BlogCell")
            }
            cell.configure(with: blogs[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
                fatalError("Unable to dequeue ArticleCell")
            }
            cell.configure(with: articles[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 150) 
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            loadArticles()
        }
    }
}




