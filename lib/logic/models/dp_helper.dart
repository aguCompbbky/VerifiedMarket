import 'package:mysql1/mysql1.dart';


class MySql {
  static const String host = '10.0.2.2';
  static const String user = 'root';
  static const String password = 'admin';
  static const String db = 'user_informations';
  static int port = 3306;

  MySql();


void getUser() {
    var mail = "";
    
    // Open connection
    getConnection().then((conn) {
      print("Veritabanı bağlantısı başarılı");

      // Query to fetch user email
      String sql = "SELECT email FROM users LIMIT 1;";  // Adjust the query as needed

      conn.query(sql).then((results) {
        for (var row in results) {
          // Set the user email if found
          mail = row[0];  // Assuming the first column is email
          print("User email: $mail");
        }
      }).catchError((e) {
        print("Error while querying: $e");
      });
    }).catchError((e) {
      print("Error connecting to the database: $e");
    });
  }


  void setUser(String email, String password) {
    // Open connection
    getConnection().then((conn) {
      print("Veritabanı bağlantısı başarılı");

      // Query to insert or update user data (use prepared statements for security)
      String sql = "INSERT INTO users (email, name) VALUES (?, ?) ON DUPLICATE KEY UPDATE name = ?; ";  // Insert or update query

      conn.query(sql, [email, password, password]).then((result) {
        print("User added/updated successfully.");
      }).catchError((e) {
        print("Error while inserting/updating: $e");
      });
    }).catchError((e) {
      print("Error connecting to the database: $e");
    });
  }

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}
