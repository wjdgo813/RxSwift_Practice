//
//  ViewController.swift
//  RxDataSourceExam
//
//  Created by JHH on 05/03/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

struct Package {
    let packageID : Int
    let packageName : String
}


struct PackageModel{
    let unCheck : [Package]
    let check   : [Package]
}

struct SectionOfPackage {
    var header: String
    var items: [Item]
}

extension SectionOfPackage: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = Package
    
    var identity: String {
        return header
    }
    
    init(original: SectionOfPackage, items: [Item]) {
        self = original
        self.items = items
    }
}

extension Package : IdentifiableType, Equatable{
    typealias Identity = Int
    
    var identity: Int {
        return packageID
    }
    
    static func == (lhs: Package, rhs: Package) -> Bool {
        return lhs.packageID == rhs.packageID && lhs.packageName == rhs.packageName
    }
}


class ViewController: UIViewController {
    private var disposed = DisposeBag()
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkPackArr = [Package(packageID: 0, packageName: "0"),
                            Package(packageID: 1, packageName: "1"),
                            Package(packageID: 2, packageName: "2")]
        
        let unCheckPack = [Package(packageID: 3, packageName: "3"),
                           Package(packageID: 4, packageName: "4"),
                           Package(packageID: 5, packageName: "5")]
        
        let result = PackageModel(unCheck: checkPackArr, check: unCheckPack)
        //API 결과로 얻었다고 치고...
        
        //이렇게 갖다 줘야하나??
        let sections = [SectionOfPackage(header: "첫번째!", items: result.check),
                        SectionOfPackage(header: "두번째!", items: result.unCheck)]
        
        let (configureCollectionViewCell, configureSupplementaryView) =  ViewController.collectionViewDataSourceUI()
        let dataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: configureCollectionViewCell,
            configureSupplementaryView: configureSupplementaryView
        )
        
        
        self.collectionview.rx.setDelegate(self)
            .disposed(by: disposed)
        
        
        Observable.just(sections)
            .bind(to: collectionview.rx.items(dataSource: dataSource))
            .disposed(by: self.disposed)
    }
}


extension ViewController {
    static func collectionViewDataSourceUI() -> (
        CollectionViewSectionedDataSource<SectionOfPackage>.ConfigureCell,
        CollectionViewSectionedDataSource<SectionOfPackage>.ConfigureSupplementaryView){
            return({ (_, collectionView, indexPath, item) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCell", for: indexPath) as! PackageCell
                cell.value!.text = "\(item.packageName)"
                return cell
            },
                   { (dataSource ,collectionView, kind, indexPath) in
                    let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PackageCellSectionView", for: indexPath) as! PackageCellSectionView
                    section.value!.text = "\(dataSource[indexPath.section].header)"
                    section.backgroundColor = .red
                    return section
                    }
            )
    }
    
}


extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
}



class PackageCell : UICollectionViewCell {
    @IBOutlet var value: UILabel?
}

class PackageCellSectionView : UICollectionReusableView {
    @IBOutlet weak var value: UILabel?
}
