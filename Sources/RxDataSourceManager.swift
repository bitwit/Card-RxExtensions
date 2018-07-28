import Foundation
import RxSwift
import Card

public class RxDataSourceManager<T: Resource>: DataSourceManager {
    
    public typealias SourceData = ([String], [[T]])
    
    public var sections: [[T]] {
        return latestSourceData.1
    }
    public weak var delegate: DataSourceManagerDelegate?
    
    private var latestSourceData: SourceData = ([], [])
    private var observable: Observable<([String], [[T]])>
    private var disposeBag = DisposeBag()
    
    public init(observable: Observable<SourceData>) {
        self.observable = observable
        self.observable.subscribe(onNext: { [weak self] (sourceData) in
            guard let this = self else { return }
            this.calculateChangeDiff(old: this.latestSourceData, new: sourceData)
        })
            .disposed(by: disposeBag)
    }
    
    private func calculateChangeDiff(old: SourceData, new: SourceData) {
        
        latestSourceData = new
        
        delegate?.dataSourceManagerItemsWillChange()
        var modifiedOldSections = old.1
        let sectionsDiff = DiffCalculator(old.0, new.0)
        sectionsDiff.changes.forEach {
            (diff) in
            switch diff {
            case .added(let index):
                modifiedOldSections.insert([], at: index)
                delegate?.dataSourceManagerSection(at: index, did: .add)
            case .removed(let index):
                modifiedOldSections.remove(at: index)
                delegate?.dataSourceManagerSection(at: index, did: .remove)
            }
        }
        
        modifiedOldSections.enumerated().forEach {
            sectionIndex, section in
            let itemsDiff = DiffCalculator(section, new.1[sectionIndex])
            itemsDiff.changes.forEach({
                diff in
                switch diff {
                case .added(let index):
                    delegate?.dataSourceManagerItem(at: IndexPath(item: index, section: sectionIndex), did: .add)
                case .removed(let index):
                    delegate?.dataSourceManagerItem(at: IndexPath(item: index, section: sectionIndex), did: .remove)
                }
            })
        }
        
        delegate?.dataSourceManagerItemsDidChange()
    }
}
