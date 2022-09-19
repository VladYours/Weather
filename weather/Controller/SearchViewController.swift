//
//  SearchViewController.swift
//  weather
//
//  Created by Vlad Rakovich on 17.09.2022.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate  {
    
    

    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var loupe: UIImageView!
    @IBOutlet weak var cTable: UITableView!
    
    var cityList: [CityItem] = []
    var citySource: [CityItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate
        cTable.delegate = self
        cTable.dataSource = self
        search.delegate = self
        //get city from resource file
        if let path = Bundle.main.path(forResource: "city", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                citySource = try JSONDecoder().decode([CityItem].self, from: data)
                cityList = citySource
              } catch {
                   // handle error
                  print("Error parse source")
              }
        }
        //set gesture for back
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(handleTapBack))
        tapBack.delegate = self
        back.addGestureRecognizer(tapBack)
        //set gesture for search
        let tapLoupe = UITapGestureRecognizer(target: self, action: #selector(handleTapLoupe))
        tapLoupe.delegate = self
        loupe.addGestureRecognizer(tapLoupe)
    }
    
    
    //tap on back
    @objc func handleTapBack(gestureRecognizer: UITapGestureRecognizer){
        //go to main view
        print("tap Back")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        self.present(mainViewController, animated:true, completion:nil)
    }
    
    
    //tap on search
    @objc func handleTapLoupe(){
        print("tap Loupe")
        makeSearch()
    }
    
    
    
    @IBAction func changeSearchField(_ sender: Any) {
        makeSearch()
    }
    
    
    func makeSearch(){
        guard let searchText = search.text else {
            return
        }
        if (searchText.count > 3) {
            cityList = citySource.filter({$0.name.contains(searchText)})
            cTable.reloadData()
        }
    }
}
    
 
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cTable.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        let item = cityList[indexPath.row]
        cell.cityName.text = "\(item.name), \(item.country)"
        return cell
    }
    
    
    //tap on row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = cityList[indexPath.row]
        //go to main view
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        mainViewController.point = Coord(lat: item.coord.lat, lon: item.coord.lon)
        self.present(mainViewController, animated:true, completion:nil)
    }
}
