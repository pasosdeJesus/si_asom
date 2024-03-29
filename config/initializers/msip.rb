require 'sivel2_gen/version'

Msip.setup do |config|
  config.ruta_anexos = ENV.fetch(
    'MSIP_RUTA_ANEXOS', "#{Rails.root}/archivos/anexos/")
  config.ruta_volcados = ENV.fetch(
    'MSIP_RUTA_VOLCADOS', "#{Rails.root}/archivos/bd/")

  # En heroku los anexos son super-temporales
  if ENV["HEROKU_POSTGRESQL_MAUVE_URL"]
    config.ruta_anexos = "#{Rails.root}/tmp/"
  end
  config.titulo = "SI ASOM #{Sivel2Gen::VERSION}"
end
