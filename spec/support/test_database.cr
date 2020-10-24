class TestDatabase < Avram::Database
end

TestDatabase.configure do |settings|
  settings.credentials = Avram::Credentials.new(
    hostname: "db",
    database: "avram_dev",
    username: "lucky",
    password: "developer"
  )
end
