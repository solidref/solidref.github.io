---
title: 'Design Patterns in JavaScript'
draft: false
bookHidden: true
languageExample: true
languageExampleTitle: JavaScript
showLanguageFilter: true
---

# Design Patterns in JavaScript

JavaScript's versatility and support for both object-oriented and functional programming make it suitable for implementing a wide range of design patterns. 

With ES6+ features like classes, modules, and `Proxy`, many traditional design patterns can be applied to JavaScript effectively. This article provides examples of **Creational**, **Structural**, and **Behavioral** design patterns, each tailored for JavaScript.

## Why Design Patterns Matter in JavaScript

Design patterns are reusable solutions to common software design problems. They help organize code, making it more modular, maintainable, and scalable. In JavaScript, patterns like Singleton, Observer, and Module are particularly useful for managing complexity, especially in asynchronous and event-driven applications.

## Creational Patterns

Creational patterns deal with object creation, making it more flexible and decoupled from the client.

### Abstract Factory

The Abstract Factory pattern provides an interface for creating families of related objects. In JavaScript, factories can return objects configured with different properties or methods.

```javascript
// using ES5 features (similar with Factory Method)
function createUIFactory(theme) {
    return theme === "dark"
        ? { background: "black", textColor: "white" }
        : { background: "white", textColor: "black" };
}
```
Although JavaScript does not have the `interface` and `abstract` concepts, we can still try and implement a solution.

```javascript
// Button and Checkbox become classed with unimplemented (throwing error) methods
class Button {
  render() {
    throw new Error("Method 'render()' must be implemented.");
  }
}

class Checkbox {
  render() {
    throw new Error("Method 'render()' must be implemented.");
  }
}


// Dark* and Ligh* classes with extend Button and Checkbox implementing/overriding their methods to have relevant actions

class DarkButton extends Button {
  render() {
    console.log("Rendering Dark Mode Button");
  }
}

class DarkCheckbox extends Checkbox {
  render() {
    console.log("Rendering Dark Mode Checkbox");
  }
}

class LightButton extends Button {
  render() {
    console.log("Rendering Light Mode Button");
  }
}

class LightCheckbox extends Checkbox {
  render() {
    console.log("Rendering Light Mode Checkbox");
  }
}

// Similar with Button and Checkbox, UIFactory becomes a class with unimplemented (throwing error) methods
class UIFactory {
  createButton() {
    throw new Error("Method 'createButton()' must be implemented.");
  }

  createCheckbox() {
    throw new Error("Method 'createCheckbox()' must be implemented.");
  }
}


// Concrete factory for Dark Mode components
class DarkUIFactory extends UIFactory {
    public Button createButton() {
        return new DarkButton();
    }

    public Checkbox createCheckbox() {
        return new DarkCheckbox();
    }
}

// Concrete factory for Light Mode components
class LightUIFactory extends UIFactory {
    public Button createButton() {
        return new LightButton();
    }

    public Checkbox createCheckbox() {
        return new LightCheckbox();
    }
}

// Function to choose the appropriate factory based on theme
function getThemeFactory(theme) {
  if (theme === "dark") {
    return new DarkUIFactory();
  } else if (theme === "light") {
    return new LightUIFactory();
  } else {
    throw new Error("Unknown theme: " + theme);
  }
}

// Usage example
const theme = "dark"; // This could be dynamically chosen
const factory = getThemeFactory(theme);

const button = factory.createButton();
const checkbox = factory.createCheckbox();

button.render();      // Output: Rendering Dark Mode Button
checkbox.render();    // Output: Rendering Dark Mode Checkbox
```

### Builder

The Builder pattern constructs complex objects step-by-step. JavaScript’s chaining methods and object literals make it well-suited for this pattern.

```javascript
// using ES5 capabilities
function carBuilder() {
    var _color = "Default Color"; // Default value
    var _engine = "Default Engine"; // Default value

    return {
        setColor: function(color) {
            _color = color;
            return this; // Enable chaining
        },
        setEngine: function(engine) {
            _engine = engine;
            return this; // Enable chaining
        },
        build: function() {
            // Return a new Car object with the current settings
            return {
                color: _color,
                engine: _engine
            };
        }
    };
}

// Usage
var car = carBuilder()
    .setColor("Red")
    .setEngine("V8")
    .build();
```

```javascript
// using ES6+ capabilities
class Car {
  constructor(builder) {
    this.color = builder.color;
    this.engine = builder.engine;
  }

  // Nested Builder Class
  static get Builder() {
    return class {
      constructor() {
        // Optional default values
        this.color = "";
        this.engine = "";
      }

      setColor(color) {
        this.color = color;
        return this; // Enable chaining
      }

      setEngine(engine) {
        this.engine = engine;
        return this; // Enable chaining
      }

      build() {
        return new Car(this);
      }
    };
  }
}

// Usage
const car = new Car.Builder()
  .setColor("Red")
  .setEngine("V8")
  .build();
```

### Factory Method

The Factory Method pattern provides a way to create objects without specifying the exact class. JavaScript commonly uses factory functions to produce instances.

```javascript
function createUser(type) {
    if (type === "admin") {
        return { role: "admin", permissions: ["read", "write", "delete"] };
    } else if (type === "guest") {
        return { role: "guest", permissions: ["read"] };
    }
}
```

```javascript
class Product {
  use() { throw new Error("Method 'use()' must be implemented."); }
}

class ConcreteProductA extends Product {
  use() {
    console.log("Using Product A");
  }
}

class ConcreteProductB extends Product {
  use() {
    console.log("Using Product B");
  }
}

const createProduct = (type) => {
  switch (type ) {
    case "A":
      return new ConcreteProductA();
    case "B":
      return new ConcreteProductB();
    // Add more types as needed
    default:
      return null;
  }
}

// Usage
const product = createProduct("A");
product.use();
```

### Prototype

The Prototype pattern creates objects based on a prototype object, ideal for cloning objects. JavaScript's `Object.create()` method supports this pattern natively.

```javascript
const vehicle = {
    type: "vehicle",
    start() {
        console.log("Starting the vehicle...");
    }
};

const car = Object.create(vehicle);
car.wheels = 4;
```

### Singleton

The Singleton pattern ensures a class has only one instance and provides a global point of access. JavaScript's closures or modules are commonly used to implement this pattern.

```javascript
// using ES5 features
const Singleton = (function () {
    let instance;

    function createInstance() {
        return { message: "This is the single instance" };
    }

    return {
        getInstance() {
            if (!instance) {
                instance = createInstance();
            }
            return instance;
        }
    };
})();
```

```javascript
// using ES6 features
class Singleton {
  constructor() {
    if (Singleton.instance) {
      return Singleton.instance;
    }
    this.message = "This is the single instance";
    Singleton.instance = this;
  }

  // getInstance method is redundant already hence the constructor does the same thing
  static getInstance() {
    if (!Singleton.instance) {
      Singleton.instance = new Singleton();
    }
    return Singleton.instance;
  }
}

// Usage
const instance1 = Singleton.getInstance();
const instance2 = Singleton.getInstance();
console.log(instance1 === instance2); // true
console.log(instance1.message); // "This is the single instance"
```

```javascript
// using ES2022+ features
class Singleton {
    static #instance;

    constructor() {
        if (Singleton.#instance) {
            return Singleton.#instance;
        }
        this.message = "This is the single instance";
        Singleton.#instance = this;
    }

    // getInstance method is redundant already hence the constructor does the same thing
    static getInstance() {
        if (!Singleton.#instance) {
            Singleton.#instance = new Singleton();
        }
        return Singleton.#instance;
    }
}

// Usage
const instance1 = new Singleton();
const instance2 = new Singleton();

console.log(instance1 === instance2); // true
console.log(instance1.message);       // "This is the single instance"
```

## Structural Patterns

Structural patterns organize object composition, making it more flexible and extendable.

### Adapter

The Adapter pattern allows incompatible interfaces to work together, often used for integrating third-party libraries or APIs.

```javascript
// The unified interface for database interactions
class Database {
  connect() {
    throw new Error("Method 'connect()' must be implemented.");
  }

  insert(data) {
    throw new Error("Method 'insert()' must be implemented.");
  }

  disconnect() {
    throw new Error("Method 'disconnect()' must be implemented.");
  }
}

// The SQLDatabase class implementing the unified interface directly
class SQLDatabase extends Database {
  connect() {
    console.log("Connecting to SQL database...");
  }

  insert(data) {
    console.log("Inserting data into SQL database: " + data);
  }

  disconnect() {
    console.log("Disconnecting from SQL database.");
  }
}

// The NoSQLDatabase class with a different interface
class NoSQLDatabase {
  openConnection() {
    console.log("Opening connection to NoSQL database...");
  }

  saveDocument(document) {
    console.log("Saving document to NoSQL database: " + document);
  }

  closeConnection() {
    console.log("Closing connection to NoSQL database.");
  }
}

// The Adapter class to make NoSQLDatabase compatible with the Database interface
class NoSQLDatabaseAdapter extends Database {
  constructor(noSQLDatabase) {
    super();
    this.noSQLDatabase = noSQLDatabase;
  }

  connect() {
    this.noSQLDatabase.openConnection(); // Adapting openConnection to connect
  }

  insert(data) {
    this.noSQLDatabase.saveDocument(data); // Adapting saveDocument to insert
  }

  disconnect() {
    this.noSQLDatabase.closeConnection(); // Adapting closeConnection to disconnect
  }
}

// Usage example
const sqlDatabase = new SQLDatabase();
sqlDatabase.connect();
sqlDatabase.insert("SQL Record");
sqlDatabase.disconnect();

console.log();

const noSQLDatabase = new NoSQLDatabaseAdapter(new NoSQLDatabase());
noSQLDatabase.connect();
noSQLDatabase.insert("NoSQL Document");
noSQLDatabase.disconnect();
```

### Decorator

The Decorator pattern dynamically adds new behavior to an object, often implemented as higher-order functions.

```javascript
function withLogging(fn) {
    return function (...args) {
        console.log("Calling with arguments:", args);
        return fn(...args);
    };
}
```
In ES6+, JavaScript introduced decorators as a proposal that, while still in the stage 2 proposal phase, can be used in many environments with a transpiler like Babel. Decorators provide a cleaner and more readable way to wrap or extend functions or methods.

Here’s how to create a logging decorator that can be applied directly to a method using the `@decorator` syntax.

```javascript
// Decorator function
function withLogging(target, key, descriptor) {
    const originalFunction = descriptor.value;

    // Modify the method to include logging functionality
    descriptor.value = function (...args) {
        console.log(`Calling ${key} with arguments:`, args);
        return originalFunction.apply(this, args);
    };

    return descriptor;
}

class Example {
    @withLogging
    myMethod(a, b) {
        return a + b;
    }
}

// Usage
const example = new Example();
example.myMethod(5, 7); // Output: Calling myMethod with arguments: [5, 7]
```

### Proxy

The Proxy pattern provides a surrogate or placeholder to control access to an object, and JavaScript’s `Proxy` object enables this natively.

```javascript
const target = {
    message: "Hello, Proxy!"
};

const handler = {
    get(obj, prop) {
        return prop in obj ? obj[prop] : "Property not found";
    }
};
```

### Composite

The Composite pattern allows you to treat individual objects and compositions uniformly. JavaScript classes and arrays support this pattern.

```javascript
class Component {
    constructor(name) {
        this.name = name;
        this.children = [];
    }

    add(child) {
        this.children.push(child);
    }
}
```

### Facade

The Facade pattern provides a simple interface to a complex system. JavaScript modules are a good way to implement a Facade.

```javascript
class APIService {
    fetchData() { /* complex logic */ }
}

class Facade {
    constructor() {
        this.api = new APIService();
    }

    getData() {
        return this.api.fetchData();
    }
}
```

### Flyweight

The Flyweight pattern reduces memory usage by sharing common data between similar objects. This can be emulated using closures or data structures in JavaScript.

```javascript
const FlyweightFactory = (function () {
    const instances = {};

    function getFlyweight(key) {
        if (!instances[key]) {
            instances[key] = new Flyweight(key);
        }
        return instances[key];
    }
    return { getFlyweight };
})();
```

## Behavioral Patterns

Behavioral patterns handle communication between objects, defining the flow of control and interaction.

### Observer

The Observer pattern establishes a one-to-many dependency between objects. JavaScript's event-driven nature makes it well-suited for the Observer pattern.

```javascript
class Subject {
    constructor() {
        this.observers = [];
    }

    subscribe(observer) {
        this.observers.push(observer);
    }

    notify(data) {
        this.observers.forEach(observer => observer(data));
    }
}
```

### Strategy

The Strategy pattern allows interchangeable algorithms for different tasks. This pattern is common in JavaScript for algorithmic flexibility.

```javascript
function calculate(strategy, a, b) {
    return strategy(a, b);
}
```

### Command

The Command pattern encapsulates requests as objects, allowing for parameterization and queuing.

```javascript
class CommandManager {
    constructor() {
        this.commands = [];
    }

    addCommand(command) {
        this.commands.push(command);
    }
}
```

### Chain of Responsibility

The Chain of Responsibility pattern passes a request along a chain of handlers until one handles it.

```javascript
class Handler {
    setNext(handler) {
        this.nextHandler = handler;
        return handler;
    }
}
```

### State

The State pattern allows an object to change its behavior when its internal state changes.

```javascript
class Order {
    constructor() {
        this.state = new PendingState(this);
    }
}
```

### Visitor

The Visitor pattern allows you to define new operations on objects without modifying them.

```javascript
class Animal {
    accept(visitor) {
        visitor.visit(this);
    }
}
```

## JavaScript-Specific Patterns

In addition to traditional design patterns, JavaScript has several unique patterns and idioms that leverage its functional and asynchronous capabilities.

### Module Pattern

The Module pattern is commonly used in JavaScript to encapsulate and organize code, controlling which parts are exposed and which remain private. Modules help maintain a clean namespace.

```javascript
const CounterModule = (function () {
    let counter = 0;

    function increment() {
        counter++;
    }

    function getCounter() {
        return counter;
    }

    return {
        increment,
        getCounter
    };
})();

CounterModule.increment();
console.log(CounterModule.getCounter()); // 1
```

### Revealing Module Pattern

The Revealing Module pattern is a variation of the Module pattern where internal functions and variables are encapsulated, and only the desired functions are exposed.

```javascript
const RevealingCounterModule = (function () {
    let counter = 0;

    function increment() {
        counter++;
    }

    function getCounter() {
        return counter;
    }

    return {
        increment,
        getCounter
    };
})();

RevealingCounterModule.increment();
console.log(RevealingCounterModule.getCounter()); // 1
```

## External References

- [JavaScript Module Pattern](https://toddmotto.com/mastering-the-module-pattern/)
- [Observer Pattern in JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Events)
- [JavaScript Factory Pattern](https://medium.com/@saraswati.jonwal/factory-pattern-javascript-23d9d39fc3a1)
- [Singleton Pattern in JavaScript](https://www.dofactory.com/javascript/design-patterns/singleton)
- [JavaScript Proxy and Reflect](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference)
- [JavaScript Design Patterns and Practices](https://refactoring.guru/design-patterns/javascript)

## Conclusion

JavaScript’s dynamic and flexible nature, combined with ES6+ features, makes it well-suited for implementing a wide range of design patterns. Understanding and utilizing these patterns can help improve the structure, maintainability, and scalability of your code, especially in complex or large-scale applications.
