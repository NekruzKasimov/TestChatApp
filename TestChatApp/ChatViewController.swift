//
//  ChatViewController.swift
//  TestChatApp
//
//  Created by Niko on 06.10.22.
//

import Foundation
import MessageKit

protocol IChatPage: AnyObject {
    var viewModel: IChatViewModel! { get set }
}

typealias IChatViewController = MessagesViewController & IChatPage

class ChatViewController: IChatViewController {
    var viewModel: IChatViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        return Sender(senderId: "1", displayName: "Niko")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.messages().count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messages()[indexPath.section]
    }
}
