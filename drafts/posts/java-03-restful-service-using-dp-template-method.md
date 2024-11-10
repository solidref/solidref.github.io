**Implementation of `RequestHandler` (Template Method Pattern)**

---

**RequestHandler.java**

```java
import java.io.IOException;
import java.io.OutputStream;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

public abstract class RequestHandler implements HttpHandler {
    // Template method
    @Override
    public final void handle(HttpExchange exchange) throws IOException {
        try {
            // Step 1: Parse the request
            RequestData requestData = parseRequest(exchange);

            // Step 2: Process the request
            ResponseData responseData = processRequest(requestData);

            // Step 3: Format the response
            String response = formatResponse(responseData);

            // Send the response
            sendResponse(exchange, response, responseData.getStatusCode());
        } catch (Exception e) {
            // Handle exceptions and send error response
            String errorResponse = "Internal Server Error";
            sendResponse(exchange, errorResponse, 500);
            e.printStackTrace();
        }
    }

    // Abstract methods to be implemented by subclasses
    protected abstract RequestData parseRequest(HttpExchange exchange) throws IOException;

    protected abstract ResponseData processRequest(RequestData requestData);

    protected abstract String formatResponse(ResponseData responseData);

    // Concrete method shared by all subclasses
    private void sendResponse(HttpExchange exchange, String response, int statusCode) throws IOException {
        exchange.getResponseHeaders().add("Content-Type", "application/json; charset=UTF-8");
        exchange.sendResponseHeaders(statusCode, response.getBytes("UTF-8").length);
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes("UTF-8"));
        os.close();
    }
}
```

---

**Explanation:**

**Purpose of `RequestHandler`:**

The `RequestHandler` class serves as an abstract base class for handling HTTP requests in the application. It implements the **Template Method** design pattern to define the skeleton of the request handling algorithm, allowing subclasses to provide specific implementations for certain steps.

---

**Template Method Pattern Implementation:**

1. **Final `handle` Method:**

   ```java
   @Override
   public final void handle(HttpExchange exchange) throws IOException {
       // ...
   }
   ```

  - The `handle` method is the **template method**.
  - Declared `final` to prevent subclasses from overriding it.
  - Defines the fixed sequence of steps for handling a request.

2. **Algorithm Steps:**

   The `handle` method orchestrates the following steps:

  - **Step 1: Parse the Request**

    ```java
    RequestData requestData = parseRequest(exchange);
    ```

    - Calls the `parseRequest` method to extract request details.
    - `parseRequest` is an **abstract method** that must be implemented by subclasses.

  - **Step 2: Process the Request**

    ```java
    ResponseData responseData = processRequest(requestData);
    ```

    - Calls the `processRequest` method to perform the main logic.
    - `processRequest` is an **abstract method** to be implemented by subclasses.

  - **Step 3: Format the Response**

    ```java
    String response = formatResponse(responseData);
    ```

    - Calls the `formatResponse` method to prepare the response.
    - `formatResponse` is an **abstract method** for subclasses to implement.

  - **Send the Response**

    ```java
    sendResponse(exchange, response, responseData.getStatusCode());
    ```

    - Calls the `sendResponse` method to send the HTTP response back to the client.
    - `sendResponse` is a **concrete method** provided in the base class.

3. **Abstract Methods:**

  - **`parseRequest`**

    ```java
    protected abstract RequestData parseRequest(HttpExchange exchange) throws IOException;
    ```

    - Responsible for parsing the incoming HTTP request.
    - Subclasses must provide the implementation.

  - **`processRequest`**

    ```java
    protected abstract ResponseData processRequest(RequestData requestData);
    ```

    - Contains the business logic for handling the request.
    - Subclasses implement this to define specific behaviors.

  - **`formatResponse`**

    ```java
    protected abstract String formatResponse(ResponseData responseData);
    ```

    - Formats the response data into a string (e.g., JSON).
    - Subclasses decide how to serialize the response.

4. **Concrete Method:**

  - **`sendResponse`**

    ```java
    private void sendResponse(HttpExchange exchange, String response, int statusCode) throws IOException {
        exchange.getResponseHeaders().add("Content-Type", "application/json; charset=UTF-8");
        exchange.sendResponseHeaders(statusCode, response.getBytes("UTF-8").length);
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes("UTF-8"));
        os.close();
    }
    ```

    - Handles sending the HTTP response back to the client.
    - Sets response headers, status code, and writes the response body.
    - Shared by all subclasses, promoting code reuse.

5. **Exception Handling:**

   ```java
   } catch (Exception e) {
       // Handle exceptions and send error response
       String errorResponse = "Internal Server Error";
       sendResponse(exchange, errorResponse, 500);
       e.printStackTrace();
   }
   ```

  - Catches any exceptions thrown during request handling.
  - Sends a 500 Internal Server Error response.
  - Prints the stack trace for debugging purposes.

---

**Supporting Classes (`RequestData` and `ResponseData`):**

For this implementation, we assume the existence of simple data classes to encapsulate request and response data.

**RequestData.java**

```java
public class RequestData {
    private String method;
    private String body;
    private Map<String, String> queryParams;

    // Getters and setters
    // Constructor(s)
}
```

**ResponseData.java**

```java
public class ResponseData {
    private int statusCode;
    private Object data;

    // Getters and setters
    // Constructor(s)
}
```

- **`RequestData`** holds information extracted from the incoming HTTP request.
- **`ResponseData`** holds information to be sent back in the HTTP response.

---

**Usage in Subclasses:**

Subclasses like `TaskRequestHandler` will extend `RequestHandler` and provide concrete implementations for the abstract methods.

**TaskRequestHandler.java**

```java
import java.io.IOException;
import java.util.Map;

import com.sun.net.httpserver.HttpExchange;

public class TaskRequestHandler extends RequestHandler {

    @Override
    protected RequestData parseRequest(HttpExchange exchange) throws IOException {
        // Implementation to parse the request
        // Extract method, body, query parameters, etc.
        RequestData requestData = new RequestData();
        requestData.setMethod(exchange.getRequestMethod());
        // Parse body and query params as needed
        return requestData;
    }

    @Override
    protected ResponseData processRequest(RequestData requestData) {
        // Business logic based on request data
        ResponseData responseData = new ResponseData();
        // Set status code and data
        return responseData;
    }

    @Override
    protected String formatResponse(ResponseData responseData) {
        // Convert responseData to JSON or other formats
        // For simplicity, let's return a JSON string
        return "{\"status\":\"success\"}";
    }
}
```

- **`parseRequest`**: Parses the HTTP method, request body, and query parameters.
- **`processRequest`**: Implements the logic for handling task operations (e.g., creating, updating tasks).
- **`formatResponse`**: Converts the response data into a JSON string.

---

**Why Template Method Pattern?**

- **Defines the Algorithm Structure**: The `handle` method outlines the steps required to process a request.
- **Enforces Consistent Workflow**: All subclasses follow the same processing sequence, ensuring consistency.
- **Promotes Code Reuse**: Common code like `sendResponse` is implemented once and used by all subclasses.
- **Allows Flexibility**: Subclasses can customize specific steps without altering the overall algorithm.

---

**Key Components:**

1. **Abstract Class (`RequestHandler`)**:

  - Contains the template method (`handle`) and abstract methods to be implemented by subclasses.

2. **Template Method (`handle`)**:

  - Orchestrates the algorithm's steps.
  - Declared `final` to prevent modification.

3. **Abstract Methods**:

  - **`parseRequest`**, **`processRequest`**, **`formatResponse`**.
  - Provide extension points for subclasses.

4. **Concrete Methods**:

  - **`sendResponse`**: Shared utility method for sending responses.

---

**Advantages of This Design:**

- **Separation of Concerns**: Each method handles a specific part of the request processing.
- **Ease of Maintenance**: Changes to the common workflow are made in one place.
- **Extensibility**: New request handlers can be added by extending `RequestHandler` and implementing the abstract methods.
- **Consistency**: Ensures all request handlers behave similarly, reducing potential errors.

---

**Example Scenario:**

Suppose a new request handler is needed for user authentication. You can create a new class `AuthRequestHandler` that extends `RequestHandler` and implements the abstract methods.

**AuthRequestHandler.java**

```java
public class AuthRequestHandler extends RequestHandler {

    @Override
    protected RequestData parseRequest(HttpExchange exchange) throws IOException {
        // Parse authentication request details
    }

    @Override
    protected ResponseData processRequest(RequestData requestData) {
        // Authenticate the user
    }

    @Override
    protected String formatResponse(ResponseData responseData) {
        // Format the authentication response
    }
}
```

- **Reuses the common workflow**: No need to re-implement the sequence of steps.
- **Focuses on specific logic**: Only implements the parts that are unique to authentication.

---

**Conclusion:**

The `RequestHandler` class effectively utilizes the **Template Method** design pattern to define a consistent algorithm for handling HTTP requests. By abstracting the common workflow and allowing subclasses to implement specific steps, the design promotes code reuse, maintainability, and flexibility.

This implementation aligns with the goal of keeping the application simple (within 20 classes) while applying key design patterns to enhance structure and scalability.

---

**Next Steps:**

- **Implement Subclasses**: Create concrete request handlers like `TaskRequestHandler` to handle specific endpoints.
- **Develop Supporting Classes**: Ensure `RequestData` and `ResponseData` are fully implemented to facilitate data exchange.
- **Integrate with Other Patterns**: As you develop further, integrate other design patterns as per the initial design plan (e.g., Command pattern in `processRequest`).

---

**Assumptions and Dependencies:**

- **HttpExchange**: Part of `com.sun.net.httpserver`, represents an HTTP request and response pair.
- **Exception Handling**: Simplified for this example; in a production environment, you'd have more robust error handling.
- **Content-Type**: Set to `application/json` for simplicity; can be adjusted based on response format.
- **Character Encoding**: Uses UTF-8 encoding for response data.

---

**Final Notes:**

- **Extensibility**: The design allows easy addition of new request handlers for different endpoints or services.
- **Testability**: Each method can be unit tested separately, improving code reliability.
- **Simplicity**: The implementation remains straightforward, adhering to the requirement of simplicity and minimal class count.

--------------------

**Implementation of `TaskRequestHandler` (Concrete Implementation of Template Method Pattern)**

---

**TaskRequestHandler.java**

```java
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import com.sun.net.httpserver.HttpExchange;

import org.json.JSONObject;

public class TaskRequestHandler extends RequestHandler {

    @Override
    protected RequestData parseRequest(HttpExchange exchange) throws IOException {
        // Extract HTTP method and URI
        String method = exchange.getRequestMethod();
        String uri = exchange.getRequestURI().toString();

        // Read request body
        InputStream is = exchange.getRequestBody();
        String body = new String(is.readAllBytes(), StandardCharsets.UTF_8);

        // Parse query parameters (assuming a utility class for parsing)
        Map<String, String> queryParams = QueryUtils.parseQuery(exchange.getRequestURI().getQuery());

        // Create and return a RequestData object
        return new RequestData(method, uri, body, queryParams);
    }

    @Override
    protected ResponseData processRequest(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        String method = requestData.getMethod();

        try {
            switch (method) {
                case "GET":
                    responseData = handleGet(requestData);
                    break;
                case "POST":
                    responseData = handlePost(requestData);
                    break;
                case "PUT":
                    responseData = handlePut(requestData);
                    break;
                case "DELETE":
                    responseData = handleDelete(requestData);
                    break;
                default:
                    responseData.setStatusCode(405);
                    responseData.setData("Method Not Allowed");
            }
        } catch (Exception e) {
            responseData.setStatusCode(500);
            responseData.setData("Internal Server Error");
            e.printStackTrace();
        }

        return responseData;
    }

    @Override
    protected String formatResponse(ResponseData responseData) {
        // Convert response data to JSON format
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("status", responseData.getStatusCode());
        jsonResponse.put("data", responseData.getData());
        return jsonResponse.toString();
    }

    // Helper methods for handling different HTTP methods

    private ResponseData handleGet(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // For simplicity, returning a static list of tasks
        String tasksJson = "[{\"id\":1,\"title\":\"Task 1\"},{\"id\":2,\"title\":\"Task 2\"}]";
        responseData.setStatusCode(200);
        responseData.setData(tasksJson);

        return responseData;
    }

    private ResponseData handlePost(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Parse the request body to create a new task
        JSONObject jsonBody = new JSONObject(requestData.getBody());
        String title = jsonBody.getString("title");
        String description = jsonBody.optString("description", "");

        // Use TaskBuilder to create a new Task
        TaskBuilder taskBuilder = new TaskBuilder();
        Task task = taskBuilder
                .setTitle(title)
                .setDescription(description)
                .build();

        // Save the task using DatabaseAdapter (simplified here)
        // DatabaseAdapter.getInstance().saveTask(task);

        // Return the created task
        responseData.setStatusCode(201);
        responseData.setData(task.toJson().toString());

        return responseData;
    }

    private ResponseData handlePut(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Extract task ID from URI
        String[] uriParts = requestData.getUri().split("/");
        int taskId = Integer.parseInt(uriParts[uriParts.length - 1]);

        // Parse the request body to update the task
        JSONObject jsonBody = new JSONObject(requestData.getBody());
        String title = jsonBody.optString("title", null);
        String description = jsonBody.optString("description", null);

        // Retrieve and update the task (simplified)
        // Task task = DatabaseAdapter.getInstance().getTask(taskId);
        Task task = new Task(); // Placeholder for the existing task
        task.setId(taskId);
        if (title != null) task.setTitle(title);
        if (description != null) task.setDescription(description);

        // Save the updated task
        // DatabaseAdapter.getInstance().updateTask(task);

        // Return the updated task
        responseData.setStatusCode(200);
        responseData.setData(task.toJson().toString());

        return responseData;
    }

    private ResponseData handleDelete(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Extract task ID from URI
        String[] uriParts = requestData.getUri().split("/");
        int taskId = Integer.parseInt(uriParts[uriParts.length - 1]);

        // Delete the task (simplified)
        // DatabaseAdapter.getInstance().deleteTask(taskId);

        // Return a success message
        responseData.setStatusCode(200);
        responseData.setData("Task deleted successfully");

        return responseData;
    }
}
```

---

**Explanation:**

**Purpose of `TaskRequestHandler`:**

`TaskRequestHandler` is a concrete subclass of the abstract `RequestHandler` class. It implements the abstract methods to handle HTTP requests related to tasks (e.g., creating, reading, updating, deleting tasks). This class applies the **Template Method** pattern by providing specific implementations of the steps defined in the `RequestHandler`'s template method.

---

**Implementation Details:**

1. **Extending `RequestHandler`:**

   ```java
   public class TaskRequestHandler extends RequestHandler {
       // ...
   }
   ```

  - Inherits the `handle()` method, which is the template method.
  - Provides concrete implementations for `parseRequest`, `processRequest`, and `formatResponse`.

2. **Implementing `parseRequest`:**

   ```java
   @Override
   protected RequestData parseRequest(HttpExchange exchange) throws IOException {
       // Extract HTTP method and URI
       String method = exchange.getRequestMethod();
       String uri = exchange.getRequestURI().toString();

       // Read request body
       InputStream is = exchange.getRequestBody();
       String body = new String(is.readAllBytes(), StandardCharsets.UTF_8);

       // Parse query parameters
       Map<String, String> queryParams = QueryUtils.parseQuery(exchange.getRequestURI().getQuery());

       // Return a new RequestData object
       return new RequestData(method, uri, body, queryParams);
   }
   ```

  - **Method and URI Extraction:**
    - Retrieves the HTTP method (e.g., GET, POST) and the requested URI.
  - **Reading Request Body:**
    - Reads the body of the request, which may contain JSON data.
    - Uses UTF-8 character encoding.
  - **Parsing Query Parameters:**
    - Utilizes a hypothetical `QueryUtils` class to parse query parameters into a `Map`.
  - **Creating `RequestData`:**
    - Encapsulates the extracted information into a `RequestData` object for further processing.

3. **Implementing `processRequest`:**

   ```java
   @Override
   protected ResponseData processRequest(RequestData requestData) {
       ResponseData responseData = new ResponseData();
       String method = requestData.getMethod();

       try {
           switch (method) {
               case "GET":
                   responseData = handleGet(requestData);
                   break;
               case "POST":
                   responseData = handlePost(requestData);
                   break;
               case "PUT":
                   responseData = handlePut(requestData);
                   break;
               case "DELETE":
                   responseData = handleDelete(requestData);
                   break;
               default:
                   responseData.setStatusCode(405);
                   responseData.setData("Method Not Allowed");
           }
       } catch (Exception e) {
           responseData.setStatusCode(500);
           responseData.setData("Internal Server Error");
           e.printStackTrace();
       }

       return responseData;
   }
   ```

  - **Switch Statement:**
    - Determines the appropriate action based on the HTTP method.
  - **Handling Each Method:**
    - Calls specific helper methods for GET, POST, PUT, DELETE.
  - **Error Handling:**
    - Catches exceptions and sets a 500 Internal Server Error response.
  - **Unsupported Methods:**
    - Returns a 405 Method Not Allowed for any other HTTP methods.

4. **Implementing `formatResponse`:**

   ```java
   @Override
   protected String formatResponse(ResponseData responseData) {
       // Convert response data to JSON format
       JSONObject jsonResponse = new JSONObject();
       jsonResponse.put("status", responseData.getStatusCode());
       jsonResponse.put("data", responseData.getData());
       return jsonResponse.toString();
   }
   ```

  - **JSON Formatting:**
    - Uses the `org.json` library to create a JSON object.
    - Includes the status code and data in the response.
  - **Returning the Response String:**
    - Converts the JSON object to a string for sending back to the client.

5. **Helper Methods for Each HTTP Method:**

  - **`handleGet`:**

    ```java
    private ResponseData handleGet(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Returning a static list of tasks for simplicity
        String tasksJson = "[{\"id\":1,\"title\":\"Task 1\"},{\"id\":2,\"title\":\"Task 2\"}]";
        responseData.setStatusCode(200);
        responseData.setData(tasksJson);

        return responseData;
    }
    ```

    - **Purpose:**
      - Retrieves tasks from the data source.
    - **Simplification:**
      - Returns a static JSON string representing a list of tasks.

  - **`handlePost`:**

    ```java
    private ResponseData handlePost(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Parse the request body to create a new task
        JSONObject jsonBody = new JSONObject(requestData.getBody());
        String title = jsonBody.getString("title");
        String description = jsonBody.optString("description", "");

        // Use TaskBuilder to create a new Task
        TaskBuilder taskBuilder = new TaskBuilder();
        Task task = taskBuilder
                .setTitle(title)
                .setDescription(description)
                .build();

        // Save the task (simplified)
        // DatabaseAdapter.getInstance().saveTask(task);

        // Return the created task
        responseData.setStatusCode(201);
        responseData.setData(task.toJson().toString());

        return responseData;
    }
    ```

    - **Parsing Request Body:**
      - Extracts `title` and `description` from the JSON body.
    - **Using TaskBuilder:**
      - Applies the **Builder Pattern** to create a `Task` object.
    - **Saving the Task:**
      - Saving to the database is simplified/omitted.
    - **Returning Response:**
      - Sets the status code to 201 (Created) and includes the new task data.

  - **`handlePut`:**

    ```java
    private ResponseData handlePut(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Extract task ID from URI
        String[] uriParts = requestData.getUri().split("/");
        int taskId = Integer.parseInt(uriParts[uriParts.length - 1]);

        // Parse the request body
        JSONObject jsonBody = new JSONObject(requestData.getBody());
        String title = jsonBody.optString("title", null);
        String description = jsonBody.optString("description", null);

        // Retrieve and update the task (simplified)
        // Task task = DatabaseAdapter.getInstance().getTask(taskId);
        Task task = new Task(); // Placeholder for the existing task
        task.setId(taskId);
        if (title != null) task.setTitle(title);
        if (description != null) task.setDescription(description);

        // Save the updated task
        // DatabaseAdapter.getInstance().updateTask(task);

        // Return the updated task
        responseData.setStatusCode(200);
        responseData.setData(task.toJson().toString());

        return responseData;
    }
    ```

    - **Extracting Task ID:**
      - Parses the task ID from the request URI.
    - **Updating the Task:**
      - Retrieves the existing task (simplified) and updates it with new data.
    - **Saving Changes:**
      - Saving is simplified/omitted.
    - **Returning Response:**
      - Includes the updated task data in the response.

  - **`handleDelete`:**

    ```java
    private ResponseData handleDelete(RequestData requestData) {
        ResponseData responseData = new ResponseData();

        // Extract task ID from URI
        String[] uriParts = requestData.getUri().split("/");
        int taskId = Integer.parseInt(uriParts[uriParts.length - 1]);

        // Delete the task (simplified)
        // DatabaseAdapter.getInstance().deleteTask(taskId);

        // Return a success message
        responseData.setStatusCode(200);
        responseData.setData("Task deleted successfully");

        return responseData;
    }
    ```

    - **Deleting the Task:**
      - Deletes the task with the specified ID (simplified).
    - **Returning Response:**
      - Provides a confirmation message.

---

**Integration with Other Design Patterns:**

- **Builder Pattern (`TaskBuilder`):**

  - Used in `handlePost` to construct a `Task` object.
  - Simplifies the creation of complex objects.

- **Singleton Pattern (`DatabaseAdapter`):**

  - Implied usage in database operations (commented out in code).
  - Ensures a single instance manages database interactions.

- **Strategy Pattern (Serializer):**

  - Could be applied in `formatResponse` to use different serialization strategies.
  - Here, JSON serialization is hardcoded for simplicity.

---

**Supporting Classes and Utilities:**

- **`RequestData` Class:**

  - Encapsulates request information.
  - Contains methods like `getMethod()`, `getUri()`, `getBody()`, and `getQueryParams()`.

- **`ResponseData` Class:**

  - Encapsulates response information.
  - Contains methods like `setStatusCode()`, `setData()`, and `getStatusCode()`, `getData()`.

- **`Task` Class:**

  - Represents a task entity.
  - Methods like `setId()`, `setTitle()`, `setDescription()`, `toJson()`.

- **`TaskBuilder` Class:**

  - Implements the **Builder Pattern**.
  - Methods for setting task properties and a `build()` method.

- **`QueryUtils` Class:**

  - Provides utility methods for parsing query parameters.

- **`org.json` Library:**

  - Used for JSON parsing and generation.

---

**Key Points:**

- **Template Method Pattern:**

  - `handle()` method from `RequestHandler` defines the algorithm structure.
  - `TaskRequestHandler` provides concrete implementations for abstract methods.

- **HTTP Method Handling:**

  - Supports standard CRUD operations via HTTP methods.
  - Ensures RESTful API design principles.

- **Error Handling:**

  - Basic error handling with status codes and messages.
  - Exceptions are caught and logged.

- **Response Formatting:**

  - Consistent JSON responses for client compatibility.

---

**Assumptions and Simplifications:**

- **Database Operations:**

  - Actual database interactions are omitted for simplicity.
  - Comments indicate where database code would be integrated.

- **Input Validation:**

  - Minimal validation; in a production environment, thorough validation is essential.

- **Thread Safety:**

  - Not explicitly handled; would need consideration in a real-world application.

---

**Conclusion:**

The `TaskRequestHandler` class effectively implements the abstract methods of the `RequestHandler` base class, applying the **Template Method** design pattern. It handles the parsing of HTTP requests, processing according to the HTTP method, and formatting responses consistently in JSON.

By integrating other design patterns like **Builder** and implying the use of **Singleton** and **Strategy**, the class contributes to a modular, maintainable codebase within the constraint of using around 20 classes.

---

**Next Steps:**

- **Implement Supporting Classes:**

  - Fully implement `Task`, `TaskBuilder`, `RequestData`, `ResponseData`, and `QueryUtils`.

- **Database Integration:**

  - Implement `DatabaseAdapter` and `DatabaseConnectionManager` for actual data persistence.

- **Enhance Functionality:**

  - Add comprehensive error handling and input validation.
  - Implement additional features like user authentication if needed.

- **Apply Additional Patterns:**

  - Consider using the **Command** pattern for actions like undo/redo.
  - Use the **Observer** pattern to notify components of task changes.

---

**Notes:**

- **Compliance with Requirements:**

  - The implementation is kept simple and within the specified class limit.
  - The explanation provides clarity on how the class fits into the overall design.

- **Educational Value:**

  - Demonstrates how to apply the **Template Method** pattern in a real-world scenario.
  - Shows integration with other patterns for a cohesive design.
