//
//  DetalleViewController.swift
//  ApolloGraphQLUIKIT
//
//  Created by Mariano Battaglia on 07/05/22.
//

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var specie: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var status: UILabel!
    var idPersonaje: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Image Set up
        imageContainer.setShadowImage(cornerRadius: imagen.frame.width * 0.5, shadowColor: .gray, shadowRadius: 15)
        imagen.circleImage()
        api()
    }
        
    func api() {
        self.showSpinner()
        Network.shared.apollo.fetch(query: GetPersonajeQuery(id: idPersonaje!)) { res in
            switch res {
            case .success(let graphql):
                DispatchQueue.main.async {
                    let personaje = graphql.data?.character
                    self.name.text = personaje?.name
                    self.specie.text = personaje?.species
                    self.gender.text = personaje?.gender
                    self.status.text = personaje?.status
                    
                    guard let imageURL = URL(string: (personaje?.image)!) else { fatalError("sin imagen") }
                    DispatchQueue.global().async {
                        guard let imageData = try? Data(contentsOf: imageURL) else { return }
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.imagen.image = image
                        }
                    }
                    self.removeSpinner()
                }
                

            case .failure(let error):
                print(error.localizedDescription)
                self.removeSpinner()
            }
        }
        
    }


}

extension UIView {
    
    func circleImage() {
        layer.cornerRadius = frame.width * 0.5
        layer.masksToBounds = true
    }
    
    func setShadowImage(cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize = .zero, shadowOpacity: Float = 1, shadowRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = shadowRadius
    }
    
}
