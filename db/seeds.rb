conexion = ActiveRecord::Base.connection();

# De motores y finalmente de este
motor = ['msip', 'sivel2_gen', 'cor1440_gen', nil]
motor.each do |m|
    Msip::carga_semillas_sql(conexion, m, :cambios)
    Msip::carga_semillas_sql(conexion, m, :datos)
end

# usuario sivel2 con clave sivel2
conexion.execute("INSERT INTO public.usuario 
  (nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
  VALUES ('sivel2', 'sivel2@localhost', 
  '$2a$10$V2zgaN1ED44UyLy0ubey/.1erdjHYJusmPZnXLyIaHUpJKIATC1nG', 
  '', '2014-08-26', '2014-08-26', '2014-08-26', 1);")
conexion.execute("INSERT INTO public.usuario 
  (nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
  VALUES ('operador', 'operador@localhost', 
  '$2a$10$zZ0P7f/.e6ltE5dNANmDfuZeUQkD4R6Ffq9/C2tRVgv/Ccg.ZImF6', 
  '', '2021-02-08', '2024-02-08', '2021-02-08', 5);")

