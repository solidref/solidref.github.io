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

### Singleton

The Singleton pattern ensures a class has only one instance and provides a global point of access to it. In Java, the Singleton is commonly implemented with lazy instantiation and thread safety.

```java
public class Singleton {
    private static Singleton instance;

    private Singleton() { }

    public static synchronized Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}
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

## External References

- [Java Design Patterns and Practices](https://refactoring.guru/design-patterns/java)
- [Head First Design Patterns (Book)](https://www.oreilly.com/library/view/head-first-design/0596007124/)
- [Effective Java by Joshua Bloch](https://www.oreilly.com/library/view/effective-java-3rd/9780134686097/)

## Conclusion

Java's object-oriented structure makes it an ideal language for implementing classic design patterns. From Singleton and Factory to Observer and Strategy, Java provides the tools and constructs necessary for effective pattern implementation. Understanding these patterns is crucial for writing maintainable, scalable, and robust Java applications, especially in enterprise-grade software.
