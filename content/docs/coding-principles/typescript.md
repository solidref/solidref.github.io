---
title: 'Coding Principles in TypeScript'
draft: false
---

# Coding Principles in TypeScript

TypeScript brings static typing and powerful tooling to JavaScript, helping developers catch errors early and write more structured code. By following core coding principles—like DRY, KISS, and SOLID—you can ensure that your TypeScript code is clean, efficient, and maintainable. This article explores these principles with TypeScript-specific examples and best practices.

## DRY (Don’t Repeat Yourself)

The DRY principle helps you avoid code duplication. TypeScript’s interfaces, types, and generics make it easier to encapsulate repetitive logic in a reusable way.



```typescript
// Bad
function calculateDiscount(price: number): number {
    return price * 0.1;
}

function applyDiscount(price: number): number {
    return price - (price * 0.1);
}

// Good
function calculateDiscount(price: number, discountRate: number): number {
    return price * discountRate;
}

const finalPrice = calculateDiscount(100, 0.1);
```

**TypeScript-Specific Tip**: Use interfaces, types, and generics to encapsulate common patterns and structures, reducing code duplication across your project.

## KISS (Keep It Simple, Stupid)

TypeScript encourages simpler code by enforcing static types, which naturally improves readability. Aim to keep your TypeScript code clear and straightforward.



```typescript
// Bad
function getNumberOfUsers(usersArray: string[] | undefined): number {
    if (usersArray !== undefined && usersArray.length > 0) {
        return usersArray.length;
    }
    return 0;
}

// Good
function getNumberOfUsers(usersArray: string[] = []): number {
    return usersArray.length;
}
```

**TypeScript-Specific Tip**: Use default parameters, union types, and TypeScript’s type inference to simplify your functions.

## YAGNI (You Aren’t Gonna Need It)

Avoid adding unnecessary properties or functionality in TypeScript classes. Static typing ensures you only include what’s needed, reducing maintenance overhead.



```typescript
// Bad
class User {
    name: string;
    email: string;
    address: string = ""; // Not needed now, but may be needed later

    constructor(name: string, email: string) {
        this.name = name;
        this.email = email;
    }
}

// Good
class User {
    constructor(public name: string, public email: string) {}
}
```

**TypeScript-Specific Tip**: Leverage TypeScript’s constructor shorthand to keep your classes concise and avoid adding unused properties.

## SOLID Principles in TypeScript

The SOLID principles are design principles that make software more understandable, flexible, and maintainable. TypeScript’s class-based syntax and interfaces make it an ideal language for implementing SOLID.

### Single Responsibility Principle (SRP)

A class or function should have one reason to change. Use TypeScript interfaces to separate concerns and encapsulate responsibilities.

```typescript
// Bad
class User {
    constructor(public name: string, public email: string) {}

    saveToDatabase(): void {
        // Logic for saving to database
    }
}

// Good
class User {
    constructor(public name: string, public email: string) {}
}

class UserRepository {
    save(user: User): void {
        // Logic for saving to database
    }
}
```

### Open/Closed Principle (OCP)

Objects or functions should be open for extension but closed for modification. TypeScript’s interfaces and inheritance can help you extend functionality without modifying existing code.

```typescript
// Using inheritance to extend functionality
interface Logger {
    log(message: string): void;
}

class ConsoleLogger implements Logger {
    log(message: string): void {
        console.log(message);
    }
}

class TimestampLogger extends ConsoleLogger {
    log(message: string): void {
        super.log(`[${new Date().toISOString()}] ${message}`);
    }
}
```

### Liskov Substitution Principle (LSP)

Subtypes should be substitutable for their base types. This principle encourages creating classes that can stand in for their parent classes without unexpected behavior.

```typescript
class Rectangle {
    constructor(public width: number, public height: number) {}

    area(): number {
        return this.width * this.height;
    }
}

class Square extends Rectangle {
    constructor(side: number) {
        super(side, side);
    }
}
```

### Interface Segregation Principle (ISP)

Interfaces should only include methods that are essential for their purpose. Define smaller, focused interfaces rather than one large interface.

```typescript
interface Printable {
    print(): void;
}

interface Scannable {
    scan(): void;
}

class Printer implements Printable {
    print(): void {
        console.log("Printing document...");
    }
}

class MultifunctionPrinter implements Printable, Scannable {
    print(): void {
        console.log("Printing document...");
    }

    scan(): void {
        console.log("Scanning document...");
    }
}
```

### Dependency Inversion Principle (DIP)

Depend on abstractions rather than concrete implementations. Use interfaces in TypeScript to enforce loose coupling between classes.

```typescript
interface Database {
    save(data: any): void;
}

class MongoDatabase implements Database {
    save(data: any): void {
        // Logic to save data to MongoDB
    }
}

class UserRepository {
    constructor(private database: Database) {}

    saveUser(user: any): void {
        this.database.save(user);
    }
}
```

## Encapsulation

Encapsulation is a key feature of TypeScript. Use `private` and `protected` access modifiers to control access to class properties and methods.



```typescript
class BankAccount {
    private balance: number;

    constructor(initialBalance: number) {
        this.balance = initialBalance;
    }

    deposit(amount: number): void {
        this.balance += amount;
    }

    getBalance(): number {
        return this.balance;
    }
}
```

## Separation of Concerns

Separation of concerns is a core principle in TypeScript as well. By using classes and interfaces, you can modularize functionality and make code easier to manage.



```typescript
// Service for handling business logic
class UserService {
    findUserById(id: number): any {
        // Logic for finding user
    }
}

// Controller for handling HTTP requests
class UserController {
    constructor(private userService: UserService) {}

    getUser(id: number): any {
        return this.userService.findUserById(id);
    }
}
```

**TypeScript-Specific Tip**: TypeScript’s dependency injection support makes it easier to follow the separation of concerns principle, especially in frameworks like Angular.

## Law of Demeter

The Law of Demeter discourages accessing nested objects directly. Instead, use functions to retrieve values.



```typescript
// Bad
console.log(order.customer.address.city);

// Good
console.log(order.getCustomerCity());
```

## Composition Over Inheritance

Composition is often preferable to inheritance, as it allows for more flexible and modular code. TypeScript’s interfaces and classes make composition straightforward.



```typescript
// Using composition
class Engine {
    start(): void {
        console.log("Engine started");
    }
}

class Car {
    constructor(private engine: Engine) {}

    start(): void {
        this.engine.start();
    }
}

const car = new Car(new Engine());
car.start(); // Engine started
```

## Fail Fast

The fail-fast principle means detecting errors as early as possible. TypeScript’s strict type checking enforces this principle by catching issues at compile-time.



```typescript
function divide(a: number, b: number): number {
    if (b === 0) throw new Error("Division by zero");
    return a / b;
}

try {
    console.log(divide(10, 0));
} catch (error) {
    console.error(error.message);
}
```

**TypeScript-Specific Tip**: Use TypeScript’s type system to validate inputs and catch errors before runtime.

## Coding for Readability

Readable code is essential in TypeScript. By using meaningful names, modular functions, and clear type annotations, you make the code more maintainable and understandable.



```typescript
// Bad
let a = [1,2,3]; for (let i = 0; i < a.length; i++) console.log(a[i]);

// Good
const numbers: number[] = [1, 2, 3];
numbers.forEach((number) => console.log(number));
```

**TypeScript-Specific Tip**: Use explicit types and access modifiers (`public`, `private`, `protected`) to improve readability and enforce consistency.

## TypeScript-Specific Principles

### Use `readonly` for Immutability

Immutability is crucial in TypeScript, especially when working with complex data structures. Use `readonly` to enforce immutability in your classes.

```typescript
class Point {
    constructor(public readonly x: number, public readonly y: number) {}
}
```

### Prefer `unknown` over `any`

When dealing with unknown types, prefer `unknown` over `any`. This enforces type checking, ensuring you verify the type before using it.

```typescript
function process(value: unknown) {
    if (typeof value === "string") {
        console.log("String:", value);
    }
}
```

### Avoid Type Assertion

Type assertions (using `as` keyword) can be dangerous if misused. Avoid using them unless necessary, as they bypass TypeScript’s type checking.

```typescript
// Bad
const inputValue = document.getElementById("input") as HTMLInputElement;

// Good
const inputElement

 = document.getElementById("input");
if (inputElement instanceof HTMLInputElement) {
    inputElement.value = "Hello, TypeScript!";
}
```
