---
title: 'Coding Principles in C++'
draft: false
bookHidden: true
languageExample: true
languageExampleTitle: C++
showLanguageFilter: true
---

# Coding Principles in C++

C++ is a powerful language known for its performance and flexibility. Applying coding principles in C++ helps developers write clean, efficient, and maintainable code. This article explores core coding principles—like DRY, KISS, and SOLID—and how they apply to C++, along with some C++-specific best practices.

## DRY (Don’t Repeat Yourself)

The DRY principle aims to reduce code duplication. In C++, this can be achieved by using functions, classes, and templates to centralize logic.

```cpp
// Bad
double calculateDiscount(double price) {
    return price * 0.1;
}

double applyDiscount(double price) {
    return price - (price * 0.1);
}

// Good
double calculateDiscount(double price, double discountRate) {
    return price * discountRate;
}

double applyDiscount(double price) {
    return price - calculateDiscount(price, 0.1);
}
```

**C++-Specific Tip**: Use templates and generic programming to avoid code duplication across different data types.

## KISS (Keep It Simple, Stupid)

The KISS principle advocates for simplicity in code design. In C++, this means avoiding overly complex solutions and focusing on readability.

```cpp
// Bad
int getUserCount(std::vector<std::string> users) {
    if (!users.empty()) {
        return users.size();
    }
    return 0;
}

// Good
int getUserCount(const std::vector<std::string>& users) {
    return users.size();
}
```

**C++ Specific Tip**: Use modern C++ features like range-based for loops and auto keyword to simplify code.

## YAGNI (You Aren’t Gonna Need It)

The YAGNI principle advises against implementing features until they’re necessary. In C++, this means keeping classes and functions focused on current requirements.

```cpp
// Bad
class User {
    std::string name;
    std::string email;
    std::string address; // Not needed now, but might be needed later
};

// Good
class User {
    std::string name;
    std::string email;
};
```

**C++-Specific Tip**: Use smart pointers to manage resources only when needed, avoiding premature optimization.

## SOLID Principles in C++

C++ supports SOLID principles through its object-oriented features. Here's how each principle can be applied:

### Single Responsibility Principle (SRP)

A class should have one responsibility. C++ classes should be focused and cohesive.

```cpp
// Bad
class User {
    std::string name;
    std::string email;
public:
    void saveToDatabase() {
        // Save user to database
    }
};

// Good
class User {
    std::string name;
    std::string email;
};

class UserRepository {
public:
    void save(const User& user) {
        // Save user to database
    }
};
```

### Open/Closed Principle (OCP)

In C++, the Open/Closed Principle can be achieved through inheritance and polymorphism.

```cpp
class Logger {
public:
    virtual void log(const std::string& message) = 0;
};

class ConsoleLogger : public Logger {
public:
    void log(const std::string& message) override {
        std::cout << message << std::endl;
    }
};

class TimestampLogger : public Logger {
private:
    Logger& logger;
public:
    TimestampLogger(Logger& logger) : logger(logger) {}

    void log(const std::string& message) override {
        logger.log("[" + currentTimestamp() + "] " + message);
    }
};
```

### Liskov Substitution Principle (LSP)

In C++, LSP is about ensuring derived classes can be used interchangeably with base classes.

```cpp
class Shape {
public:
    virtual double area() const = 0;
};

class Rectangle : public Shape {
    double width, height;
public:
    double area() const override {
        return width * height;
    }
};

class Square : public Shape {
    double side;
public:
    double area() const override {
        return side * side;
    }
};
```

### Interface Segregation Principle (ISP)

C++ interfaces (abstract classes) should be small and focused.

```cpp
class Printer {
public:
    virtual void print() = 0;
};

class Scanner {
public:
    virtual void scan() = 0;
};

class MultiFunctionDevice : public Printer, public Scanner {
public:
    void print() override {
        std::cout << "Printing..." << std::endl;
    }

    void scan() override {
        std::cout << "Scanning..." << std::endl;
    }
};
```

### Dependency Inversion Principle (DIP)

In C++, the DIP principle can be applied by depending on abstractions rather than concrete implementations.

```cpp
class Database {
public:
    virtual void save(const std::string& data) = 0;
};

class UserRepository {
    Database& db;
public:
    UserRepository(Database& db) : db(db) {}

    void saveUser(const std::string& user) {
        db.save(user);
    }
};
```

## Encapsulation

Encapsulation in C++ is achieved using access specifiers like `private`, `protected`, and `public`.

```cpp
class BankAccount {
private:
    double balance;
public:
    void deposit(double amount) {
        balance += amount;
    }

    double getBalance() const {
        return balance;
    }
};
```

**C++-Specific Tip**: Use encapsulation to protect class invariants and hide implementation details.

## Separation of Concerns

Separation of concerns in C++ involves organizing code into classes and modules, each with a focused responsibility.

```cpp
// UserService.h (business logic)
class UserService {
public:
    User findUser(int id);
};

// UserController.h (HTTP handling)
class UserController {
    UserService& userService;
public:
    UserController(UserService& userService) : userService(userService) {}

    User getUser(int id) {
        return userService.findUser(id);
    }
};
```

**C++-Specific Tip**: Use namespaces and modules to separate different parts of your application logically.

## Law of Demeter

The Law of Demeter in C++ advises against chaining calls, which creates tight coupling between components.

```cpp
// Bad
std::cout << order.getCustomer().getAddress().getCity() << std::endl;

// Good
std::cout << order.getCustomerCity() << std::endl;
```

## Composition Over Inheritance

C++ promotes composition over inheritance using classes and templates. This allows flexible code reuse without the complexity of inheritance.

```cpp
class Engine {
public:
    void start() {
        std::cout << "Engine started" << std::endl;
    }
};

class Car {
    Engine engine;
public:
    void start() {
        engine.start();
    }
};
```

**C++-Specific Tip**: Prefer composition for reusing behavior without inheriting unnecessary dependencies.

## Fail Fast

C++ encourages fail-fast principles, especially through exception handling. Check for errors as soon as they occur to prevent issues from spreading.

```cpp
double divide(double a, double b) {
    if (b == 0) {
        throw std::invalid_argument("division by zero");
    }
    return a / b;
}

try {
    double result = divide(10, 0);
} catch (const std::invalid_argument& e) {
    std::cerr << "Error: " << e.what() << std::endl;
}
```

**C++-Specific Tip**: Use exceptions to handle errors and ensure resources are properly managed using RAII.

## Coding for Readability

Readable code is essential in C++. Follow naming conventions, use consistent formatting, and write modular functions to make your code easy to understand.

```cpp
// Bad
int a = 10, b = 5, c = a + b;

// Good
int firstNumber = 10;
int secondNumber = 5;
int sum = firstNumber + secondNumber;
```

**C++-Specific Tip**: Use modern C++ features like smart pointers and lambda expressions to enhance code readability and maintainability.

## C++-Specific Principles

### Smart Pointers

Use smart pointers like `std::unique_ptr` and `std::shared_ptr` to manage dynamic memory safely and prevent memory leaks.

```cpp
std::unique_ptr<int> ptr = std::make_unique<int>(10);
```

### Lambda Expressions

Lambda expressions provide a concise way to define anonymous functions and are useful for implementing callbacks and functional programming patterns.

```cpp
auto add = [](int a, int b) { return a + b; };
std::cout << add(5, 3) << std::endl; // Outputs 8
```

### C++11/14/17/20 Features

Modern C++ standards introduce features that enhance code readability and maintainability, such as auto keyword, range-based for loops, and structured bindings.

```cpp
std::vector<int> numbers = {1, 2, 3, 4, 5};
for (auto number : numbers) {
    std::cout << number << std::endl;
}
```

**C++-Specific Tip**: Stay updated with the latest C++ standards to leverage new features that improve code quality.
