//
//  CollectionViewCell.swift
//  ios_assignment
//
//  Created by Aditya on 16/04/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0

    private var savedTask: URLSessionTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var savedUrl: URL? {
        get { objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        // cancel prior task, if any

        weak var oldTask = savedTask
        savedTask = nil
        oldTask?.cancel()

        // reset image view’s image

        self.image = placeholder

        // allow supplying of `nil` to remove old image and then return immediately

        guard let url else { return }

        // check cache

        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        // download

        savedUrl = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.savedTask = nil

            // error handling

            if let error {
                // don't bother reporting cancelation errors

                if (error as? URLError)?.code == .cancelled {
                    return
                }

                print(error)
                return
            }

            guard let data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: url.absoluteString)

            if url == self?.savedUrl {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }

        // save and start new task

        savedTask = task
        task.resume()
    }
}
class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol?

    static let shared = ImageCache()

    private init() {
        // make sure to purge cache on memory pressure

        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
