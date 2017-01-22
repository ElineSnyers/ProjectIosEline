
import UIKit

class AttractionsViewController: UIViewController,UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var attractionList = [Attraction] ()
    var filteredData = [Attraction]()
   var searchController: UISearchController!
    
    override func viewDidLoad() {
     
        //attractionList = [Attraction(name: "London Eye"),Attraction(name: "Tower")]
        //self.tableView.reloadData()
        tableView.dataSource = self
        
        filteredData = attractionList
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true

        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
       let attractionViewController = navigationController.topViewController as! AttractionViewController
        let selectedIndex = tableView.indexPathForSelectedRow!.row
    attractionViewController.attraction = attractionList[selectedIndex]
   }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
}


extension AttractionsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return self.filteredData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "previewAttractionCell", for: indexPath) as! PreviewAttractionCell
       let attraction = filteredData[indexPath.row]
        cell.attrationLabel.text = attraction.name
        
        cell.photoView.image = UIImage(named: attraction.photo)
        
        
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? attractionList : attractionList.filter({ (attraction: Attraction) -> Bool in
                
                return attraction.name.range(of: searchText, options: .caseInsensitive) != nil
                
            })
        }
        tableView.reloadData()
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
extension AttractionsViewController: UISplitViewControllerDelegate{
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}







