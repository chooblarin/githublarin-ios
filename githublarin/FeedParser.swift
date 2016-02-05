import Foundation
import RxSwift

class FeedParser: NSObject, NSXMLParserDelegate {

    // MARK: - Properties

    var parser: NSXMLParser!
    var feed: Feed?
    var cursor: String?
    var subject: ReplaySubject<Feed>!

    init(contentsUrl: NSURL) {
        super.init()
        parser = NSXMLParser(contentsOfURL: contentsUrl)
        parser.delegate = self
    }

    func parse() -> Observable<Feed> {
        self.subject = ReplaySubject.create(bufferSize: 30)
        parser.parse()
        return subject.asObservable()
    }

    func parserDidEndDocument(parser: NSXMLParser) {
        subject.onCompleted()
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case "id": fallthrough
        case "published": fallthrough
        case "updated": fallthrough
        case "title": cursor = elementName
        case "entry":
            feed = Feed()
            cursor = elementName
        case "link":
            feed?.link = attributeDict["href"]
            cursor = nil
        case "author": cursor = elementName
        case "name":
            if "author" == cursor {
                cursor = elementName
            }
        case "media:thumbnail":
            feed?.thumbnail = attributeDict["url"]
            cursor = nil
        default:
            cursor = nil
        }
    }

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        guard let feed = feed, let cursor = cursor else { return }

        switch cursor {
        case "id": feed.entryId = string
        case "published": feed.publishedAt = string
        case "updated": feed.updated = string
        case "title": feed.title = string
        case "name": feed.authorName = string
        default: return
        }
        self.cursor = nil
    }

    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if "entry" == elementName {
            subject.onNext(feed!)
            feed = nil
        }
    }
}
