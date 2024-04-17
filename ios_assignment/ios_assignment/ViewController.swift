//
//  ViewController.swift
//  ios_assignment
//
//  Created by Aditya on 16/04/24.
//

import UIKit

class ViewController: UIViewController {
    private let cellIdentifier = "CollectionViewCell"
    let inset: CGFloat = 5
    let minimumLineSpacing: CGFloat = 5
    let minimumInteritemSpacing: CGFloat = 5
    let cellsPerRow = 3
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ViewModel()
    var rawImageBaseModel = [ImageModel]()
    var images = [UIImage?]()
    var currentPage = 22 // Current page of data

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        viewModel.callApi(page: currentPage)
        viewModel.delegate = self
        //        loadImages()
        // Do any additional setup after loading the view.
    }
    func setUpDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:cellIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: cellIdentifier)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height){
            currentPage = currentPage + 10
            viewModel.callApi(page: currentPage)
        }
    }
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return rawImageBaseModel.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier , for: indexPath) as! CollectionViewCell
        let domainUrl = rawImageBaseModel[indexPath.row].thumbnail?.domain ?? ""
        let basePath = rawImageBaseModel[indexPath.row].thumbnail?.basePath ?? ""
        let key = rawImageBaseModel[indexPath.row].thumbnail?.key ?? ""
        let finalUrl = domainUrl + "/" + basePath + "/0/" + key
        if let imageUrl = URL(string: finalUrl) {
            cell.imgView.contentMode = .center
            cell.imgView.setImage(with: imageUrl,placeholder: UIImage(systemName: "photo.artframe.circle.fill"))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
extension ViewController:ViewModelDelegate{
    func didFailData(errorData: String) {
        // Step 1: Create the alert controller
        let alert = UIAlertController(title: "Error", message: errorData, preferredStyle: .alert)
        
        // Step 2: Add an action (button)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OK button tapped.")
        }
        alert.addAction(okAction)
        
        // Step 3: Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func didLoadData() {
        do{
            let decoder = JSONDecoder()
            let object = try decoder.decode(ErrorCode.self, from: viewModel.rawData ?? Data())
            let alert = UIAlertController(title: "Error", message:object.error , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK button tapped.")
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }catch(let error){
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode([ImageModel].self, from: viewModel.rawData ?? Data())
                print(object)
    //            self.rawBaseModel = object
    //            self.filterBaseModel = object
                self.rawImageBaseModel = object
                collectionView.reloadData()
            }catch(let error){
                print(error)
            }
        }
    }
}
