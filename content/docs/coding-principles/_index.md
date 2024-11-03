---
title: 'Coding Principles'
draft: false
---

# Coding Principles

Coding principles are guidelines designed to help developers write code that is clean, efficient, and maintainable. These principles go beyond syntax, offering best practices that can be applied across programming languages. Here are some core coding principles that every developer should know.

## DRY (Don’t Repeat Yourself)

The DRY principle encourages avoiding duplication in code. Instead of repeating similar logic in multiple places, encapsulate it in a function or module. This reduces redundancy, minimizes potential errors, and makes updates easier.


```python
# Bad
def calculate_discount(price):
    return price * 0.1

def apply_discount(price):
    return price - (price * 0.1)

# Good
def calculate_discount(price, discount_rate):
    return price * discount_rate
```

By centralizing logic, we avoid duplicating the same calculation across functions.

## KISS (Keep It Simple, Stupid)

The KISS principle advocates for simplicity in code design. Overly complex solutions are harder to understand and maintain. Aim for the simplest solution that accomplishes the task effectively.


```javascript
// Bad
function getNumberOfUsers(usersArray) {
    if (usersArray !== undefined && usersArray.length > 0) {
        return usersArray.length;
    }
    return 0;
}

// Good
function getNumberOfUsers(usersArray = []) {
    return usersArray.length;
}
```

Simplifying conditions and logic increases readability and reduces potential issues.

## YAGNI (You Aren’t Gonna Need It)

The YAGNI principle discourages adding functionality until it’s necessary. Avoiding “just-in-case” features keeps code lean and prevents extra maintenance overhead.


```java
// Bad
public class User {
    private String name;
    private String email;
    private String address; // Not needed now, but may be needed in the future
}

// Good
public class User {
    private String name;
    private String email;
}
```

By only implementing necessary features, we avoid bloating the codebase.

## SOLID Principles

The SOLID principles are a set of five design principles aimed at making software designs more understandable, flexible, and maintainable. SOLID stands for:
- **[Single Responsibility Principle (SRP)](/coding-principles/solid/single-responsibility)**: A class should have only one reason to change.
- **[Open/Closed Principle (OCP)](/coding-principles/solid/open-closed)**: Software entities should be open for extension but closed for modification.
- **[Liskov Substitution Principle (LSP)](/coding-principles/solid/liskov-substitution)**: Derived classes should be substitutable for their base classes.
- **[Interface Segregation Principle (ISP)](/coding-principles/solid/interface-segregation)**: Clients should not be forced to depend on methods they do not use.
- **[Dependency Inversion Principle (DIP)](/coding-principles/solid/dependency-inversion)**: Depend on abstractions, not on concretions.

Each of these principles encourages a modular, extensible approach to design, reducing the risk of tightly coupled code.

## Encapsulation

Encapsulation is about bundling related data and methods within a single unit (e.g., a class). It restricts direct access to some of an object’s components, which can help protect data integrity and prevent misuse.


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

By hiding the `balance` property, we prevent external code from modifying it directly.

## Separation of Concerns

Separation of concerns involves dividing a program into distinct sections, each handling a specific aspect of the functionality. This approach improves modularity, makes code easier to maintain, and allows changes to one part without impacting others.


```csharp
// Controller for handling HTTP requests
public class UserController {
    private UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    public User getUser(int id) {
        return userService.findUserById(id);
    }
}

// Service for business logic
public class UserService {
    public User findUserById(int id) {
        // Logic for finding user
    }
}
```

This structure separates concerns of data handling, business logic, and presentation.

## Law of Demeter

The Law of Demeter advises that an object should avoid interacting with too many other objects, especially not directly with objects it doesn’t “own.” This reduces dependencies and keeps code loosely coupled.


```ruby
# Bad
user.order.cart.total

# Good
user.order_total
```

Reducing “chained” interactions helps ensure changes in one class don’t ripple through unrelated parts of the code.

## Composition Over Inheritance

Favoring composition over inheritance allows for more flexible code reuse. Composition involves including instances of other classes within a class, rather than inheriting from a parent class.


```javascript
// Using composition
class Engine {
    start() {
        console.log("Engine started");
    }
}

class Car {
    constructor() {
        this.engine = new Engine();
    }

    start() {
        this.engine.start();
    }
}
```

With composition, we can modify or replace behaviors more easily.

## Fail Fast

The fail-fast principle means that errors should be detected and reported as soon as possible, ideally as close to their source as possible. This reduces the chances of encountering complex issues later in the program’s lifecycle.


```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}
```

By checking for errors early, we prevent cascading errors and improve reliability.

## Coding for Readability

Readable code is easier to maintain and debug. Always prioritize code readability by using clear naming, modular functions, and consistent formatting.


```php
// Bad
$a = 10; $b = 5; $c = $a + $b;

// Good
$firstNumber = 10;
$secondNumber = 5;
$sum = $firstNumber + $secondNumber;
```

Readable code reduces misunderstandings and makes it easier for new developers to contribute to the project.