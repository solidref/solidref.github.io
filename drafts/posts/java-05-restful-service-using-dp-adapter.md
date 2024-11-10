**Implementation of `DatabaseAdapter` (Adapter Pattern)**

---

**Purpose of `DatabaseAdapter`:**

The `DatabaseAdapter` class allows the application to interact with different database systems through a common interface. By applying the **Adapter Pattern**, it enables the application to work with multiple database types (e.g., SQLite, MySQL) without changing the core business logic.

---

**Adapter Pattern Implementation:**

1. **Target Interface (`DatabaseOperations`):**

  - Defines the standard operations that the application expects for database interactions.
  - Includes methods like `connect()`, `saveTask(Task task)`, `getTask(UUID id)`, `updateTask(Task task)`, and `deleteTask(UUID id)`.

2. **Adaptee Classes (`SQLiteDatabase`, `MySQLDatabase`):**

  - These are the existing classes that implement database-specific operations.
  - Their interfaces may not match the `DatabaseOperations` interface.

3. **Adapter Class (`DatabaseAdapter`):**

  - Implements the `DatabaseOperations` interface.
  - Internally uses an instance of an adaptee class.
  - Translates calls from the target interface to the adaptee's methods.

---

**Implementation Details:**

**1. Target Interface (`DatabaseOperations`):**

```java
public interface DatabaseOperations {
    void connect();
    void saveTask(Task task);
    Task getTask(UUID id);
    void updateTask(Task task);
    void deleteTask(UUID id);
}
```

- **Purpose:**
  - Provides a consistent interface for database operations.
  - Abstracts the underlying database implementation.

**2. Adaptee Classes:**

**`SQLiteDatabase`:**

```java
public class SQLiteDatabase {
    // Methods specific to SQLite operations
    public void openConnection() {
        // Code to open SQLite connection
    }

    public void insertTask(Task task) {
        // Code to insert a task into SQLite database
    }

    public Task fetchTask(UUID id) {
        // Code to retrieve a task from SQLite database
        return new Task(); // Placeholder
    }

    public void modifyTask(Task task) {
        // Code to update a task in SQLite database
    }

    public void removeTask(UUID id) {
        // Code to delete a task from SQLite database
    }
}
```

**`MySQLDatabase`:**

```java
public class MySQLDatabase {
    // Methods specific to MySQL operations
    public void establishConnection() {
        // Code to establish MySQL connection
    }

    public void addTask(Task task) {
        // Code to add a task to MySQL database
    }

    public Task retrieveTask(UUID id) {
        // Code to retrieve a task from MySQL database
        return new Task(); // Placeholder
    }

    public void updateTaskInDB(Task task) {
        // Code to update a task in MySQL database
    }

    public void deleteTaskFromDB(UUID id) {
        // Code to delete a task from MySQL database
    }
}
```

**3. Adapter Class (`DatabaseAdapter`):**

```java
public class DatabaseAdapter implements DatabaseOperations {
    private Object database;
    private String dbType;

    public DatabaseAdapter(String dbType) {
        this.dbType = dbType;
        if (dbType.equalsIgnoreCase("SQLite")) {
            database = new SQLiteDatabase();
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            database = new MySQLDatabase();
        } else {
            throw new IllegalArgumentException("Unsupported database type: " + dbType);
        }
    }

    @Override
    public void connect() {
        if (dbType.equalsIgnoreCase("SQLite")) {
            ((SQLiteDatabase) database).openConnection();
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            ((MySQLDatabase) database).establishConnection();
        }
    }

    @Override
    public void saveTask(Task task) {
        if (dbType.equalsIgnoreCase("SQLite")) {
            ((SQLiteDatabase) database).insertTask(task);
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            ((MySQLDatabase) database).addTask(task);
        }
    }

    @Override
    public Task getTask(UUID id) {
        if (dbType.equalsIgnoreCase("SQLite")) {
            return ((SQLiteDatabase) database).fetchTask(id);
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            return ((MySQLDatabase) database).retrieveTask(id);
        }
        return null;
    }

    @Override
    public void updateTask(Task task) {
        if (dbType.equalsIgnoreCase("SQLite")) {
            ((SQLiteDatabase) database).modifyTask(task);
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            ((MySQLDatabase) database).updateTaskInDB(task);
        }
    }

    @Override
    public void deleteTask(UUID id) {
        if (dbType.equalsIgnoreCase("SQLite")) {
            ((SQLiteDatabase) database).removeTask(id);
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            ((MySQLDatabase) database).deleteTaskFromDB(id);
        }
    }
}
```

- **Explanation:**
  - The `DatabaseAdapter` class implements the `DatabaseOperations` interface.
  - It holds a reference to the specific database instance (`SQLiteDatabase` or `MySQLDatabase`).
  - Methods in `DatabaseOperations` are adapted to the methods of the underlying database class.
  - The adapter checks the `dbType` to determine which database operations to invoke.

---

**Usage Example:**

**Initializing the Database Adapter:**

```java
public class Application {
    public static void main(String[] args) {
        // Choose the database type (could be from config)
        String dbType = "SQLite"; // or "MySQL"

        // Create the adapter
        DatabaseOperations dbAdapter = new DatabaseAdapter(dbType);

        // Connect to the database
        dbAdapter.connect();

        // Use the adapter to perform database operations
        Task task = new TaskBuilder("Design Patterns").setDescription("Study Adapter Pattern").build();
        dbAdapter.saveTask(task);

        // Retrieve the task
        Task retrievedTask = dbAdapter.getTask(task.getId());

        // Update the task
        retrievedTask.setDescription("Study Adapter Pattern in detail");
        dbAdapter.updateTask(retrievedTask);

        // Delete the task
        dbAdapter.deleteTask(task.getId());
    }
}
```

- **Explanation:**
  - The application initializes the `DatabaseAdapter` with the desired database type.
  - It performs database operations using the `DatabaseOperations` interface.
  - The underlying database implementation is transparent to the application.

---

**Advantages of the Adapter Pattern:**

1. **Flexibility:**
  - Allows the application to switch between different databases without changing business logic.
  - Supports adding new database types with minimal changes.

2. **Reusability:**
  - The adapter provides a common interface, making it easy to reuse code across different database implementations.

3. **Decoupling:**
  - Separates the application's logic from database-specific code.
  - Enhances maintainability and scalability.

---

**Integration with Other Components:**

- **In `TaskRequestHandler`:**
  - The handler can use `DatabaseOperations` to interact with tasks, without worrying about the specific database implementation.

  ```java
  public class TaskRequestHandler extends RequestHandler {
      private DatabaseOperations dbAdapter;

      public TaskRequestHandler(DatabaseOperations dbAdapter) {
          this.dbAdapter = dbAdapter;
      }

      // Existing methods...

      private ResponseData handlePost(RequestData requestData) {
          // Create task using TaskBuilder...
          dbAdapter.saveTask(task);
          // Return response...
      }
  }
  ```

- **In `MainServer`:**
  - When initializing the server, pass the `dbAdapter` to handlers.

  ```java
  private void startServer() {
      // Initialize the database adapter
      DatabaseOperations dbAdapter = new DatabaseAdapter("SQLite");

      // Pass dbAdapter to the handler
      server.createContext("/tasks", new TaskRequestHandler(dbAdapter));
      // Start the server...
  }
  ```

---

**Considerations and Simplifications:**

- **Simplified Database Classes:**
  - The `SQLiteDatabase` and `MySQLDatabase` classes are simplified and may not include actual database code.
  - In a real application, these classes would handle actual database connections and queries.

- **Type Checking:**
  - The adapter uses `instanceof` and casting based on `dbType`.
  - For a cleaner design, consider using polymorphism or a more scalable approach.

- **Error Handling:**
  - Exception handling is minimal.
  - Proper error checking and handling should be implemented for robustness.

- **Configuration:**
  - The database type is hard-coded; in a real application, it should come from configuration files or environment variables.

---

**Alternative Implementation with Polymorphism:**

To improve the design and avoid using `instanceof` and casting, we can define specific adapters for each database type that implement the `DatabaseOperations` interface.

**`SQLiteAdapter`:**

```java
public class SQLiteAdapter implements DatabaseOperations {
    private SQLiteDatabase database;

    public SQLiteAdapter() {
        database = new SQLiteDatabase();
    }

    @Override
    public void connect() {
        database.openConnection();
    }

    @Override
    public void saveTask(Task task) {
        database.insertTask(task);
    }

    @Override
    public Task getTask(UUID id) {
        return database.fetchTask(id);
    }

    @Override
    public void updateTask(Task task) {
        database.modifyTask(task);
    }

    @Override
    public void deleteTask(UUID id) {
        database.removeTask(id);
    }
}
```

**`MySQLAdapter`:**

```java
public class MySQLAdapter implements DatabaseOperations {
    private MySQLDatabase database;

    public MySQLAdapter() {
        database = new MySQLDatabase();
    }

    @Override
    public void connect() {
        database.establishConnection();
    }

    @Override
    public void saveTask(Task task) {
        database.addTask(task);
    }

    @Override
    public Task getTask(UUID id) {
        return database.retrieveTask(id);
    }

    @Override
    public void updateTask(Task task) {
        database.updateTaskInDB(task);
    }

    @Override
    public void deleteTask(UUID id) {
        database.deleteTaskFromDB(id);
    }
}
```

**Factory for Adapters (`DatabaseAdapterFactory`):**

```java
public class DatabaseAdapterFactory {
    public static DatabaseOperations getDatabaseAdapter(String dbType) {
        if (dbType.equalsIgnoreCase("SQLite")) {
            return new SQLiteAdapter();
        } else if (dbType.equalsIgnoreCase("MySQL")) {
            return new MySQLAdapter();
        } else {
            throw new IllegalArgumentException("Unsupported database type: " + dbType);
        }
    }
}
```

**Usage:**

```java
DatabaseOperations dbAdapter = DatabaseAdapterFactory.getDatabaseAdapter("SQLite");
```

- **Advantages:**
  - Eliminates the need for casting and `instanceof`.
  - Adheres to the Open/Closed Principle, allowing easy addition of new database adapters.
  - Each adapter is responsible for adapting a specific database, improving code organization.

---

**Why Use the Adapter Pattern Here?**

- **Compatibility:**
  - Allows integration of classes with incompatible interfaces.
  - The application code interacts with a consistent interface (`DatabaseOperations`), regardless of the underlying database.

- **Code Reuse:**
  - Existing database classes can be used without modification.
  - Adapters translate the interface, enabling reuse.

- **Maintainability:**
  - Changes to database-specific code are isolated within the adapter classes.
  - Reduces the impact of changes on the rest of the application.

---

**Key Components of the Adapter Pattern:**

1. **Target Interface (`DatabaseOperations`):**
  - The interface expected by the client code.

2. **Adaptee (`SQLiteDatabase`, `MySQLDatabase`):**
  - The existing classes needing adaptation.

3. **Adapter (`DatabaseAdapter`, `SQLiteAdapter`, `MySQLAdapter`):**
  - Converts the interface of the adaptee into the target interface.

---

**Conclusion:**

The `DatabaseAdapter` class exemplifies the **Adapter Pattern** by allowing the application to interact with different database systems through a unified interface. This design enhances flexibility, promotes code reuse, and decouples the application logic from database-specific implementations.

By implementing `DatabaseAdapter`:

- The application can switch databases without altering core logic.
- New databases can be integrated with minimal changes.
- The codebase remains clean, maintainable, and scalable.

This implementation aligns with our goal of using design patterns to create a robust Java web service application within approximately 20 classes.

---

**Next Steps:**

- **Implement Database Logic:**
  - Flesh out the `SQLiteDatabase` and `MySQLDatabase` classes with actual database connection and query code.

- **Enhance Error Handling:**
  - Implement proper exception handling and resource management (e.g., closing connections).

- **Configuration Management:**
  - Externalize database configuration to properties files or environment variables.

- **Testing:**
  - Write unit tests to verify the adapter functionality with different databases.

- **Apply Additional Patterns:**
  - Consider using the **Singleton Pattern** for database connections to manage resources efficiently.

---

**By completing the implementation and explanation of `DatabaseAdapter`, we have advanced our simple Java web service application. This demonstrates how the **Adapter Pattern** can be used to integrate incompatible interfaces, enhancing flexibility and maintainability within the constraints of a limited number of classes.


------------------

**Implementation of `DatabaseConnectionManager` (Singleton Pattern)**

---

**DatabaseConnectionManager.java**

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnectionManager {
    // Static variable to hold the single instance
    private static volatile DatabaseConnectionManager instance = null;

    // Database connection parameters
    private String url;
    private String username;
    private String password;

    // The database connection object
    private Connection connection;

    // Private constructor to prevent instantiation
    private DatabaseConnectionManager(String url, String username, String password) throws SQLException {
        this.url = url;
        this.username = username;
        this.password = password;
        // Initialize the database connection
        this.connection = createConnection();
    }

    // Public method to provide access to the instance
    public static DatabaseConnectionManager getInstance(String url, String username, String password) throws SQLException {
        if (instance == null) {
            synchronized (DatabaseConnectionManager.class) {
                if (instance == null) {
                    instance = new DatabaseConnectionManager(url, username, password);
                }
            }
        }
        return instance;
    }

    // Method to create a new database connection
    private Connection createConnection() throws SQLException {
        try {
            // Load the JDBC driver if necessary (depends on the JDBC version)
            // Class.forName("org.sqlite.JDBC"); // For SQLite
            // Class.forName("com.mysql.cj.jdbc.Driver"); // For MySQL

            // Create and return the connection
            return DriverManager.getConnection(url, username, password);
        } catch (SQLException /*| ClassNotFoundException*/ e) {
            e.printStackTrace();
            throw e;
        }
    }

    // Getter for the connection
    public Connection getConnection() {
        return connection;
    }

    // Method to close the connection
    public void closeConnection() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}
```

---

**Explanation:**

**Purpose of `DatabaseConnectionManager`:**

The `DatabaseConnectionManager` class is responsible for managing the database connection in the application. It ensures that only one instance of the database connection exists throughout the application's lifecycle by implementing the **Singleton** design pattern. This approach helps in:

- **Resource Management:** Database connections are resource-intensive. Managing them centrally avoids unnecessary overhead.
- **Consistency:** Ensures all parts of the application use the same database connection settings.
- **Thread Safety:** By controlling access to the connection, it helps prevent concurrency issues.

---

**Singleton Pattern Implementation:**

1. **Private Static Instance Variable:**

   ```java
   private static volatile DatabaseConnectionManager instance = null;
   ```

  - Declared `static` to belong to the class.
  - Declared `volatile` to ensure visibility of changes across threads.

2. **Private Constructor:**

   ```java
   private DatabaseConnectionManager(String url, String username, String password) throws SQLException {
       this.url = url;
       this.username = username;
       this.password = password;
       this.connection = createConnection();
   }
   ```

  - **Purpose:** Prevents instantiation from outside the class.
  - Initializes the database connection.

3. **Public Static Access Method:**

   ```java
   public static DatabaseConnectionManager getInstance(String url, String username, String password) throws SQLException {
       if (instance == null) {
           synchronized (DatabaseConnectionManager.class) {
               if (instance == null) {
                   instance = new DatabaseConnectionManager(url, username, password);
               }
           }
       }
       return instance;
   }
   ```

  - Uses **double-checked locking** to ensure thread safety and avoid unnecessary synchronization after the instance is created.
  - Parameters `url`, `username`, and `password` are required for the initial connection setup.
  - Throws `SQLException` to indicate database connection issues.

4. **Connection Management:**

  - **Create Connection Method:**

    ```java
    private Connection createConnection() throws SQLException {
        // Load the JDBC driver if necessary
        // Return the connection
        return DriverManager.getConnection(url, username, password);
    }
    ```

    - Responsible for establishing the database connection.
    - Optionally loads the JDBC driver (depending on the JDBC version and driver).

  - **Get Connection Method:**

    ```java
    public Connection getConnection() {
        return connection;
    }
    ```

    - Provides access to the database connection for other classes.

  - **Close Connection Method:**

    ```java
    public void closeConnection() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
    ```

    - Closes the database connection when it's no longer needed.

---

**Usage Example:**

**In the Application Initialization:**

```java
public class Application {
    public static void main(String[] args) {
        try {
            // Database parameters (could be loaded from a config file)
            String url = "jdbc:mysql://localhost:3306/mydatabase";
            String username = "root";
            String password = "password";

            // Get the DatabaseConnectionManager instance
            DatabaseConnectionManager dbManager = DatabaseConnectionManager.getInstance(url, username, password);

            // Pass the connection to the DatabaseAdapter
            DatabaseOperations dbAdapter = new DatabaseAdapter(dbManager.getConnection());

            // Continue with application logic...

        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exception (e.g., exit application or retry)
        }
    }
}
```

**Modifying `DatabaseAdapter` to Use `Connection`:**

```java
public class DatabaseAdapter implements DatabaseOperations {
    private Connection connection;

    public DatabaseAdapter(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void connect() {
        // Connection is already established via DatabaseConnectionManager
    }

    @Override
    public void saveTask(Task task) {
        // Use the connection to save the task
        // Example:
        // String sql = "INSERT INTO tasks (id, title, description) VALUES (?, ?, ?)";
        // PreparedStatement stmt = connection.prepareStatement(sql);
        // stmt.setString(1, task.getId().toString());
        // stmt.setString(2, task.getTitle());
        // stmt.setString(3, task.getDescription());
        // stmt.executeUpdate();
    }

    // Implement other methods similarly
}
```

- **Explanation:**
  - The `DatabaseAdapter` now receives a `Connection` object, which it uses for database operations.
  - This approach decouples connection management from the adapter.

---

**Why Singleton Pattern for `DatabaseConnectionManager`?**

1. **Single Point of Access:**
  - Ensures only one connection manager exists, preventing multiple connections from being opened unnecessarily.

2. **Resource Efficiency:**
  - Database connections consume resources; managing them centrally avoids resource leaks.

3. **Thread Safety:**
  - By controlling the instantiation and access to the connection, the singleton pattern helps in maintaining thread safety.

4. **Configuration Consistency:**
  - All parts of the application use the same database parameters (URL, username, password).

---

**Key Components:**

1. **Private Constructor:**
  - Prevents external instantiation.

2. **Static Access Method:**
  - Controls the creation and access to the singleton instance.

3. **Thread Safety Measures:**
  - **Double-checked Locking:**
    - Reduces synchronization overhead.
    - Ensures that only one instance is created even in a multithreaded environment.
  - **Volatile Keyword:**
    - Ensures that the instance variable is read from the main memory, not from a thread's local cache.

---

**Considerations and Best Practices:**

1. **Exception Handling:**
  - The constructor and `getInstance` method throw `SQLException` to handle database connection issues.
  - Callers should handle these exceptions appropriately.

2. **Connection Pooling:**
  - For high-load applications, consider implementing connection pooling to manage multiple connections efficiently.
  - Libraries like HikariCP or Apache DBCP can be integrated.

3. **Closing Connections:**
  - Ensure `closeConnection` is called appropriately to release resources.
  - Consider using a shutdown hook or application context listener to close the connection when the application stops.

4. **Configuration Management:**
  - Database parameters can be externalized to configuration files or environment variables.
  - Avoid hardcoding sensitive information like usernames and passwords.

5. **Driver Loading:**
  - In newer JDBC versions, explicit driver loading (`Class.forName`) is not required.
  - For older drivers or when using specific database systems, you may need to load the driver class manually.

---

**Integration with Other Components:**

- **`DatabaseAdapter`:**
  - Uses the `Connection` provided by `DatabaseConnectionManager` to perform database operations.
  - By passing the connection, we ensure that all database interactions use the same connection.

- **`TaskRequestHandler`:**
  - Interacts with `DatabaseAdapter` to perform CRUD operations on tasks.
  - The database connection details are abstracted away, promoting decoupling.

---

**Example Flow:**

1. **Application Startup:**
  - Initializes `DatabaseConnectionManager` with database parameters.
  - Obtains the singleton instance.

2. **Database Adapter Initialization:**
  - `DatabaseAdapter` is created with the connection from `DatabaseConnectionManager`.

3. **Request Handling:**
  - When a request comes in, `TaskRequestHandler` uses `DatabaseAdapter` to interact with the database.

4. **Application Shutdown:**
  - Calls `closeConnection` to release the database connection.

---

**Advantages:**

1. **Centralized Connection Management:**
  - Simplifies the management of database connections.
  - Reduces the risk of connection leaks.

2. **Consistent Configuration:**
  - All components use the same database settings.

3. **Ease of Maintenance:**
  - Changes to database connection logic are made in one place.

---

**Potential Drawbacks and Mitigation:**

1. **Single Point of Failure:**
  - If the singleton instance encounters an issue, it may affect the entire application.
  - **Mitigation:** Implement proper exception handling and consider failover strategies.

2. **Limited Scalability:**
  - A single connection may become a bottleneck in high-concurrency scenarios.
  - **Mitigation:** Implement connection pooling or allow multiple connections if necessary.

3. **Testing Challenges:**
  - Singletons can make unit testing difficult due to their global state.
  - **Mitigation:** Use dependency injection or mock the singleton in tests.

---

**Extending the Design:**

- **Lazy Initialization:**
  - The connection is established only when `getConnection` is called, not at instance creation.

- **Connection Validation:**
  - Implement methods to check if the connection is still valid and reconnect if necessary.

- **Singleton via Enum (Alternative):**
  - In Java, singletons can be implemented using an enum to prevent multiple instantiations.

  ```java
  public enum DatabaseConnectionManager {
      INSTANCE;

      private Connection connection;

      private DatabaseConnectionManager() {
          // Initialize connection
      }

      public Connection getConnection() {
          return connection;
      }
  }
  ```

  - **Note:** This approach is thread-safe and protects against serialization/deserialization issues.

---

**Conclusion:**

The `DatabaseConnectionManager` class effectively implements the **Singleton Pattern** to manage database connections within the application. It ensures that:

- Only one instance of the connection manager exists.
- Database connections are efficiently managed.
- The application maintains consistent database configurations.

By centralizing connection management, the application becomes more maintainable, scalable, and robust.

---

**Next Steps:**

1. **Implement Connection Pooling (Optional):**
  - For applications with high concurrency, integrate a connection pool.

2. **Enhance Exception Handling:**
  - Provide more detailed error messages and recovery strategies.

3. **Externalize Configuration:**
  - Move database parameters to a configuration file or environment variables.

4. **Integrate with Dependency Injection (Optional):**
  - Use a DI framework like Spring to manage bean lifecycles and dependencies.

---

**By completing the implementation and explanation of `DatabaseConnectionManager`, we have advanced our simple Java web service application. This demonstrates how the **Singleton Pattern** can be used to manage shared resources efficiently, promoting maintainability and consistency within the constraints of a limited number of classes.
