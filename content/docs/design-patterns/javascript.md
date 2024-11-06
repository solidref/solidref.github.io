---
title: 'Design Patterns in JavaScript'
draft: false
bookHidden: true
languageExample: true
languageExampleTitle: JavaScript
showLanguageFilter: true
---

# Design Patterns in JavaScript

JavaScript's versatility and support for both object-oriented and functional programming make it suitable for implementing a wide range of design patterns. With ES6+ features like classes, modules, and `Proxy`, many traditional design patterns can be applied to JavaScript effectively. This article provides examples of **Creational**, **Structural**, and **Behavioral** design patterns, each tailored for JavaScript.

## Why Design Patterns Matter in JavaScript

Design patterns are reusable solutions to common software design problems. They help organize code, making it more modular, maintainable, and scalable. In JavaScript, patterns like Singleton, Observer, and Module are particularly useful for managing complexity, especially in asynchronous and event-driven applications.

## Creational Patterns

Creational patterns deal with object creation, making it more flexible and decoupled from the client.

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

### Abstract Factory

The Abstract Factory pattern provides an interface for creating families of related objects. In JavaScript, factories can return objects configured with different properties or methods.

```javascript
function createUIFactory(theme) {
    return theme === "dark"
        ? { background: "black", textColor: "white" }
        : { background: "white", textColor: "black" };
}
```

### Builder

The Builder pattern constructs complex objects step-by-step. JavaScript’s chaining methods and object literals make it well-suited for this pattern.

```javascript
class Car {
    constructor() {
        this.color = "white";
        this.engine = "V4";
    }

    setColor(color) {
        this.color = color;
        return this;
    }

    setEngine(engine) {
        this.engine = engine;
        return this;
    }

    build() {
        return `Car with ${this.color} color and ${this.engine} engine`;
    }
}
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

## Structural Patterns

Structural patterns organize object composition, making it more flexible and extendable.

### Adapter

The Adapter pattern allows incompatible interfaces to work together, often used for integrating third-party libraries or APIs.

```javascript
class OldCalculator {
    add(a, b) {
        return a + b;
    }
}

class CalculatorAdapter {
    constructor() {
        this.calculator = new NewCalculator();
    }

    add(a, b) {
        return this.calculator.sum(a, b);
    }
}
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
