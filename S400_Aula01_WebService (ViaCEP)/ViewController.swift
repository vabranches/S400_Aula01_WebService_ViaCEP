
import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var textFieldCEP: UITextField!
    @IBOutlet weak var textViewEndereco: UITextView!
    
    
    //MARK: Propriedades
    var minhaSessao : URLSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minhaSessao = URLSession(configuration: .default)

    }
    
    //MARK: Actions
    @IBAction func buscar(_ sender: UIButton) {
        
        //Captando o CEP digitado pelo usuario
        var cepInformado = ""
        
        if !(textFieldCEP.text!.isEmpty) {
            
            cepInformado = textFieldCEP.text!
            
            //Consultando o servidor e devolvendo a resposta
            let minhaURL = URL(string: "https://viacep.com.br/ws/\(cepInformado)/json/")!
            
            let tarefa = minhaSessao.dataTask(with: minhaURL, completionHandler: { (data, response, erro) in
                if erro == nil {
                    let meuResponse = response as? HTTPURLResponse
                    
                    if meuResponse?.statusCode == 200{
                        
                        guard let dataTemp = data else {return}
                        
                        do {
                            let meuJSON = try JSONSerialization.jsonObject(with: dataTemp, options: .allowFragments) as! [String : AnyObject]
                            
                            if let nomeRua = meuJSON["logradouro"]{
                                DispatchQueue.main.async {
                                    self.textViewEndereco.text = "Logradouro encontrado: \n\(nomeRua)"
                                    self.textFieldCEP.text = ""
                                }
                            }
                            
                            if (meuJSON["erro"] != nil){
                                
                                DispatchQueue.main.async {
                                    let alerta = UIAlertController(title: "Alerta", message: "CEP informado não existe", preferredStyle: .alert)
                                    alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    
                                    self.present(alerta, animated: true)
                                }

                            }
                            
                        } catch {}

                    } else{
                        DispatchQueue.main.async {
                            let alerta = UIAlertController(title: "Alerta", message: "Erro na rede ou CEP inválido", preferredStyle: .alert)
                            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(alerta, animated: true)
                        }
                    }
                    
                }
               
            })
            
            tarefa.resume()
            
        } else {

            let alerta = UIAlertController(title: "Alerta", message: "Preencha o campo CEP", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alerta, animated: true)
            
        }
        

        
    }
    
    
    //MARK: Propriedades e Métodos de UIResponder
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }


}

