//
//  SingleImageViewController.swift
//  Gallery
//
//  Created by Boris Bügling on 17/02/15.
//  Copyright (c) 2015 Contentful GmbH. All rights reserved.
//

import UIKit

protocol SingleImageViewControllerDelegate: class {
    func updateCurrentIndex(index: Int)
}

class SingleImageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, ZoomTransitionProtocol {
    var client: CDAClient?
    var gallery: Photo_Gallery?
    var images: [Image] {
        if let gallery = gallery {
            return gallery.images.array as! [Image]
        }
        return [Image]()
    }
    var initialIndex = 0
    weak var singleImageDelegate: SingleImageViewControllerDelegate?

    func updateCurrentIndex(index: Int) {
        if index < 0 || index > images.count {
            return
        }

        if (index == 0) {
            title = gallery?.title
        } else {
            let image = images[index - 1]
            title = image.title
        }

        if let delegate = singleImageDelegate {
            delegate.updateCurrentIndex(index - 1)
        }
    }

    func viewControllerWithIndex(index: Int) -> UIViewController? {
        if index < 0 || index > images.count {
            return nil
        }

        let asset = index == 0 ? gallery?.coverImage : images[index - 1].photo
        let vc = ImageDetailsViewController()
        vc.pageViewController = self
        vc.view.tag = index

        var title = NSLocalizedString("Untitled", comment: "")
        var description = ""

        if (index == 0) {
            title = gallery?.title ?? title
            description = gallery?.galleryDescription ?? description
        } else {
            title = images[index - 1].imageCaption ?? title
            description = images[index - 1].imageCredits ?? description
        }

        vc.updateText(String(format: "# %@\n\n%@", title, description))

        if let asset = asset, client = client {
            vc.imageView.image = nil
            vc.imageView.offlineCaching_cda = true
            vc.imageView.cda_setImageWithPersistedAsset(asset, client: client, size: UIScreen.mainScreen().bounds.size.screenSize(), placeholderImage: nil)
        }

        let _ = view.subviews.first?.gestureRecognizers?.map { (recognizer) -> Void in vc.scrollView.panGestureRecognizer.requireGestureRecognizerToFail(recognizer as UIGestureRecognizer) }

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let imageVC = viewControllerWithIndex(initialIndex + 1) {
            setViewControllers([imageVC], direction: .Forward, animated: false) { (finished) in
                    if finished {
                        self.updateCurrentIndex(self.initialIndex + 1)
                    }
            }
        }
    }

    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewController.view.tag
        return viewControllerWithIndex(currentIndex + 1)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewController.view.tag
        return viewControllerWithIndex(currentIndex - 1)
    }

    // MARK: UIPageViewControllerDelegate

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstVC = viewControllers?.first where completed {
            let currentIndex = firstVC.view.tag
            updateCurrentIndex(currentIndex)
        }
    }

    // MARK: ZoomTransitionProtocol

    func viewForZoomTransition(isSource: Bool) -> UIView! {
        if let viewControllers = viewControllers where viewControllers.count > 0 {
            let imageView = (viewControllers[0] as! ImageDetailsViewController).imageView

            if (isSource) {
                imageView.backgroundColor = UIColor.clearColor()
            }

            return imageView
        }

        return view
    }
}
