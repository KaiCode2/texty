//
//  PlayPublisher.swift
//  Texty
//
//  Created by Kai Aldag on 2020-04-19.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Combine
import NotificationCenter
import TextyKit

extension Publishers {
    class PlaySubscription<S: Subscriber>: Subscription where S.Input == Document.MetaData, S.Failure == Never {
        private var subscriber: S?

        func request(_ demand: Subscribers.Demand) {

        }

        func cancel() {

        }

        init(subscriber: S) {
            self.subscriber = subscriber
        }
    }

    struct PlayPublisher: Publisher {
        typealias Output = Document.MetaData
        typealias Failure = Never

        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlaySubscription(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

//class PlaySubject: Subject {
//    typealias Output = Document.MetaData
//    typealias Failure = Never
//
//    @Published var metaData: Document.MetaData? = nil
//
//    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
//
//    }
//
//    func send(_ value: Output) {
//
//    }
//
//    func send(completion: Subscribers.Completion<Failure>) {
//
//    }
//
//    func send(subscription: Subscription) {
//
//    }
//}

//protocol PlayPublisher: Publisher where Output == Document.MetaData, Failure == Never {
//
//}
//
//extension PlayPublisher {
//    var publisher: Publisher {
//        return NotificationCenter.default.publisher(for: .playDocument)
//            .map { notification in
//                return notification.userInfo?[Constants.Published.metaData] as? Document.MetaData
//        }
//    }
//}
