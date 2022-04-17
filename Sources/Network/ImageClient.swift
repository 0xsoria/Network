
#if !os(watchOS) && !os(macOS)
import UIKit

public protocol ImageService {
    func downloadImage(
        fromURL url: URL,
        completion: @escaping (UIImage?, Error?) -> Void)
    -> URLSessionDataTask?
    
    func setImage(on imageView: UIImageView,
                  fromURL url: URL,
                  withPlaceholder placeholder: UIImage?)
}


public class ImageClient {
    
    // MARK: - Static Properties
    public static let shared = ImageClient(responseQueue: .main,
                                    session: .shared)
    
    // MARK: - Instance Properties
    public var cachedImageForURL: [URL: UIImage]
    public var cachedTaskForImageView: [UIImageView: URLSessionDataTask]
    
    public let responseQueue: DispatchQueue?
    public let session: URLSession
    public let placeholder = UIImage(named: "image_placeholder",
                        in: Bundle.module,
                        with: nil)
    
    // MARK: - Object Lifecycle
    public init(responseQueue: DispatchQueue?,
         session: URLSession) {
        
        self.cachedImageForURL = [:]
        self.cachedTaskForImageView = [:]
        
        self.responseQueue = responseQueue
        self.session = session
    }
}

// MARK: - ImageService
extension ImageClient: ImageService {
    public func downloadImage(
        fromURL url: URL,
        completion: @escaping (UIImage?, Error?) -> Void)
    -> URLSessionDataTask? {
        if let image = cachedImageForURL[url] {
            completion(image, nil)
            return nil
        }
        let dataTask =
        session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self.cachedImageForURL[url] = image
                self.dispatch(image: image, completion: completion)
            } else {
                self.dispatch(error: error, completion: completion)
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    private func dispatch(
        image: UIImage? = nil,
        error: Error? = nil,
        completion: @escaping (UIImage?, Error?) -> Void) {
            
            guard let responseQueue = responseQueue else {
                completion(image, error)
                return
            }
            responseQueue.async {
                completion(image, error)
            }
        }
    
    public func setImage(on imageView: UIImageView,
                  fromURL url: URL,
                  withPlaceholder placeholder: UIImage?) {
        
        cachedTaskForImageView[imageView]?.cancel()
        imageView.image = placeholder
        
        cachedTaskForImageView[imageView] =
        downloadImage(fromURL: url) {
            [weak self] image, error in
            guard let self = self else { return }
            self.cachedTaskForImageView[imageView] = nil
            guard let image = image else {
                print("Set Image failed with error: " +
                      String(describing: error))
                return
            }
            imageView.image = image
        }
    }
}
#endif
