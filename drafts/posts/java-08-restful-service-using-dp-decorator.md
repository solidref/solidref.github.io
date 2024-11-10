**Implementation of `CompressionDecorator` (Decorator Pattern)**

---

**Purpose of `CompressionDecorator`:**

The `CompressionDecorator` class adds compression functionality to the output of existing serializers by applying the **Decorator Pattern**. This pattern allows behavior to be added to individual objects dynamically without affecting the behavior of other objects from the same class. In this context, `CompressionDecorator` wraps around a `Serializer` object and compresses its output, enhancing serialization without modifying the existing serializer implementations.

---

**Decorator Pattern Implementation:**

1. **Component Interface (`Serializer`):**

  - Defines the interface for objects that can have responsibilities added to them dynamically.
  - Contains the method `serialize(Object data)`.

2. **Concrete Components (`JSONSerializer`, `YAMLSerializer`, etc.):**

  - Implement the `Serializer` interface.
  - Provide the basic serialization functionality.

3. **Decorator Class (`SerializerDecorator`):**

  - Implements the `Serializer` interface.
  - Contains a reference to a `Serializer` object.
  - Delegates calls to the wrapped `Serializer` object.

4. **Concrete Decorator (`CompressionDecorator`):**

  - Extends `SerializerDecorator`.
  - Adds additional behavior (compression) to the `serialize` method.

---

**Implementation Details:**

**1. `Serializer` Interface:**

```java
public interface Serializer {
    String serialize(Object data);
}
```

- **Purpose:**
  - Declares the `serialize` method used by all serializers.
  - Acts as the base component interface in the Decorator Pattern.

**2. Concrete Components:**

- **`JSONSerializer` and `YAMLSerializer`:**
  - Implement the `Serializer` interface.
  - Provide specific serialization logic.

**3. Decorator Class (`SerializerDecorator`):**

```java
public abstract class SerializerDecorator implements Serializer {
    protected Serializer wrappedSerializer;

    public SerializerDecorator(Serializer serializer) {
        this.wrappedSerializer = serializer;
    }

    @Override
    public String serialize(Object data) {
        return wrappedSerializer.serialize(data);
    }
}
```

- **Purpose:**
  - Serves as the base decorator class.
  - Holds a reference to a `Serializer` object.
  - Delegates serialization to the wrapped serializer.

**4. Concrete Decorator (`CompressionDecorator`):**

```java
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.zip.GZIPOutputStream;

public class CompressionDecorator extends SerializerDecorator {

    public CompressionDecorator(Serializer serializer) {
        super(serializer);
    }

    @Override
    public String serialize(Object data) {
        // First, serialize the data using the wrapped serializer
        String serializedData = wrappedSerializer.serialize(data);

        // Compress the serialized data
        try {
            byte[] compressedData = compress(serializedData);
            // Encode the compressed data in Base64 for safe text transmission
            return Base64.getEncoder().encodeToString(compressedData);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Compression failed");
        }
    }

    private byte[] compress(String data) throws IOException {
        ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
        try (GZIPOutputStream gzipStream = new GZIPOutputStream(byteStream)) {
            gzipStream.write(data.getBytes("UTF-8"));
        }
        return byteStream.toByteArray();
    }
}
```

- **Purpose:**
  - Extends `SerializerDecorator` to add compression functionality.
  - Overrides the `serialize` method to compress the serialized data.
- **Implementation:**
  - Uses GZIP compression to compress the serialized data.
  - Encodes the compressed data using Base64 to ensure it's safe for text transmission.

---

**Explanation:**

**Decorator Pattern Components:**

1. **Component Interface (`Serializer`):**

  - The base interface that defines the serialization method.
  - Allows different serializers to be used interchangeably.

2. **Concrete Components:**

  - `JSONSerializer`, `YAMLSerializer`, etc., implement the `Serializer` interface.
  - Provide specific implementations for serializing data into different formats.

3. **Decorator (`SerializerDecorator`):**

  - Holds a reference to a `Serializer` object.
  - Implements the `Serializer` interface.
  - Delegates serialization calls to the wrapped serializer.

4. **Concrete Decorator (`CompressionDecorator`):**

  - Adds compression functionality to the output of the wrapped serializer.
  - Overrides the `serialize` method to include compression logic.

**How `CompressionDecorator` Works:**

1. **Serialization Delegation:**

  - Calls `serialize` on the wrapped serializer to get the serialized data.

2. **Data Compression:**

  - Compresses the serialized data using GZIP.
  - Uses `ByteArrayOutputStream` and `GZIPOutputStream` to perform compression.

3. **Encoding for Transmission:**

  - Encodes the compressed byte array into a Base64 string.
  - Base64 encoding ensures that the compressed data can be transmitted as text.

4. **Returning the Compressed Data:**

  - Returns the Base64-encoded compressed data as the result of the `serialize` method.

---

**Usage Example:**

**1. Without Compression:**

```java
Serializer jsonSerializer = new JSONSerializer();
String output = jsonSerializer.serialize(task);
System.out.println("Serialized Output: " + output);
```

- **Output:**
  - The plain JSON representation of the `Task` object.

**2. With Compression:**

```java
Serializer jsonSerializer = new JSONSerializer();
Serializer compressedSerializer = new CompressionDecorator(jsonSerializer);
String compressedOutput = compressedSerializer.serialize(task);
System.out.println("Compressed Output: " + compressedOutput);
```

- **Output:**
  - A Base64-encoded string representing the compressed JSON data.

**3. Decompressing the Data (On the Client Side):**

- **Client would:**
  - Decode the Base64 string.
  - Decompress the data using GZIP.
  - Parse the resulting JSON string.

---

**Integration with `TaskRequestHandler`:**

**Modifying `TaskRequestHandler` to Use `CompressionDecorator`:**

```java
public class TaskRequestHandler extends RequestHandler {
    private Serializer serializer;

    public TaskRequestHandler(DatabaseOperations dbAdapter) {
        super(dbAdapter);
    }

    @Override
    protected ResponseData processRequest(RequestData requestData) {
        // Determine the preferred response format
        String acceptHeader = requestData.getHeaders().getOrDefault("Accept", "application/json");
        boolean acceptCompression = requestData.getHeaders().getOrDefault("Accept-Encoding", "").contains("gzip");

        // Choose the appropriate serializer
        if (acceptHeader.contains("application/json")) {
            serializer = new JSONSerializer();
        } else if (acceptHeader.contains("application/x-yaml") || acceptHeader.contains("text/yaml")) {
            serializer = new YAMLSerializer();
        } else {
            // Default to JSON
            serializer = new JSONSerializer();
        }

        // Wrap the serializer with CompressionDecorator if compression is accepted
        if (acceptCompression) {
            serializer = new CompressionDecorator(serializer);
        }

        // Continue processing the request...
    }

    @Override
    protected String formatResponse(ResponseData responseData) {
        try {
            return serializer.serialize(responseData.getData());
        } catch (Exception e) {
            e.printStackTrace();
            // Return an error message or handle the exception appropriately
            return "{\"error\":\"Serialization failed\"}";
        }
    }

    private void sendResponse(HttpExchange exchange, String response, int statusCode) throws IOException {
        Headers headers = exchange.getResponseHeaders();
        String contentType = "application/json; charset=UTF-8";
        if (serializer instanceof YAMLSerializer) {
            contentType = "application/x-yaml; charset=UTF-8";
        }
        headers.add("Content-Type", contentType);

        if (serializer instanceof CompressionDecorator) {
            headers.add("Content-Encoding", "gzip");
        }

        exchange.sendResponseHeaders(statusCode, response.getBytes("UTF-8").length);
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes("UTF-8"));
        os.close();
    }
}
```

- **Explanation:**
  - Checks the `Accept-Encoding` header to see if the client accepts compressed responses.
  - If compression is accepted, wraps the chosen serializer with `CompressionDecorator`.
  - Adds the `Content-Encoding: gzip` header to the response if compression is applied.

---

**Advantages of Using the Decorator Pattern:**

1. **Flexible Extension of Functionality:**

  - Allows adding new responsibilities (compression) to objects dynamically.
  - Avoids subclassing, which can lead to an explosion of classes.

2. **Open/Closed Principle:**

  - Classes are open for extension but closed for modification.
  - Existing serializers do not need to be modified to add compression.

3. **Runtime Behavior Changes:**

  - Behaviors can be added or removed at runtime based on conditions (e.g., client accepts compression).

4. **Combining Multiple Decorators:**

  - Multiple decorators can be stacked to add various functionalities.

---

**Considerations:**

1. **Client Support:**

  - Ensure that clients can handle compressed responses.
  - Clients must decompress the data after receiving it.

2. **Performance Overhead:**

  - Compression and decompression add computational overhead.
  - Evaluate the trade-off between reduced data size and processing time.

3. **Error Handling:**

  - Handle compression exceptions appropriately.
  - Ensure that failures in compression do not crash the application.

4. **Security:**

  - Be cautious of compression-related vulnerabilities like CRIME or BREACH attacks in web applications.
  - Validate data and use secure configurations.

---

**Alternative Implementations:**

- **Other Decorators:**

  - Implement additional decorators for encryption, caching, or logging.

- **Decorator Chain:**

  - Combine multiple decorators to add several layers of functionality.

```java
Serializer serializer = new JSONSerializer();
serializer = new EncryptionDecorator(serializer);
serializer = new CompressionDecorator(serializer);
```

- **Parameterizing Decorators:**

  - Allow configuration of the compression level or algorithm.

---

**Example of Compression and Decompression:**

**Compression (Server Side):**

```java
Serializer serializer = new JSONSerializer();
Serializer compressedSerializer = new CompressionDecorator(serializer);
String compressedData = compressedSerializer.serialize(task);
```

**Decompression (Client Side):**

```java
// Decode Base64
byte[] compressedData = Base64.getDecoder().decode(compressedDataString);

// Decompress GZIP
ByteArrayInputStream byteStream = new ByteArrayInputStream(compressedData);
try (GZIPInputStream gzipStream = new GZIPInputStream(byteStream)) {
    InputStreamReader reader = new InputStreamReader(gzipStream, "UTF-8");
    BufferedReader in = new BufferedReader(reader);
    StringBuilder decompressedData = new StringBuilder();
    String line;
    while ((line = in.readLine()) != null) {
        decompressedData.append(line);
    }
    String jsonData = decompressedData.toString();
    // Parse JSON data as needed
} catch (IOException e) {
    e.printStackTrace();
}
```

---

**Conclusion:**

The `CompressionDecorator` class effectively implements the **Decorator Pattern** by adding compression functionality to serializers without modifying their existing code. By wrapping a `Serializer` object, it allows:

- **Dynamic Enhancement:**
  - Add compression at runtime based on client capabilities or configuration.

- **Separation of Concerns:**
  - Keep serialization logic separate from compression logic.

- **Maintainability:**
  - Avoid modifying existing serializer classes, adhering to the Open/Closed Principle.

This implementation enhances the flexibility and scalability of the application, allowing it to efficiently handle varying client requirements and optimize data transmission.

---

**Next Steps:**

1. **Testing:**

  - Write unit tests to ensure that `CompressionDecorator` compresses and decompresses data correctly.
  - Test with different serializers and data types.

2. **Integration:**

  - Ensure that clients can handle compressed responses.
  - Update API documentation to inform clients about compression support.

3. **Performance Evaluation:**

  - Benchmark the performance impact of compression.
  - Optimize compression settings if necessary.

4. **Security Review:**

  - Assess any potential security risks introduced by compression.
  - Implement necessary safeguards.

---

By implementing and explaining `CompressionDecorator`, we have further enhanced our simple Java web service application, demonstrating how the **Decorator Pattern** can be effectively utilized to add new functionalities dynamically while keeping the system modular and maintainable.
