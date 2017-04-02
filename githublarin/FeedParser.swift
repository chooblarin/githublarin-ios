import Foundation
import RxSwift

class FeedParser: NSObject, XMLParserDelegate {

    // MARK: - Properties

    var parser: XMLParser!
    var feed: Feed?
    var cursor: String?
    var subject: ReplaySubject<Feed>!

    init(contentsUrl: URL) {
        super.init()
        parser = XMLParser(contentsOf: contentsUrl)
        parser.delegate = self
    }

    func parse() -> Observable<Feed> {
        self.subject = ReplaySubject.create(bufferSize: 30)
        parser.parse()
        return subject.asObservable()
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        subject.onCompleted()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
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

    func parser(_ parser: XMLParser, foundCharacters string: String) {
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

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if "entry" == elementName {
            subject.onNext(feed!)
            feed = nil
        }
    }
}
