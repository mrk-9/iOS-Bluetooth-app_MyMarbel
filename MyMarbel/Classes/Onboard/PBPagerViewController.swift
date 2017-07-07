//
//  PBPagerViewController.swift
//  MyMarbel
//
//  Created by Tmaas on 14/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

public func == (v1: UIViewController, v2: UIViewController) -> Bool {
    return v1.isEqual(v2)
}

class PBPagerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    var pageController: UIPageViewController!
    var titleScrollView: UIScrollView!
    var pages: [UIViewController]!
    var titles: [String]!
    var currentIndex: Int!

    var screenWidth: CGFloat!


    convenience init(pages: [(String, UIViewController)]) {
        let titleColor = UIColor.whiteColor()
        self.init(pages: pages, titleColor: titleColor, gradientLocations: [0, 0.2, 0.8, 1])
    }
    
    init(pages: [(String, UIViewController)], titleColor: UIColor = UIColor.whiteColor(), gradientLocations: [CGFloat]) {
        super.init(nibName: nil, bundle: nil)
        self.titles = pages.map { tuple -> String in tuple.0 }
        self.pages = pages.map { tuple -> UIViewController in tuple.1 }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenWidth = UIScreen.mainScreen().bounds.size.width
        self.navigationController?.navigationBarHidden = true
        setUpPageViewController()

        
        let viewControllers = [pages[0]]
        pageController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = pages.indexOf(viewController)
        return index! == 0 ? nil : pages[index! - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = pages.indexOf(viewController)
        return index! + 1 == pages.count ? nil : pages[index! + 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let index = pages.indexOf(pageController.viewControllers![0])
            currentIndex = index
        }
    }
    
    func goNextPage(nextIndex: Int) {
        let viewControllers = [pages[nextIndex]]
        pageController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentIndex = currentIndex == nil ? 0 : currentIndex
    }
    
    private func setUpPageViewController() {
        pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil) //PageCurl
        pageController.delegate = self
        pageController.dataSource = self
        
        pageController.view.frame = view.bounds
        view.addSubview(pageController.view)
        
        pageController.view.subviews.map { view -> () in
            if view is UIScrollView {
                (view as! UIScrollView).delegate = self
            }
        }
    }
    
}