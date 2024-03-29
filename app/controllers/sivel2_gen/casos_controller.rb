# frozen_string_literal: true

require 'sivel2_gen/concerns/controllers/casos_controller'

module Sivel2Gen
  class CasosController < Heb412Gen::ModelosController

    include Sivel2Gen::Concerns::Controllers::CasosController

    before_action :set_caso, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource class: Sivel2Gen::Caso, 
      except: [:index, :show, :mapaosm, :update]

    include Sivel2Gen::Concerns::Controllers::CasosController

    def campoord_inicial
      'fecha'
    end

    # GET casos/mapa
    #def mapaosm


    #  @fechadesde = Msip::FormatoFechaHelper.inicio_semestre(Date.today - 182)
    #  @fechahasta = Msip::FormatoFechaHelper.fin_semestre(Date.today - 182)
    #  render 'mapaosm', layout: 'application'
    #end
  end
end
