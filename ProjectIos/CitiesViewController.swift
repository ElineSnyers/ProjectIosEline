
import UIKit

class CitiesViewController: UIViewController,UISearchResultsUpdating{
    
     @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var searchBarPlaceholder: UIView!
    var searchController: UISearchController!
    fileprivate var cityList: [City] = []
    private var currentTask: URLSessionTask?
    

    //var cityList = [City(name: "London",attractions: [Attraction(name: "London Eye", photo: "London",description: "This is a rad",latitute: 51.503399, longitude: -0.119519),Attraction(name: "Tower", photo: "London",description:"This is the largste castle",latitute: 51.508530, longitude: -0.076132)], photo: "London"),City(name: "Rome",attractions: [Attraction(name: "Coloseum",photo: "Tower",description:"Famous place where the romans fight",latitute: 41.890251, longitude: 12.492373)], photo: "Tower"),City(name: "Brussel",attractions: [Attraction(name: "Attomium",photo: "Tower",description:"It had 9 bowls",latitute: 50.894854, longitude: 4.341084)],photo:"Tower")]
    var filteredData: [City] = []
    var attraction = [Attraction]()
    
    
    
   
    
   
    override func viewDidLoad() {
        
    splitViewController!.delegate = self
       collectionView.addSubview(errorView)
       
       
    collectionView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.sizeToFit()
        searchBarPlaceholder.addSubview(searchController.searchBar)
        automaticallyAdjustsScrollViewInsets = true
        definesPresentationContext = true
        
        hideErrorView()
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let cities):
                self.cityList = cities
                self.filteredData = self.cityList
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                self.showErrorView()
                self.collectionView.reloadData()
            }
        }
        currentTask!.resume()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
           }
    private func showErrorView() {
        self.errorView.isHidden = false
        
    }
    
    private func hideErrorView() {
        self.errorView.isHidden = true
        
    }
    
    func refreshCollectionView() {
        currentTask?.cancel()
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let cities):
                self.hideErrorView()
                self.cityList = cities
                                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                self.showErrorView()
                self.collectionView.reloadData()
                
            }
            if #available(iOS 10.0, *) {
                self.collectionView.refreshControl!.endRefreshing()
            } else {
                // Fallback on earlier versions
            }
        }
        currentTask!.resume()
    }
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let navigationController = segue.destination as! UINavigationController
            let attractionsViewController = navigationController.topViewController as! AttractionsViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            attraction = self.cityList[(indexPath?.row)!].attractions 
            attractionsViewController.attractionList = attraction
      
      
          }

    
}


    extension CitiesViewController: UICollectionViewDataSource{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filteredData.count
           
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "citiesCell", for: indexPath)
           
            let imageview:UIImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width-100, height: 100))
            let image:UIImage = UIImage(named: filteredData[indexPath.row].photo)!
            imageview.image = image;
            
            let title = UILabel(frame: CGRect(x: 20, y: 10, width: cell.bounds.size.width, height: 40))
            title.text  = filteredData[indexPath.row].name
            cell.contentView.addSubview(imageview);
            cell.contentView.addSubview(title)
            
            
           
            return cell
        }
        
        

       
      
        
        
        
            func updateSearchResults(for searchController: UISearchController) {
           
          if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? cityList : cityList.filter({ (city: City) -> Bool in
            
                return city.photo.range(of: searchText, options: .caseInsensitive) != nil
               
        })
           }
                collectionView.reloadData()
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            
            searchBar.showsCancelButton = true
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
        
}
extension CitiesViewController: UISplitViewControllerDelegate{
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}


    



    
