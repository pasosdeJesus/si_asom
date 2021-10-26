require 'sivel2_gen/concerns/controllers/usuarios_controller'

class UsuariosController < Heb412Gen::ModelosController
  include Sivel2Gen::Concerns::Controllers::UsuariosController

  # No define autorización porque se requiere para autenticación
 
  def index_reordenar(c)
    if !params || !params[:filtro] || !params[:filtro][:bushabilitado]
      c = c.where("usuario.fechadeshabilitacion IS NULL")
    end
    #c = c.reorder([:apellidos])
    return c
  end
end

