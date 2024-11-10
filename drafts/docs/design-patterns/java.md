---
title: 'Design Patterns in Java'
draft: false
bookHidden: true
languageExample: true
languageExampleTitle: Java
showLanguageFilter: true
---

# Design Patterns in Java

Java is often considered the foundational language for learning design patterns due to its strong object-oriented features, including encapsulation, inheritance, and polymorphism. With these features, Java is well-suited to implementing classic design patterns, making it ideal for building modular, scalable, and maintainable software. This article covers **Creational**, **Structural**, and **Behavioral** design patterns, each with Java-specific examples.

## Why Design Patterns Matter in Java

Design patterns are reusable solutions to common software design problems. They help developers structure code more effectively, enhancing flexibility, modularity, and scalability. In Java, design patterns are especially beneficial for building complex, enterprise-grade applications, where managing dependencies and ensuring maintainability are crucial.

## Creational Patterns

Creational patterns deal with object creation mechanisms, aiming to increase flexibility and reuse of existing code. In Java, creational patterns often use classes, interfaces, and abstract classes.


### Abstract Factory

The Abstract Factory pattern provides an interface for creating families of related objects. In Java, you can use abstract classes or interfaces to define the factory and the products.

```java
// Button and Checkbox are the Element interfaces handled by the Factory
interface Button {
    void render();
}

interface Checkbox {
    void render();
}

// Dark* and Ligh* are the implementations of the two interfaces

class DarkButton implements Button {
    public void render() {
        System.out.println("Rendering Dark Mode Button");
    }
}

class DarkCheckbox implements Checkbox {
    public void render() {
        System.out.println("Rendering Dark Mode Checkbox");
    }
}

class LightButton implements Button {
    public void render() {
        System.out.println("Rendering Light Mode Button");
    }
}

class LightCheckbox implements Checkbox {
    public void render() {
        System.out.println("Rendering Light Mode Checkbox");
    }
}

// Abstract factory interface
interface UIFactory {
    Button createButton();
    Checkbox createCheckbox();
}

// Concrete factory for Dark Mode components
class DarkUIFactory implements UIFactory {
    public Button createButton() {
        return new DarkButton();
    }

    public Checkbox createCheckbox() {
        return new DarkCheckbox();
    }
}

// Concrete factory for Light Mode components
class LightUIFactory implements UIFactory {
    public Button createButton() {
        return new LightButton();
    }

    public Checkbox createCheckbox() {
        return new LightCheckbox();
    }
}

public class AbstractFactoryExample {
    private static UIFactory getThemeFactory(String theme) {
        if ("dark".equalsIgnoreCase(theme)) {
            return new DarkUIFactory();
        } else if ("light".equalsIgnoreCase(theme)) {
            return new LightUIFactory();
        }
        throw new IllegalArgumentException("Unknown theme: " + theme);
    }

    public static void main(String[] args) {
        // Select the theme based on a configuration or user preference
        String theme = "dark"; // This can be dynamically chosen
        UIFactory factory = getThemeFactory(theme);

        // Create theme-specific components
        Button button = factory.createButton();
        Checkbox checkbox = factory.createCheckbox();

        // Render the components
        button.render(); // Output: Rendering Dark Mode Button
        checkbox.render(); // Output: Rendering Dark Mode Checkbox
    }
}
```

### Builder

The Builder pattern constructs complex objects step-by-step, allowing more control over the construction process. In Java, this is especially useful for creating immutable objects.

```java
public class Car {
    private String color;
    private String engine;

    private Car(Builder builder) {
        this.color = builder.color;
        this.engine = builder.engine;
    }

    public static class Builder {
        private String color;
        private String engine;

        public Builder setColor(String color) {
            this.color = color;
            return this;
        }

        public Builder setEngine(String engine) {
            this.engine = engine;
            return this;
        }

        public Car build() {
            return new Car(this);
        }
    }
}

// Usage
Car car = new Car.Builder().setColor("Red").setEngine("V8").build();
```

### Factory Method

The Factory Method pattern provides an interface for creating objects, allowing subclasses to alter the object type. In Java, this pattern uses a factory method to encapsulate object creation.

```java
abstract class Product {
    abstract void use();
}

class ConcreteProductA extends Product {
    @Override
    void use() {
        System.out.println("Using Product A");
    }
}

class ConcreteProductB extends Product {
    @Override
    void use() {
        System.out.println("Using Product B");
    }
}

class ProductFactory {
    public static Product createProduct(String type) {
        if (type.equals("A")) {
            return new ConcreteProductA();
        }
        if (type.equals("B")) {
            return new ConcreteProductB();
        }
        // Add more types as needed
        return null;
    }
}

// Usage
Product product = ProductFactory.createProduct("A");
product.use();
```

### Prototype

The Prototype pattern is used to create new objects by cloning existing instances. In Java, the `Cloneable` interface can be used to implement this pattern.

```java
public class Prototype implements Cloneable {
    private String data;

    public Prototype(String data) {
        this.data = data;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

// Usage
Prototype prototype1 = new Prototype("data");
Prototype prototype2 = (Prototype) prototype1.clone();
```

### Singleton

The Singleton pattern ensures a class has only one instance and provides a global point of access to it. In Java, the Singleton is commonly implemented with lazy instantiation and thread safety.

```java
import java.io.IOException;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpServer;

public class MainServer {
    // Static variable to hold the single instance of MainServer
    private static MainServer instance = null;

    // Private constructor to prevent instantiation from outside
    private MainServer() {
        // Initialize the server here
        startServer();
    }

    // Public method to provide access to the instance
    public static MainServer getInstance() {
        if (instance == null) {
            synchronized (MainServer.class) {
                if (instance == null) {
                    instance = new MainServer();
                }
            }
        }
        return instance;
    }

    // Method to start the HTTP server
    private void startServer() {
        System.out.println("Starting the HTTP server...");
        try {
            // Create an HTTP server listening on port 8000
            HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
            // Set up a context to handle "/tasks" requests
            server.createContext("/tasks", new TaskRequestHandler());
            // Use the default executor
            server.setExecutor(null);
            // Start the server
            server.start();
            System.out.println("Server started on port 8000");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## Structural Patterns

Structural patterns deal with object composition, helping to organize relationships between objects. In Java, structural patterns are often implemented through inheritance and interfaces.

### Adapter

The Adapter pattern allows incompatible interfaces to work together. In Java, this can be achieved by creating a wrapper class.

```java
// The unified interface for database interactions
interface Database {
    void connect();
    void insert(String data);
    void disconnect();
}

// The SQL database class implementing the unified interface directly
class SQLDatabase implements Database {
    @Override
    public void connect() {
        System.out.println("Connecting to SQL database...");
    }

    @Override
    public void insert(String data) {
        System.out.println("Inserting data into SQL database: " + data);
    }

    @Override
    public void disconnect() {
        System.out.println("Disconnecting from SQL database.");
    }
}

// The NoSQL database class with a different interface
class NoSQLDatabase {
    public void openConnection() {
        System.out.println("Opening connection to NoSQL database...");
    }

    public void saveDocument(String document) {
        System.out.println("Saving document to NoSQL database: " + document);
    }

    public void closeConnection() {
        System.out.println("Closing connection to NoSQL database.");
    }
}

// The Adapter class to make NoSQLDatabase compatible with the Database interface
class NoSQLDatabaseAdapter implements Database {
    private final NoSQLDatabase noSQLDatabase;

    public NoSQLDatabaseAdapter(NoSQLDatabase noSQLDatabase) {
        this.noSQLDatabase = noSQLDatabase;
    }

    @Override
    public void connect() {
        noSQLDatabase.openConnection(); // Adapting openConnection to connect
    }

    @Override
    public void insert(String data) {
        noSQLDatabase.saveDocument(data); // Adapting saveDocument to insert
    }

    @Override
    public void disconnect() {
        noSQLDatabase.closeConnection(); // Adapting closeConnection to disconnect
    }
}

// Usage
public class DatabaseClient {
    public static void main(String[] args) {
        // Using SQLDatabase directly with the Database interface
        Database sqlDatabase = new SQLDatabase();
        sqlDatabase.connect();
        sqlDatabase.insert("SQL Record");
        sqlDatabase.disconnect();

        System.out.println();

        // Using NoSQLDatabase through the NoSQLDatabaseAdapter
        Database noSQLDatabase = new NoSQLDatabaseAdapter(new NoSQLDatabase());
        noSQLDatabase.connect();
        noSQLDatabase.insert("NoSQL Document");
        noSQLDatabase.disconnect();
    }
}
```

### Bridge

The Bridge pattern is a structural design pattern that separates an abstraction from its implementation, allowing them to evolve independently. It’s typically used when:

You have multiple abstractions and implementations that need to work together. You want to decouple code that is expected to vary or be extended separately.

In the Bridge pattern, the abstraction holds a reference to the implementation, and instead of inheriting from a concrete class, the abstraction and implementation are connected by composition.

Let’s consider a shape rendering system that can render various shapes (e.g., circles, rectangles) using different rendering engines (e.g., a vector renderer and a raster renderer). By using the Bridge pattern, we can separate the Shape abstraction from the Renderer implementation, allowing them to vary independently.

```java
// The Renderer interface defines the basic method for rendering shapes. Each specific 
// rendering technique (e.g., raster or vector) will implement this interface.

interface Renderer {
    void renderCircle(float radius);
    void renderRectangle(float width, float height);
}

// Each concrete renderer class (e.g., VectorRenderer and RasterRenderer) implements 
// the Renderer interface, providing its own implementation for rendering shapes.

class VectorRenderer implements Renderer {
    @Override
    public void renderCircle(float radius) {
        System.out.println("Rendering circle as vector with radius: " + radius);
    }

    @Override
    public void renderRectangle(float width, float height) {
        System.out.println("Rendering rectangle as vector with width: " + width + ", height: " + height);
    }
}

class RasterRenderer implements Renderer {
    @Override
    public void renderCircle(float radius) {
        System.out.println("Rendering circle as pixels with radius: " + radius);
    }

    @Override
    public void renderRectangle(float width, float height) {
        System.out.println("Rendering rectangle as pixels with width: " + width + ", height: " + height);
    }
}

// The Shape abstract class holds a reference to a Renderer object. It’s responsible 
// for defining the interface for the shapes, while the concrete shapes (e.g., 
// Circle and Rectangle) implement specific shapes.

abstract class Shape {
    protected Renderer renderer;

    protected Shape(Renderer renderer) {
        this.renderer = renderer;
    }

    public abstract void draw();
}

// Each shape (e.g., Circle and Rectangle) extends the Shape class and uses the 
// Renderer instance to perform the rendering. This allows each shape to be 
// drawn using any renderer that implements the Renderer interface.

class Circle extends Shape {
    private float radius;

    public Circle(Renderer renderer, float radius) {
        super(renderer);
        this.radius = radius;
    }

    @Override
    public void draw() {
        renderer.renderCircle(radius);
    }
}

class Rectangle extends Shape {
    private float width;
    private float height;

    public Rectangle(Renderer renderer, float width, float height) {
        super(renderer);
        this.width = width;
        this.height = height;
    }

    @Override
    public void draw() {
        renderer.renderRectangle(width, height);
    }
}

// In the client code, we create different Shape objects (e.g., Circle and Rectangle) 
// and use different Renderer implementations (e.g., VectorRenderer and RasterRenderer). 
// The shapes are drawn with their respective renderers, demonstrating how the Bridge 
// pattern allows flexibility in choosing different rendering styles for different shapes.

public class BridgePatternExample {
    public static void main(String[] args) {
        Renderer vectorRenderer = new VectorRenderer();
        Renderer rasterRenderer = new RasterRenderer();

        // Create shapes with vector rendering
        Shape vectorCircle = new Circle(vectorRenderer, 5);
        Shape vectorRectangle = new Rectangle(vectorRenderer, 4, 7);

        // Draw shapes with vector renderer
        vectorCircle.draw();        // Output: Rendering circle as vector with radius: 5
        vectorRectangle.draw();     // Output: Rendering rectangle as vector with width: 4, height: 7

        System.out.println();

        // Create shapes with raster rendering
        Shape rasterCircle = new Circle(rasterRenderer, 8);
        Shape rasterRectangle = new Rectangle(rasterRenderer, 3, 6);

        // Draw shapes with raster renderer
        rasterCircle.draw();        // Output: Rendering circle as pixels with radius: 8
        rasterRectangle.draw();     // Output: Rendering rectangle as pixels with width: 3, height: 6
    }
}
```

### Composite

The Composite pattern allows you to build a hierarchy of objects, treating individual objects and compositions uniformly. This is often used to represent tree structures.

```java
interface Component {
    void display();
}

class Leaf implements Component {
    public void display() {
        System.out.println("Leaf");
    }
}

class Composite implements Component {
    private List<Component> children = new ArrayList<>();

    public void add(Component component) {
        children.add(component);
    }

    public void display() {
        for (Component child : children) {
            child.display();
        }
    }
}

// Usage
Composite composite = new Composite();
composite.add(new Leaf());
composite.display();
```

### Decorator

The Decorator pattern adds responsibilities to an object dynamically. Java’s interface-based design allows for flexible decorator implementations.

```java
interface Notifier {
    void send(String message);
}

class EmailNotifier implements Notifier {
    public void send(String message) {
        System.out.println("Sending Email: " + message);
    }
}

class SMSNotifierDecorator implements Notifier {
    private Notifier notifier;

    public SMSNotifierDecorator(Notifier notifier) {
        this.notifier = notifier;
    }

    public void send(String message) {
        notifier.send(message);
        System.out.println("Sending SMS: " + message);
    }
}

// Usage
Notifier notifier = new SMSNotifierDecorator(new EmailNotifier());
notifier.send("Hello World");
```

### Facade

The Facade pattern is a structural design pattern that provides a simplified interface to a complex subsystem. Instead of interacting with multiple classes directly, clients can use a single facade class that abstracts the complexities, making it easier to use the subsystem.

Imagine an application that handles multiple aspects of a home theater system, such as turning on the projector, adjusting sound settings, dimming lights, and playing a movie. Each of these components might have its own configuration, and managing them can be complex. Using a Facade class, we can create a simplified interface to control the entire home theater system with a single method.

```java
// Each subsystem component (Projector, SoundSystem, Lights, StreamingService) has 
// its own methods for configuring and operating.

// Projector subsystem
class Projector {
    public void turnOn() {
        System.out.println("Projector is turned on.");
    }

    public void setInput(String input) {
        System.out.println("Projector input set to " + input);
    }

    public void turnOff() {
        System.out.println("Projector is turned off.");
    }
}

// Sound System subsystem
class SoundSystem {
    public void turnOn() {
        System.out.println("Sound system is turned on.");
    }

    public void setVolume(int level) {
        System.out.println("Sound volume set to " + level);
    }

    public void turnOff() {
        System.out.println("Sound system is turned off.");
    }
}

// Lights subsystem
class Lights {
    public void dim(int level) {
        System.out.println("Lights dimmed to " + level + "%");
    }

    public void turnOn() {
        System.out.println("Lights are turned on.");
    }
}

// Streaming Service subsystem
class StreamingService {
    public void playMovie(String movie) {
        System.out.println("Playing movie: " + movie);
    }

    public void stopMovie() {
        System.out.println("Stopping movie.");
    }
}

// The HomeTheaterFacade class provides a high-level interface to control the 
// home theater. It interacts with all subsystem components, hiding their 
// complexities from the client.

class HomeTheaterFacade {
    private Projector projector;
    private SoundSystem soundSystem;
    private Lights lights;
    private StreamingService streamingService;

    public HomeTheaterFacade(Projector projector, SoundSystem soundSystem, Lights lights, StreamingService streamingService) {
        this.projector = projector;
        this.soundSystem = soundSystem;
        this.lights = lights;
        this.streamingService = streamingService;
    }

    // Method to start the home theater system
    public void watchMovie(String movie) {
        System.out.println("Get ready to watch a movie...");
        lights.dim(10);
        projector.turnOn();
        projector.setInput("HDMI");
        soundSystem.turnOn();
        soundSystem.setVolume(10);
        streamingService.playMovie(movie);
    }

    // Method to stop the home theater system
    public void endMovie() {
        System.out.println("Shutting down the home theater...");
        streamingService.stopMovie();
        projector.turnOff();
        soundSystem.turnOff();
        lights.turnOn();
    }
}

// The client code only needs to interact with the HomeTheaterFacade class to 
// control the entire home theater system, greatly simplifying the process.

public class FacadePatternExample {
    public static void main(String[] args) {
        // Create subsystem components
        Projector projector = new Projector();
        SoundSystem soundSystem = new SoundSystem();
        Lights lights = new Lights();
        StreamingService streamingService = new StreamingService();

        // Create the facade
        HomeTheaterFacade homeTheater = new HomeTheaterFacade(projector, soundSystem, lights, streamingService);

        // Use the facade to watch a movie
        homeTheater.watchMovie("Inception");

        System.out.println();

        // Use the facade to end the movie
        homeTheater.endMovie();
    }
}

```

### Flyweight


Yes, the Flyweight Design Pattern is very much applicable to Java! The Flyweight pattern is especially useful in Java when dealing with large numbers of similar objects, as it helps reduce memory consumption by sharing objects. This pattern is commonly used in Java for applications where managing a high volume of objects can become a memory-intensive process, such as graphical applications, text editors, or any system that requires managing a large number of similar elements.

What is the Flyweight Pattern?
The Flyweight pattern is a structural design pattern that reduces memory usage by sharing as much data as possible between similar objects. Instead of creating a new object every time, the Flyweight pattern reuses existing instances of objects with similar states, saving memory and improving performance.

Consider a text editor where each character on the screen is represented as an object. If we have a large document, the memory usage can become significant because each character might have the same styling (e.g., font and size). Using the Flyweight pattern, we can share the common data (intrinsic state) between characters and only store the unique data (extrinsic state) separately.

```java
// The Character class represents a character in the editor with shared properties 
// (intrinsic state) such as font and size, and unique properties (extrinsic state) 
// such as position.

class Character {
    private final char symbol; // Intrinsic state
    private final String font; // Intrinsic state

    public Character(char symbol, String font) {
        this.symbol = symbol;
        this.font = font;
    }

    public void display(int size, int positionX, int positionY) {
        System.out.println("Displaying character '" + symbol + "' in font: " + font +
                ", size: " + size + " at position (" + positionX + ", " + positionY + ")");
    }
}

// The CharacterFactory class is responsible for managing and reusing Character 
// instances. It creates a new Character only if an instance with the given 
// symbol and font doesn’t already exist.

class CharacterFactory {
    private final Map<String, Character> characters = new HashMap<>();

    public Character getCharacter(char symbol, String font) {
        String key = symbol + "_" + font;
        Character character = characters.get(key);
        if (character == null) {
            character = new Character(symbol, font);
            characters.put(key, character);
            System.out.println("Creating new Character: " + symbol + " with font: " + font);
        }
        return character;
    }
}

// The TextEditor class simulates rendering a document by creating and 
// displaying multiple characters. The CharacterFactory is used to reuse 
// instances of characters with the same font and symbol.

public class TextEditor {
    public static void main(String[] args) {
        CharacterFactory factory = new CharacterFactory();

        // Using the Flyweight pattern to create characters
        Character c1 = factory.getCharacter('A', "Arial");
        c1.display(12, 10, 20);

        Character c2 = factory.getCharacter('B', "Arial");
        c2.display(12, 15, 20);

        Character c3 = factory.getCharacter('A', "Arial");
        c3.display(12, 20, 20);

        Character c4 = factory.getCharacter('A', "Times New Roman");
        c4.display(14, 25, 20);
    }
}
```

### Proxy

The Proxy pattern provides a placeholder for another object, controlling access. Java uses this pattern for lazy loading and security.

```java
interface Image {
    void display();
}

class RealImage implements Image {
    private String filename;

    public RealImage(String filename) {
        this.filename = filename;
        loadFromDisk();
    }

    private void loadFromDisk() {
        System.out.println("Loading " + filename);
    }

    public void display() {
        System.out.println("Displaying " + filename);
    }
}

class ProxyImage implements Image {
    private RealImage realImage;
    private String filename;

    public ProxyImage(String filename) {
        this.filename = filename;
    }

    public void display() {
        if (realImage == null) {
            realImage = new RealImage(filename);
        }
        realImage.display();
    }
}

// Usage
Image image = new ProxyImage("photo.jpg");
image.display();
```

## Behavioral Patterns

Behavioral patterns focus on communication between objects, defining how they interact.

### Chain of Responsability ???

### Command

The Command pattern encapsulates a request as an object. In Java, this pattern is often used to queue requests or provide undo functionality.

```java
interface Command {
    void execute();
}

class LightOnCommand implements Command {
    public void execute() {
        System.out.println("Light is on");
    }
}

class RemoteControl {
    private Command command;

    public void setCommand(Command command) {
        this.command = command;
    }

    public void pressButton() {
        command.execute();
    }
}

// Usage
RemoteControl remote = new RemoteControl();
Command lightOn = new LightOnCommand();
remote.setCommand(lightOn);
remote.pressButton();
```

```java
import java.util.ArrayList;
import java.util.List;

// Command Interface
interface Task {
    void execute();
}

// Concrete Command to Send an Email
class EmailTask implements Task {
    private String recipient;
    private String message;

    public EmailTask(String recipient, String message) {
        this.recipient = recipient;
        this.message = message;
    }

    @Override
    public void execute() {
        System.out.println("Sending email to " + recipient + ": " + message);
    }
}

// Concrete Command to Backup Files
class BackupTask implements Task {
    private String directory;

    public BackupTask(String directory) {
        this.directory = directory;
    }

    @Override
    public void execute() {
        System.out.println("Backing up files in directory: " + directory);
    }
}

// Concrete Command to Process Data
class DataProcessingTask implements Task {
    private String data;

    public DataProcessingTask(String data) {
        this.data = data;
    }

    @Override
    public void execute() {
        System.out.println("Processing data: " + data);
    }
}

// Invoker Class - The Task Scheduler
class TaskScheduler {
    private List<Task> taskQueue = new ArrayList<>();

    public void scheduleTask(Task task) {
        taskQueue.add(task);
        System.out.println("Task scheduled: " + task.getClass().getSimpleName());
    }

    public void executeAllTasks() {
        System.out.println("\nExecuting all scheduled tasks...");
        for (Task task : taskQueue) {
            task.execute();
        }
        taskQueue.clear();
    }
}

// Usage Example
public class CommandPatternExample {
    public static void main(String[] args) {
        TaskScheduler scheduler = new TaskScheduler();

        // Creating and scheduling different tasks
        Task emailTask = new EmailTask("user@example.com", "Hello, this is a test email!");
        Task backupTask = new BackupTask("/home/user/documents");
        Task dataProcessingTask = new DataProcessingTask("User data for processing");

        scheduler.scheduleTask(emailTask);
        scheduler.scheduleTask(backupTask);
        scheduler.scheduleTask(dataProcessingTask);

        // Executing all scheduled tasks
        scheduler.executeAllTasks();
    }
}
```

### Observer

The Observer pattern defines a one-to-many dependency, where objects are notified of state changes. Java’s event listeners are based on this pattern.

```java
interface Observer {
    void update(String message);
}

class ConcreteObserver implements Observer {
    public void update(String message) {
        System.out.println("Received message: " + message);
    }
}

class Subject {
    private List<Observer> observers = new ArrayList<>();

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void notifyObservers(String message) {
        for (Observer observer : observers) {
            observer.update(message);
        }
    }
}

// Usage
Subject subject = new Subject();
Observer observer = new ConcreteObserver();
subject.addObserver(observer);
subject.notifyObservers("Hello Observers");
```

```java
import java.util.ArrayList;
import java.util.List;

// Observer interface
interface Subscriber {
    void update(String news);
}

// Concrete Observer representing a person who subscribes to the news
class Person implements Subscriber {
    private String name;

    public Person(String name) {
        this.name = name;
    }

    @Override
    public void update(String news) {
        System.out.println(name + " received news update: " + news);
    }
}

// Concrete Observer representing an organization that subscribes to the news
class Organization implements Subscriber {
    private String orgName;

    public Organization(String orgName) {
        this.orgName = orgName;
    }

    @Override
    public void update(String news) {
        System.out.println(orgName + " received news update: " + news);
    }
}

// Subject class representing the news agency
class NewsAgency {
    private List<Subscriber> subscribers = new ArrayList<>();

    public void addSubscriber(Subscriber subscriber) {
        subscribers.add(subscriber);
    }

    public void removeSubscriber(Subscriber subscriber) {
        subscribers.remove(subscriber);
    }

    public void notifySubscribers(String news) {
        for (Subscriber subscriber : subscribers) {
            subscriber.update(news);
        }
    }
    
    public void publishNews(String news) {
        System.out.println("NewsAgency publishing news: " + news);
        notifySubscribers(news);
    }
}

// Usage example
public class ObserverPatternExample {
    public static void main(String[] args) {
        // Create a news agency
        NewsAgency newsAgency = new NewsAgency();

        // Create some subscribers
        Subscriber person1 = new Person("Alice");
        Subscriber person2 = new Person("Bob");
        Subscriber org = new Organization("Tech News Corp");

        // Add subscribers to the news agency
        newsAgency.addSubscriber(person1);
        newsAgency.addSubscriber(person2);
        newsAgency.addSubscriber(org);

        // Publish news and notify all subscribers
        newsAgency.publishNews("Breaking News: Java 20 Released!");
        newsAgency.publishNews("Weather Update: Heavy rain expected tomorrow.");
    }
}
```

### Iterator

### Mediator

### Memento

### Observer

### State

### Strategy

The Strategy pattern allows interchangeable algorithms to be selected at runtime. In Java, this is typically implemented with interfaces and different classes.

```java
interface Strategy {
    int execute(int a, int b);
}

class AdditionStrategy implements Strategy {
    public int execute(int a, int b) {
        return a + b;
    }
}

class Context {
    private Strategy strategy;

    public Context(Strategy strategy) {
        this.strategy = strategy;
    }

    public int executeStrategy(int a, int b) {
        return strategy.execute(a, b);
    }
}

// Usage
Context context = new Context(new AdditionStrategy());
System.out.println(context.executeStrategy(3, 5));
```

```java
// Define the Strategy interface
interface PaymentStrategy {
    void pay(int amount);
}

// Concrete Strategy for Credit Card payment
class CreditCardStrategy implements PaymentStrategy {
    private String cardNumber;
    private String cardHolder;

    public CreditCardStrategy(String cardNumber, String cardHolder) {
        this.cardNumber = cardNumber;
        this.cardHolder = cardHolder;
    }

    @Override
    public void pay(int amount) {
        System.out.println("Paid " + amount + " using Credit Card: " + cardHolder);
    }
}

// Concrete Strategy for PayPal payment
class PayPalStrategy implements PaymentStrategy {
    private String email;

    public PayPalStrategy(String email) {
        this.email = email;
    }

    @Override
    public void pay(int amount) {
        System.out.println("Paid " + amount + " using PayPal: " + email);
    }
}

// Concrete Strategy for Google Pay payment
class GooglePayStrategy implements PaymentStrategy {
    private String phoneNumber;

    public GooglePayStrategy(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public void pay(int amount) {
        System.out.println("Paid " + amount + " using Google Pay: " + phoneNumber);
    }
}

// Context class that uses a PaymentStrategy to process payment
class ShoppingCart {
    private PaymentStrategy paymentStrategy;

    public ShoppingCart(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }

    public void setPaymentStrategy(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }

    public void checkout(int amount) {
        paymentStrategy.pay(amount);
    }
}

// Usage example
public class StrategyPatternExample {
    public static void main(String[] args) {
        ShoppingCart cart = new ShoppingCart(new CreditCardStrategy("1234-5678-9012-3456", "John Doe"));
        cart.checkout(100);  // Paid 100 using Credit Card: John Doe

        // Switch payment method to PayPal
        cart.setPaymentStrategy(new PayPalStrategy("john.doe@example.com"));
        cart.checkout(200);  // Paid 200 using PayPal: john.doe@example.com

        // Switch payment method to Google Pay
        cart.setPaymentStrategy(new GooglePayStrategy("555-1234"));
        cart.checkout(150);  // Paid 150 using Google Pay: 555-1234
    }
}
```

### Template Method

### Visitor

## External References

- [Java Design Patterns and Practices](https://refactoring.guru/design-patterns/java)
- [Head First Design Patterns (Book)](https://www.oreilly.com/library/view/head-first-design/0596007124/)
- [Effective Java by Joshua Bloch](https://www.oreilly.com/library/view/effective-java-3rd/9780134686097/)

## Conclusion

Java's object-oriented structure makes it an ideal language for implementing classic design patterns. From Singleton and Factory to Observer and Strategy, Java provides the tools and constructs necessary for effective pattern implementation. Understanding these patterns is crucial for writing maintainable, scalable, and robust Java applications, especially in enterprise-grade software.
