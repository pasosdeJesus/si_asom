Rails.application.routes.draw do
  devise_scope :usuario do
    get 'sign_out' => 'devise/sessions#destroy'
  end
  devise_for :usuarios, :skip => [:registrations], module: :devise
    as :usuario do
          get 'usuarios/edit' => 'devise/registrations#edit', 
            :as => 'editar_registro_usuario'    
          put 'usuarios/:id' => 'devise/registrations#update', 
            :as => 'registro_usuario'            
  end
  resources :usuarios, path_names: { new: 'nuevo', edit: 'edita' } 

  get '/anexos/descarga_anexo/:id' => 'sivel2_gen/anexos#descarga_anexo'
  mount Sip::Engine => "/", as: 'sip'
  mount Sivel2Gen::Engine => "/", as: 'sivel2_gen'

end
