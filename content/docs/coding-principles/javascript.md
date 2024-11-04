---
title: 'Coding Principles in JavaScript'
draft: false
bookHidden: true
---

# Coding Principles in JavaScript

JavaScript is one of the most widely-used programming languages, both in the browser and on the server with Node.js. Applying coding principles to JavaScript ensures your code is clean, efficient, and maintainable. In this article, we’ll cover foundational principles like DRY, KISS, and SOLID, as well as JavaScript-specific best practices.

## DRY (Don’t Repeat Yourself)

In JavaScript, the DRY principle applies to both function and class structures. By avoiding duplicate code, you can keep logic centralized, making updates easier and reducing errors.



```javascript
// Bad
function applyDiscount(price) {
    return price - (price * 0.1);
}

function calculateFinalPrice(price) {
    return price - (price * 0.1);
}

// Good
function applyDiscount(price, discountRate) {
    return price - (price * discountRate);
}

const finalPrice = applyDiscount(100, 0.1);
```

**JavaScript-Specific Tip**: With modern JavaScript, using functions or modules can help you implement DRY more effectively, especially in larger applications where code is modularized.

## KISS (Keep It Simple, Stupid)

JavaScript code can quickly become complex, especially with asynchronous logic and closures. The KISS principle encourages simpler, more readable solutions.



```javascript
// Bad
function getUserCount(usersArray) {
    if (usersArray !== undefined && usersArray.length > 0) {
        return usersArray.length;
    }
    return 0;
}

// Good
function getUserCount(usersArray = []) {
    return usersArray.length;
}
```

**JavaScript-Specific Tip**: Use default function parameters (like `usersArray = []` above) to handle undefined or missing values more concisely.

## YAGNI (You Aren’t Gonna Need It)

Avoid adding features or properties that you may need later. This keeps your code lightweight and maintainable.



```javascript
// Bad
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
        this.address = ""; // Not needed now, but might be needed later
    }
}

// Good
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }
}
```

**JavaScript-Specific Tip**: Use only necessary properties. JavaScript’s dynamic nature lets you add properties later if needed, reducing the temptation to add unused fields.

## SOLID Principles in JavaScript

The SOLID principles can be adapted to JavaScript’s object-oriented and functional paradigms. Here’s a breakdown of each principle with JavaScript examples:

### Single Responsibility Principle (SRP)

A function or class should have one reason to change. Each component should focus on a single task.

```javascript
// Bad
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }

    saveToDatabase() {
        // code to save user data
    }
}

// Good
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }
}

class UserRepository {
    save(user) {
        // code to save user data
    }
}
```

### Open/Closed Principle (OCP)

Objects or functions should be open for extension but closed for modification. Use inheritance or composition to add new functionality.

```javascript
// Using composition to extend functionality
class Logger {
    log(message) {
        console.log(message);
    }
}

class TimestampLogger {
    constructor(logger) {
        this.logger = logger;
    }

    log(message) {
        this.logger.log(`[${new Date().toISOString()}] ${message}`);
    }
}
```

### Liskov Substitution Principle (LSP)

Objects of a superclass should be replaceable with objects of a subclass without affecting functionality. Avoid changes in behavior between parent and child classes.

```javascript
class Rectangle {
    constructor(width, height) {
        this.width = width;
        this.height = height;
    }

    area() {
        return this.width * this.height;
    }
}

class Square extends Rectangle {
    constructor(side) {
        super(side, side);
    }
}
```

### Interface Segregation Principle (ISP)

Clients shouldn’t be forced to depend on methods they don’t use. JavaScript doesn’t have interfaces like statically-typed languages, so we can simulate ISP using smaller, specialized classes.

### Dependency Inversion Principle (DIP)

Depend on abstractions rather than concrete implementations. Use dependency injection to decouple classes.

```javascript
class Database {
    save(data) {
        // logic to save data
    }
}

class UserRepository {
    constructor(database) {
        this.database = database;
    }

    saveUser(user) {
        this.database.save(user);
    }
}
```

## Encapsulation

Encapsulation in JavaScript can be achieved through classes and closures. ES6 introduced the `class` syntax, but JavaScript also allows you to use closures to restrict data access.



```javascript
// Using closures for encapsulation
function createCounter() {
    let count = 0;

    return {
        increment: () => count++,
        getCount: () => count,
    };
}

const counter = createCounter();
counter.increment();
console.log(counter.getCount()); // 1
```

## Separation of Concerns

JavaScript applications benefit from clear separation between data handling, logic, and presentation. This is particularly important in frameworks like React and Vue.



```javascript
// Separate data logic from UI
class UserService {
    fetchUser(id) {
        // Fetch user data from API
    }
}

class UserController {
    constructor(userService) {
        this.userService = userService;
    }

    showUser(id) {
        const user = this.userService.fetchUser(id);
        console.log(`User: ${user.name}`);
    }
}
```

**JavaScript-Specific Tip**: In frontend frameworks, separate components and services to handle logic, data fetching, and rendering.

## Law of Demeter

In JavaScript, the Law of Demeter discourages accessing deeply nested properties directly, as it creates tight coupling.



```javascript
// Bad
console.log(order.customer.address.city);

// Good
console.log(order.getCustomerCity());
```

Encapsulate access to nested properties with functions to prevent coupling.

## Composition Over Inheritance

JavaScript’s flexibility with functions and objects makes composition easy. Instead of relying on inheritance, you can compose objects with the behaviors they need.



```javascript
// Using composition
const canFly = {
    fly() {
        console.log("Flying");
    }
};

const canSwim = {
    swim() {
        console.log("Swimming");
    }
};

function createDuck() {
    return { ...canFly, ...canSwim };
}

const duck = createDuck();
duck.fly(); // Flying
duck.swim(); // Swimming
```

## Fail Fast

JavaScript’s dynamic typing makes runtime checks essential. Check for invalid conditions early to prevent errors from propagating.



```javascript
function divide(a, b) {
    if (b === 0) throw new Error("Division by zero");
    return a / b;
}

try {
    console.log(divide(10, 0));
} catch (error) {
    console.error(error.message);
}
```

## Coding for Readability

JavaScript offers flexibility, but readability should always be a priority. Use meaningful names, modularize code, and avoid one-liners for complex logic.



```javascript
// Bad
let a = [1,2,3]; for (let i = 0; i < a.length; i++) console.log(a[i]);

// Good
const numbers = [1, 2, 3];
numbers.forEach(number => console.log(number));
```

**JavaScript-Specific Tip**: Use arrow functions, destructuring, and template literals to write concise yet readable code.

## JavaScript-Specific Principles

### Callback Hell

Avoid deeply nested callbacks by using Promises or async/await. Asynchronous operations are common in JavaScript, and handling them well improves readability.

```javascript
// Using async/await to avoid callback hell
async function fetchUserData(userId) {
    try {
        const response = await fetch(`/api/user/${userId}`);
        const data = await response.json();
        console.log(data);
    } catch (error) {
        console.error(error);
    }
}
```

### Avoid Global Variables

Global variables can lead to conflicts and bugs. Use modules, closures, or namespaces to avoid polluting the global scope.

```javascript
// Using IIFE to avoid global variables
(function() {
    const localVariable = "I'm local!";
    console.log(localVariable);
})();
```
