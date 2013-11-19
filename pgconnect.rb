module PgConnect

  def connect_to_db
    if ENV['environment'] != 'production'
      @conn = PG::Connection.open(dbname: 'broscopes')
    else
      db = URI.parse(ENV['DATABASE_URL'])
      @conn = PG::Connection.new( {host: db.host, user: db.user, port: db.port, password: db.password, dbname:db.path[1..-1] } )
    end
  end

end
