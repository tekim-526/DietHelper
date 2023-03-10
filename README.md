## โDietHelperโ - 2022.11.07 ~ 2022.12.07

๐ต ๊ธฐ์ด๋์ฌ๋๊ณผ ํ๋๋์ฌ๋ ์ด๋์ผ๋ก ์๋นํ ์นผ๋ก๋ฆฌ, ๋จน์ ์นผ๋ก๋ฆฌ๋ฅผ ์๋ ฅํ๋ฉด ๋จ์ ์์ฌ์นผ๋ก๋ฆฌ๋ฅผ ๊ณ์ฐํ์ฌ ๋ค์ด์ดํธ๊ฐ ์ ์งํ๋๊ณ ์๋์ง ํ์๊ฐ๋ฅํฉ๋๋ค.
 
<img src="https://user-images.githubusercontent.com/81205931/223026149-fbbafac4-c423-43f7-93a8-06dc98e80eb6.png">

## ๐๏ธ **์ฑ ์๊ฐ**

- ๋ค์ด์ดํธํ ๋ **๊ธฐ์ด๋์ฌ๋**๊ณผ **ํ๋๋์ฌ๋**์ ์๋๊ฒ์ ํ์์ ์๋๋ค!
- **์ฒด์ค**๊ณผ **ํค** ๋ฐ **๋์ด**๋ฅผ ๊ธฐ๋ฐ์ผ๋ก ์ถ์ ํด์ ์ ๊ณตํด๋๋ฆฝ๋๋ค!
- **๋ ์ง๋ณ**๋ก **๋ค์ด์ดํธ**๊ฐ ์ ์งํ์ด ๋๊ณ  ์๋์ง ํ์ธํด๋ณด์ธ์!

## ๐ฑย **๊ธฐ๋ฅ ์์ฝ** 

- **RxSwift** ๋ฐ **RxCocoa**์ **MVVM** ๋์์ธ ํจํด์ ํ์ฉํ์ฌ ๊ตฌํ.
- **CoreData** Framework๋ฅผ ์ฌ์ฉํ์ฌ ๋ฐ์ดํฐ๋ค์ Persistenceํ๊ฒ ์ ์ฅํ์์ผ๋ฉฐ CRUD๋ฉ์๋๋ค์ ๊ตฌํ.
- **์ฝ๋๋ฒ ์ด์ค**๋ก BaseView ๋ฐ BaseViewController ํด๋์ค๋ฅผ ์์ฑํ์ฌ **๋ชจ๋ํ** ๋ฐ ๋ทฐ ๊ตฌ์ฑ.
- **WidgetKit**์ ํ์ฉํ์ฌ ๋ค์ด์ดํธ ๋๊ธฐ๋ถ์ฌ๋ฅผ ์ํ ์์ ฏ ์์ฑ.

## **UI**
- ### ```CodeBaseUI```
## **Architecture**
- ### ```MVVM``` 
## ย **Framework & Library**
- ### ```UIKit```, ```CoreData```, ```WidgetKit```, ```SwiftUI```
- ### ```RxSwift```, ```RxCocoa```, ```SnapKit```, ```TextFieldEffects```,  ```FSCalendar```, ```IQKeyboardManager``` 

## **Trouble Shooting**
### Input - Output ๋ชจ๋ธ๋ง, transform(_:)์ ํ์ฉํ MVVM
- RxSwift ๋ฐ RxCocoa ๊ทธ๋ฆฌ๊ณ  MVVM๋์์ธ ํจํด์ ๋์ฑ ์ต์ํด์ง๋ ๊ณ๊ธฐ.
``` swift
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class OnboardingViewModel: ViewModelType {
    var disposebag = DisposeBag()
    
    struct Input {
        var ageInput: ControlProperty<String?>
        var heightInput: ControlProperty<String?>
        var weightInput: ControlProperty<String?>
        var maleButtonInput: ControlEvent<Void>
        var femaleButtonInput: ControlEvent<Void>
        var sliderInput: ControlProperty<Float>
        var startButtonInput: ControlEvent<Void>
    }
    
    struct Output {
        var age: Driver<String?>
        var height: Driver<String?>
        var weight: Driver<String?>
        var validation: Observable<Bool>
        var maleButton: ControlEvent<Void>
        var femaleButton: ControlEvent<Void>
        var slider: Driver<Float>
        var startButton: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let ageValid = input.ageInput.orEmpty.map { age in
            !age.isEmpty && age.count < 3
        }
        let weightValid = input.weightInput.orEmpty.map { weight in
            !weight.isEmpty && weight.count < 6
        }
        let heightvalid = input.heightInput.orEmpty.map { height in
            !height.isEmpty && height.count < 6
        }
        
        let valid = Observable.combineLatest(ageValid, heightvalid, weightValid)
            .map { $0 == true && $1 == true && $2 == true }
        
        return Output(age: input.ageInput.asDriver(),
                      height: input.heightInput.asDriver(),
                      weight: input.weightInput.asDriver(),
                      validation: valid,
                      maleButton: input.maleButtonInput,
                      femaleButton: input.femaleButtonInput,
                      slider: input.sliderInput.asDriver(),
                      startButton: input.startButtonInput)
    }
    
}
```
### CoreData์ update ๊ตฌํ
- ์ ๊ท์์ ํตํ fetch๋ฅผ ํ๊ณ  ์ํ๋ ๋ฐ์ดํฐ๋ฅผ ๊ฐ์ ธ์จํ context๋ฅผ ์ธ์ด๋ธํ๋ ๋ฐฉ์์ผ๋ก ํด๊ฒฐ
``` swift
func updateData(date: Date = Date(), age: Int64, weight: Double, height: Double, exerciseLevel: Float) {
        
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) else { return }
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
    fetchRequest.predicate = NSPredicate(format: "date = %@", date as NSDate)
        
    do {
        let data = try managedContext.fetch(fetchRequest)
        let userByDate = data[0] as! NSManagedObject
        userByDate.setValue(age, forKey: "age")
        userByDate.setValue(weight, forKey: "weight")
        userByDate.setValue(height, forKey: "height")
        userByDate.setValue(date, forKey: "date")
        userByDate.setValue(exerciseLevel, forKey: "exerciseLevel")
            
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    } catch {
        print(error)
    }
}
```
### ___ํ๊ณ ___
Persistenceํ ๋ฐ์ดํฐ ์ ์ฅ์ CoreData๋ฅผ ํ์ฉํ๋๋ฐ CoreData์ ๋ค์ํ ๊ธฐ๋ฅ ์ค ํ์ํ๋ ๊ธฐ๋ฅ์ด ๋ฐ์ดํฐ ์ ์ฅ ํ๋๋ฟ์ด์ด์ Realm์ ์ฌ์ฉํ๋๊ฒ์ด ๋ฐ์ดํฐ์ ์์ถ๋ ฅ์์ ์ด์ ์ ๊ฐ์ง์์์ ๊ฒ ๊ฐ๋ค. ๊ทธ๋ฆฌ๊ณ CoreData์์ ์ํ๋ ๋ฐ์ดํฐ๋ฅผ ์๋ฐ์ดํธํ๋ ๊ณผ์ ์ด ๋ฐ์ดํฐ๋ฅผ ์์ฑํ๋ ๊ณผ์ ๊ณผ ๋น์ทํ๋ค๊ณ  ๋๊ผ๋๋ฐ ๋ฐ๋ณต์ ์ผ๋ก ์ฐ์ด๋ ์ฝ๋๋ค์ ์ค์ผ ์ ์์์ ๊ฒ ๊ฐ๋ค.  
๋ํ ๋ ์ง๋ฅผ ๋ค๋ฃจ๋ ๋ถ๋ถ์์ **Calendar.current.dateComponents([.year, .month, .day], from: date)** ๋ฅผ ์์ฃผ ์ฌ์ฉํ๋๋ฐ ๋ฐ๋ก ๋ณ์๋ ์์๋ฑ์ผ๋ก ๋นผ์ ์ ์ญ์ ์ผ๋ก ์ฌ์ฉํ๋ค๋ฉด ๋ ์ข์์๊ฒ ๊ฐ๋ค. 
