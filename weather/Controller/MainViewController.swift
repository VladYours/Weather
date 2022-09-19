//
//  MainViewController.swift
//  weather
//
//  Created by Vlad Rakovich on 15.09.2022.
//

import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {
    
    //fow Swinject
    var req: Networking?
    //for OpenWeather API
    let appid = "3e02bd506073cd159006874c4b47d5dd"
    
    //outlets in Main view
    @IBOutlet weak var cityBut: UIButton!
    @IBOutlet weak var currentData: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var tempMxMin: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var directionWindImg: UIImageView!
    @IBOutlet weak var dayInfoTable: UITableView!
    @IBOutlet weak var hoursInfoCollection: UICollectionView!
    @IBOutlet weak var blur: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    //coordinates of default point for weather info
    var point: Coord = Coord(lat: 47.849998, lon: 35.283333)
    //all hours from API
    var list: [InHourWeather] = []
    //wether sorted by day
    var days: [DayWeather] = []
    //all hours weather for current day
    var dayForTop: [InHourWeather] = []
    //format for hour
    let formatterHour = DateFormatter()
    //format for day name
    let formatterDayName = DateFormatter()
    //formmat for title  of day at the top
    let formatterTitle = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hoursInfoCollection.delegate = self
        hoursInfoCollection.dataSource = self
        dayInfoTable.delegate = self
        dayInfoTable.dataSource = self
        
        formatterHour.dateFormat = "HH"
        formatterDayName.dateFormat = "E"
        formatterDayName.locale = .current
        formatterTitle.dateFormat = "d MMMM"
        formatterTitle.locale = .current
        //register cells for Collection and Table
        self.hoursInfoCollection.register(UINib(nibName: "WCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "hourWeather")
        self.dayInfoTable.register(UINib(nibName: "WTableViewCell", bundle: nil), forCellReuseIdentifier: "dayWeather")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //make request for weather info
        getWeather(GPSCoord: point)
    }
    
    
    //tap on City name
    @IBAction func setCityTap(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let searchViewController = storyBoard.instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.present(searchViewController, animated:true, completion:nil)
    }
    
    
    //tap on Target pic at right upper corner
    @IBAction func setGPSTap(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "map") as! MapViewController
        self.present(mapViewController, animated:true, completion:nil)
    }
    
    
    
     //MARK: - Networking
    
    //get info about weather by GPS Point
    func getWeather(GPSCoord: Coord) {
        //make request to back for data
        guard let req = req else { fatalError("Missing dependencies") }
        req.getWeather(GPSCoord: GPSCoord, appid: appid, view: blur, successRes: setupView(weatherData:))
    }
    
    
    //MARK: - Helpers
    
    //initial setup all view
    func setupView(weatherData: WeatherAnswerByGPS) {
        //set city name
        cityBut.setTitle(weatherData.city.name, for: .normal)
        //get all data by hours
        list = weatherData.list
        //set table with days
        days = calcDays(list: list)
        dayInfoTable.reloadData()
        //get info about first day in table
        guard let firstDayHours = days.first, let firstItem = firstDayHours.hours.first else {
            return
        }
        //set collection with first day hours info
        dayForTop = firstDayHours.hours
        hoursInfoCollection.reloadData()
        //set top of main screen with info about first received hour of first day
        setupTop(info: firstItem)
        
    }
    
    
    //setup top of view
    func setupTop(info: InHourWeather) {
        //set main image
        guard let firstWeather = info.weather.first else {
            return
        }
        let urlImg = URL(string: "https://openweathermap.org/img/wn/\(firstWeather.icon)@2x.png")
        mainImg.kf.setImage(with: urlImg)
        //set max/min temp
        tempMxMin.text = "\(Int(info.main.temp_max))°/\(Int(info.main.temp_min))°"
        //set humidity
        humidity.text = "\(info.main.humidity)%"
        //set wind speed
        windSpeed.text = "\(Int(info.wind.speed))м/сек"
        //set wind direction image
        directionWindImg.image =  setDirectionWindImage(degree: info.wind.deg)
        //set title date
        let datePoint = Date(timeIntervalSince1970: TimeInterval(info.dt))
        currentData.text = "\(formatterDayName.string(from: datePoint).uppercased()), \(formatterTitle.string(from: datePoint))"
    }
    
    
    //set image of wind direction
    func setDirectionWindImage(degree: Int) -> UIImage? {
        switch degree {
        case 0...90:
            return UIImage(systemName: "arrow.up.right")
        case 91...180:
            return UIImage(systemName: "arrow.up.left")
        case 181...270:
            return UIImage(systemName: "arrow.down.left")
        case 271...360:
            return UIImage(systemName: "arrow.down.right")
        default:
            return UIImage(systemName: "arrow.up.left")
        }
        
    }
    
    
    //make right structure from input data
    func calcDays(list: [InHourWeather])->[DayWeather]{
        var tempDays: [DayWeather] = []
        guard let firstItem = list.first else {
            return []
        }
        var datePoint = Date(timeIntervalSince1970: TimeInterval(firstItem.dt))
        var tempName = formatterDayName.string(from: datePoint)
        var tAverageMin = 0
        var tAverageMax = 0
        var countItem = 0
        var img = ""
        var tempHours: [InHourWeather] = []
        //go through all data and sort it by name of week
        for item in list {
            datePoint = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let tempCurrentName = formatterDayName.string(from: datePoint)
            if (tempCurrentName == tempName) {
                //if current day have the same name as previous
                tAverageMin += Int(item.main.temp_min)
                tAverageMax += Int(item.main.temp_max)
                countItem += 1
                img = item.weather[0].icon
                tempHours.append(item)
            } else {
                //if current day have the different name as previous
                let tempDay = DayWeather(name: tempName, minT: Int(tAverageMin/countItem), maxT: Int(tAverageMin/countItem), img: img, hours: tempHours)
                tempDays.append(tempDay)
                tempName = tempCurrentName
                tAverageMin = Int(item.main.temp_min)
                tAverageMax = Int(item.main.temp_max)
                countItem = 1
                img = item.weather[0].icon
                tempHours = []
                tempHours.append(item)
            }
        }
        let tempDay = DayWeather(name: tempName, minT: Int(tAverageMin/countItem), maxT: Int(tAverageMin/countItem), img: img, hours: tempHours)
        tempDays.append(tempDay)
        return tempDays
    }
}
    
    
    //MARK: - Work with Collection

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayForTop.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourWeather", for: indexPath) as! WCollectionViewCell
        let item = dayForTop[indexPath.row]
        let datePoint = Date(timeIntervalSince1970: TimeInterval(item.dt))
        cell.hour.text = formatterHour.string(from: datePoint)
        let icon = item.weather.first?.icon ?? ""
        let urlImg = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        cell.wImg.kf.setImage(with: urlImg)
        cell.temp.text = "\(Int(item.main.temp))°"
        return cell
    }
    
    
    //tap on hour
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dayForTop[indexPath.row]
        setupTop(info: item)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
}
    
    
    //MARK: - Work with Table

    extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dayInfoTable.dequeueReusableCell(withIdentifier: "dayWeather") as! WTableViewCell
        //get item of days
        let item = days[indexPath.row]
        //set max and min temperature
        cell.temp.text = "\(item.maxT)°/\(item.minT)°"
        //set name of the day of week
        cell.dayOfWeek.text = item.name.uppercased()
        //set image of weather at that day
        let urlImg = URL(string: "https://openweathermap.org/img/wn/\(item.img)@2x.png")
        cell.weatherImg.kf.setImage(with: urlImg)
        return cell
    }
    
    
        //tap on day
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dayInfo = days[indexPath.row]
        //renew Collection
        dayForTop = dayInfo.hours
        hoursInfoCollection.reloadData()
        //set top of main view
        guard let firstHourInDay = dayForTop.first else {
            return
        }
        setupTop(info: firstHourInDay)
        
    }

}
