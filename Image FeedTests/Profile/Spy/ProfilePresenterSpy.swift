
import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {

    var viewDidLoadCalled = false
    var view: ProfileViewProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func logoutButtonTapped() {
        
    }
   
}
