import SwiftUI

final class GuideViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var favorites: [Guide] = []

    @Published var guides: [Guide] = []
    @Published var guideDetails: GuideDetails?
    @Published var guideSteps: [GuideStep] = []
    
    @Published var hasFetchedFavorites: Bool = false
    @Published var shouldUpdateFavorites: Bool = false
    @Published var isStepsPresented: Bool = false
    
    @Published var isFetchingFavorites: Bool = false
    
    var authVM = AuthViewModel()
    
    let emptyDetails: GuideDetails = GuideDetails(
        id: "",
        emoji: "",
        title: "",
        description: "",
        image: "",
        authorId: "",
        author: Author(username: ""),
        isFavorite: false
    )
    
    var filteredGuides: [Guide] {
        guard !searchText.isEmpty else { return self.guides }
        return self.guides.filter { guide in
            guide.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    func resetGuideDetails() {
        self.guideDetails = nil
    }
    
    func resetGuideSteps() {
        self.guideSteps = []
    }
    
    
    func isFavorite(_ item: GuideDetails) -> Bool {
        return item.isFavorite
    }
    
    func toggleFavorite(item: GuideDetails, token: String) {
        if isFavorite(item) {
            deleteFromFavorites(id: item.id, token: token)
        } else {
            addToFavorites(id: item.id, token: token)
        }
        self.shouldUpdateFavorites = true
    }
    
    func fetcnGuideSteps(id: String, token: String) {
        GuideStepAction(id: id, token: token).call() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.guideSteps = response
                    print("Successfully parsed guide steps")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func addToFavorites(id: String, token: String) {
        FavoritesAddAction(id: id, token: token).call() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Response: \(response.message)")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func deleteFromFavorites(id: String, token: String) {
        FavoritesDeleteAction(id: id, token: token).call() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Response: \(response.message)")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func fetchFavorites(token: String) {
        isFetchingFavorites = true
        FavoritesAction(token: token).call() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favorites):
                    self.favorites = favorites
                    print("Successfully parsed favorites")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
        isFetchingFavorites = false
    }
    
    func fetchGuides(token: String) {
        GuideAction(token: token).call() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let guideCards):
                    self.guides = guideCards
                    print("Successfully parsed guide cards")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func fetchGuideDetails(id: String, token: String) {
        GuideDetailsAction(id: id, token: token).call() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.guideDetails = details
                    
                    if let data = try? JSONEncoder().encode(details), let jsonString = String(data: data, encoding: .utf8) {
                        print("Received response struct: \(jsonString)")
                    } else {
                        print("Received empty or invalid data")
                    }
                    print("Successfully parsed guide details")
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: ErrorResponse) {
        print("Code: \(error.code)\nMessage: \(error.message)")
        authVM.errorResponse = error
        if error.code == RequestError.tokenExpired.rawValue || error.code == RequestError.tokenInvalid.rawValue {
            authVM.triggerSessionExpired()
        }
    }
}
