---
title: 'Design Patterns in Go'
draft: false
bookHidden: true
languageExample: true
languageExampleTitle: Go
showLanguageFilter: true
---

# Design Patterns in Go

Go (Golang) is a language that promotes simplicity and favors composition over inheritance. This approach influences how design patterns are implemented, making some patterns more suitable and others less relevant. In this article, we’ll explore the three main categories of design patterns—**Creational**, **Structural**, and **Behavioral**—and how they apply in Go. We'll also cover Go-specific design patterns and provide links to further resources.

## Why Design Patterns Matter in Go

Design patterns offer reusable solutions to common problems in software design. They help make your code more modular, scalable, and maintainable. Go’s idiomatic approach to design patterns is minimalistic, focusing on clear, simple, and efficient solutions.

## Creational Patterns

Creational patterns help control object creation, making it more flexible and modular. In Go, we often use functions rather than complex class hierarchies, as Go does not have classes or inheritance.

### Builder

The Builder pattern constructs complex objects step by step. Go doesn’t use a Builder pattern as frequently due to its simplicity, but it can be achieved using structs with chainable methods.

```go
package builder

type Car struct {
    Color string
    Wheels int
    EngineType string
}

type CarBuilder struct {
    car Car
}

func (cb *CarBuilder) Color(color string) *CarBuilder {
    cb.car.Color = color
    return cb
}

func (cb *CarBuilder) Wheels(wheels int) *CarBuilder {
    cb.car.Wheels = wheels
    return cb
}

func (cb *CarBuilder) Build() Car {
    return cb.car
}
```

### Factory Method

The Factory Method pattern creates objects without specifying the exact type. In Go, we use factory functions to initialize objects.

```go
package factory

type Product interface {
    Use() string
}

type ProductA struct{}

func (p ProductA) Use() string { return "Using Product A" }

type ProductB struct{}

func (p ProductB) Use() string { return "Using Product B" }

func NewProduct(name string) Product {
    if name == "A" {
        return ProductA{}
    } else if name == "B" {
        return ProductB{}
    }
    return nil
}
```

### Singleton

The Singleton pattern ensures a type has only one instance and provides a global point of access. In Go, this is commonly implemented using `sync.Once` to guarantee thread-safe initialization.

```go
package singleton

import "sync"

type Singleton struct{}

var instance *Singleton
var once sync.Once

func GetInstance() *Singleton {
    once.Do(func() {
        instance = &Singleton{}
    })
    return instance
}
```

## Structural Patterns

Structural patterns deal with relationships between entities, making code more modular and extensible.

### Adapter

The Adapter pattern makes two incompatible interfaces work together. In Go, interfaces and structs simplify adapter creation.

```go
package adapter

type LegacyPrinter interface {
    PrintLegacy() string
}

type ModernPrinter struct{}

func (mp *ModernPrinter) Print() string {
    return "Printing with Modern Printer"
}

type PrinterAdapter struct {
    printer *ModernPrinter
}

func (pa *PrinterAdapter) PrintLegacy() string {
    return pa.printer.Print()
}
```

### Decorator

The Decorator pattern dynamically adds behavior to an object. Go achieves this through composition rather than inheritance.

```go
package decorator

type Notifier interface {
    Send(message string) string
}

type EmailNotifier struct{}

func (e *EmailNotifier) Send(message string) string {
    return "Sending Email: " + message
}

type SMSDecorator struct {
    Notifier
}

func (s *SMSDecorator) Send(message string) string {
    return s.Notifier.Send(message) + " and SMS: " + message
}
```

### Proxy

The Proxy pattern controls access to another object. In Go, this is often used to add security or lazy-loading features.

```go
package proxy

type Server interface {
    FetchData() string
}

type RealServer struct{}

func (rs *RealServer) FetchData() string {
    return "Data from Real Server"
}

type ProxyServer struct {
    realServer *RealServer
}

func (ps *ProxyServer) FetchData() string {
    if ps.realServer == nil {
        ps.realServer = &RealServer{}
    }
    return ps.realServer.FetchData()
}
```

## Behavioral Patterns

Behavioral patterns focus on communication between objects, defining the responsibilities and behavior of objects.

### Command

The Command pattern encapsulates requests as objects, allowing them to be executed or stored. In Go, closures are often used instead of a formal Command pattern.

```go
package command

type Command interface {
    Execute() string
}

type PrintCommand struct {
    Message string
}

func (p *PrintCommand) Execute() string {
    return p.Message
}
```

### Observer

The Observer pattern establishes a one-to-many relationship between objects. In Go, observers can be implemented with slices of function references or structs.

```go
package observer

type Observer interface {
    Update(data string)
}

type Subject struct {
    observers []Observer
}

func (s *Subject) Register(o Observer) {
    s.observers = append(s.observers, o)
}

func (s *Subject) Notify(data string) {
    for _, o := range s.observers {
        o.Update(data)
    }
}
```

### Strategy

The Strategy pattern defines a family of algorithms, encapsulating each one and making them interchangeable. In Go, we use interfaces to represent strategies.

```go
package strategy

type Strategy interface {
    Execute(a, b int) int
}

type AddStrategy struct{}

func (AddStrategy) Execute(a, b int) int { return a + b }

type SubtractStrategy struct{}

func (SubtractStrategy) Execute(a, b int) int { return a - b }
```

## Go-Specific Patterns

In addition to traditional design patterns, Go has several unique patterns and idioms:

### Interface-Based Programming

Go encourages small, focused interfaces, making it easy to substitute components and achieve flexibility. This approach is sometimes referred to as "interface-based programming" and is a core principle in Go.

### Channel-Based Concurrency

Go’s concurrency model uses goroutines and channels, enabling powerful patterns for concurrent execution, such as the worker pool, fan-in, and fan-out patterns.

### Pipeline Pattern

The Pipeline pattern in Go chains goroutines to pass data from one to another using channels, allowing for efficient data processing.

```go
package main

import "fmt"

func gen(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        for _, n := range nums {
            out <- n
        }
        close(out)
    }()
    return out
}

func sq(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        for n := range in {
            out <- n * n
        }
        close(out)
    }()
    return out
}

func main() {
    for n := range sq(gen(2, 3, 4)) {
        fmt.Println(n) // Output: 4, 9, 16
    }
}
```

## External References

- [Singleton Pattern in Go](https://golangbyexample.com/singleton-design-pattern-go/)
- [Factory Pattern in Go](https://golangbyexample.com/factory-design-pattern-go/)
- [Go Builder Pattern](https://golangbyexample.com/builder-design-pattern-go/)
- [Adapter Pattern in Go](https://golangbyexample.com/adapter-design-pattern-go/)
- [Decorator Pattern in Go](https://golangbyexample.com/decorator-design-pattern-go/)
- [Proxy Pattern in Go](https://golangbyexample.com/proxy-design-pattern-go/)
- [Strategy Pattern in Go](https://golangbyexample.com/strategy-design-pattern-go/)
- [Observer Pattern in Go](https://golangbyexample.com/observer-design-pattern-go/)
- [Command Pattern in Go](https://golangbyexample.com/command-design-pattern-go/)
- [Interface Patterns in Go](https://golang.org/doc/effective_go.html#interfaces)
- [Concurrency Patterns in Go](https://gobyexample.com/channels)
- [Pipelines in Go](https://blog.golang.org/pipelines)

## Conclusion

Design patterns in Go are adapted to leverage the language’s strengths, focusing on simplicity and efficiency. Traditional design patterns often translate well with Go's focus on composition, interfaces, and concurrency. Understanding these patterns can help you write robust, idiomatic, and maintainable Go code.

For further exploration, here are additional resources:
- [Go Design Patterns Book](https://www.oreilly.com/library/view/go-design-patterns/9781786466204/)
- [Effective Go](https://golang.org/doc/effective_go.html)
- [Go by Example - Patterns](https://gobyexample.com/)

These resources will deepen your understanding of design patterns in Go and how to apply them in real-world scenarios.
