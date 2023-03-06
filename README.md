## ‘DietHelper’ - 2022.11.07 ~ 2022.12.07

🚵 기초대사량과 활동대사량 운동으로 소비한 칼로리, 먹은 칼로리를 입력하면 남은 잉여칼로리를 계산하여 다이어트가 잘 진행되고있는지 파악가능합니다.
 
<img src="https://user-images.githubusercontent.com/81205931/223026149-fbbafac4-c423-43f7-93a8-06dc98e80eb6.png">

## 🏋️ ** 앱 소개**

- 다이어트할때 **기초대사량**과 **활동대사량**을 아는것은 필수적입니다!
- **체중**과 **키** 및 **나이**를 기반으로 추정해서 제공해드립니다!
- **날짜별**로 **다이어트**가 잘 진행이 되고 있는지 확인해보세요!

## 📱 **기능 요약** 

- **RxSwift** 및 **RxCocoa**와 **MVVM** 디자인 패턴을 활용하여 구현.
- **CoreData** Framework를 사용하여 데이터들을 Persistence하게 저장하였으며 CRUD메서드들을 구현.
- **코드베이스**로 BaseView 및 BaseViewController 클래스를 생성하여 **모듈화** 및 뷰 구성.
- **WidgetKit**을 활용하여 다이어트 동기부여를 위한 위젯 생성.

## **UI**
- ### ```CodeBaseUI```
## **Architecture**
- ### ```MVVM``` 
##  **Framework & Library**
- ### ```UIKit```, ```CoreData```, ```WidgetKit```, ```SwiftUI```
- ### ```RxSwift```, ```RxCocoa```, ```SnapKit```, ```TextFieldEffects```,  ```FSCalendar```, ```IQKeyboardManager``` 

## **Trouble Shooting**
### Input - Output 모델링, transform(_:)을 활용한 MVVM
- RxSwift 및 RxCocoa 그리고 MVVM디자인 패턴에 더욱 익숙해지는 계기.
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
### CoreData의 update 구현
- 정규식을 통한 fetch를 하고 원하는 데이터를 가져온후 context를 세이브하는 방식으로 해결
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
