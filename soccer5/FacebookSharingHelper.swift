//
//  FacebookSharingHelper.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Foundation


class FacebookShareHelper {
    /*
    1. contentURL - The link to be shared
    2. contentTitle - Represents the title of the content in the link
    3. imageURL - the URL of thumbnail image that appears on the post
    4. contentDescription - of the content, usually 2-4 sentences
    
    If your app share links to the iTunes or Google Play stores, we do not post any images or descriptions that you specify in the share. Instead we post some app information we scrape from the app store directly with the Webcrawler. This may not include images. To preview a link share to iTunes or Google Play, enter your URL into the URL Debugger.
    
    */
    static var contentURL:String?
    var contentTitle:String?
    var imageURL:String?
    var contentDescription:String?
    
    class func  sharelink() {
        let linkContent = FBSDKShareLinkContent()
        linkContent.contentURL = NSURL(string: contentURL!)
    }
    
    /*
    Photos must be less than 12MB in size
    People will need native facebook app installed
    */
    
    func sharePhoto() {
        
    }
    
    //MARK: Sharing Methods
    class func addLikeButton(view:UIView) {
        let button = FBSDKLikeControl()
        button.objectID = "https://www.facebook.com/FacebookDevelopers"
        view.addSubview(button)
    }
    
    class func addShareButton(view:UIView) {
        let button = FBSDKShareButton()
        let linkContent = FBSDKShareLinkContent()
        linkContent.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")
        button.shareContent = linkContent
        view.addSubview(button)
    }
    
    class func addSendButton(view:UIView) {
        let button = FBSDKSendButton()
        let linkContent = FBSDKShareLinkContent()
        linkContent.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")
        button.shareContent = linkContent
        view.addSubview(button)
    }
    
    class func shareWithShareDialog(controller:UIViewController, urlString:String) {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: urlString)
        FBSDKShareDialog.showFromViewController(controller, withContent: content, delegate: nil)
    }
    
    class func shareWithMessenger() {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "https://www.facebook.com/FacebookDevelopers")
        content.contentTitle = "MyApp"
        content.contentDescription = "No Description"
        FBSDKMessageDialog.showWithContent(content, delegate: nil)
    }
    
    
    func shareFB(sender: AnyObject){
        
        
    }
    
    
    class func fbShare(controller:UIViewController, urlString:String, imageURL:String, title:String) {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: urlString)
        content.imageURL = NSURL(string: imageURL)
        content.contentTitle  = title
        FBSDKShareDialog.showFromViewController(controller, withContent: content, delegate: nil)
        print(controller)
        print(content)
    }
}