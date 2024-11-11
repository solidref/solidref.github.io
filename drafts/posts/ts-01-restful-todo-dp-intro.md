# A TypeScript RESTful API Using Design Patterns

## Introduction

**Design patterns** represent foundational approaches to recurring challenges in software architecture. They encapsulate best practices in object-oriented design, providing flexible, adaptable templates that developers can apply to construct robust, maintainable, and scalable systems. By adhering to established, reusable strategies, design patterns facilitate problem-solving in complex software environments and contribute to systematic, reliable development practices.

### The Significance of Design Patterns

The application of design patterns offers multiple, distinct advantages within the software development lifecycle:

- **Enhancement of Reusability**: By encapsulating well-documented, field-tested solutions, design patterns encourage reuse across diverse projects and domains, reducing development time and improving consistency in codebases.

- **Improved Communication and Collaboration**: Design patterns introduce a shared vocabulary among developers, fostering more effective discourse on structural and behavioral approaches, thereby aligning team efforts and bridging understanding across diverse expertise levels.

- **Reinforcement of Design Principles**: Design patterns inherently support principles of modularity, decoupling, and encapsulation, promoting systematic, principle-driven design choices that ensure code quality and stability.

- **Facilitation of System Flexibility and Extensibility**: Many design patterns are constructed to accommodate modifications and extensions, thus enabling systems to evolve gracefully as requirements shift or expand, reducing the potential for disruption and technical debt.

## Building a RESTful API with TypeScript Using Design Patterns

To showcase the practical application of design patterns, I’ll develop a simple RESTful API—a **Todo List Service**. Despite its simplicity, this problem can be incrementally enhanced to illustrate various design patterns effectively, making it an excellent foundation for exploring pattern-based architecture in a manageable and comprehensible way.

The initial implementation of the Todo List Service will prioritize simplicity, establishing a basic working API. We’ll then progressively apply design patterns to enhance the structure, flexibility, and maintainability of the code, demonstrating how each pattern contributes to solving specific architectural challenges.

## Initial Implementation

In this section, we’ll outline the foundational project setup and code structure. Starting with a straightforward implementation will allow us to focus on incremental enhancements using design patterns in subsequent sections.

### Project Structure

The initial project will be organized as follows:

```
.
├── LICENSE
├── package-lock.json
├── package.json
├── src
│   ├── actions.ts
│   ├── database.ts
│   ├── index.ts
│   └── models
│       ├── ErrorResponse.ts
│       ├── Task.ts
│       └── TaskStatus.ts
├── swagger.yaml
└── test.sh
```

- **`Task`**: The core model representing a task in the todo list.
- **`ErrorResponse`**: A utility model for handling error responses consistently.
- **`TaskStatus`**: An enumeration defining various states a task may have, providing structured task management.
- **`database`**: A simple, in-memory data store to persist tasks temporarily during development.
- **`actions`**: Defines mappings between API endpoints and core logic, facilitating modular and testable code.

The structure above provides a foundation that we can expand as we incorporate design patterns.

### Project Initialization

To begin, initialize the project directory, install dependencies, and configure TypeScript support:

```bash
mkdir todo-restful-dp
cd todo-restful-dp
npm init

npm install -i @types/express @types/uuid express uuid
```

### Using Bun.sh to Run TypeScript

For this project, I opted to use [Bun](https://bun.sh/) as a TypeScript runtime. Although Node.js 22 now supports TypeScript with the `--experimental-strip-types` flag, it remains prone to issues, especially when managing CommonJS modules. Bun provides a reliable alternative to ensure the code runs smoothly without compromising on compatibility.

To configure the project to run with Bun, modify the `start` script in `package.json` as follows:

```json
{
  "name": "typescript-todo-restful-dp",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "bun ./src/index.ts",
  // ...
}
```

This foundational setup prepares us to implement a basic API and explore design patterns through targeted enhancements, ultimately illustrating their advantages within a TypeScript-based RESTful service.

## Down to coding

### Task Model

```typescript
import TaskStatus from "./TaskStatus";

type Task = {
  id: string;
  title: string;
  description: string;
  status: TaskStatus;
  createdAt: number;
  updatedAt: number;
};

export default Task;
```

### TaskStatus Enum

```typescript
enum TaskStatus {
  Pending,
  InProgress,
  Completed,
}

export default TaskStatus;
```

### ErrorResponse Model

```typescript
type ErrorResponse = {
  code: number;
  message: string;
};

export default ErrorResponse;
```

### Database

```typescript
import Task from "./models/task";

export default class Database {
  private tasks: Task[] = [];

  addTask(task: Task): void {
    this.tasks.push(task);
  }

  getTasks(): Task[] {
    return this.tasks;
  }

  getTaskById(id: string): Task | null {
    return this.tasks.find((task) => task.id === id) ?? null;
  }

  updateTask(id: string, updatedTask: Task): Task | null {
    const index = this.tasks.findIndex((task) => task.id === id);
    if (index !== -1) {
      this.tasks[index] = {
        ...this.tasks[index],
        ...updatedTask,
      };
      return this.tasks[index];
    }
    return null;
  }

  deleteTask(id: string): void {
    this.tasks = this.tasks.filter((task) => task.id !== id);
  }
}
```

### Actions & Service

```typescript
import { NextFunction, Request, Response } from "express";
import Database from "./database";
import Task from "./models/task";
import { v4 as uuid } from "uuid";

const database = new Database();

export const addTask = (req: Request, res: Response, next: NextFunction) => {
  const task = req.body as Task;
  task.id = uuid();
  console.log("Adding task:", task);
  database.addTask(task);
  res.status(201).send("");
};

export const deleteTask = (req: Request, res: Response) => {
  const task = database.getTaskById(req.params.id);
  if (task) {
    database.deleteTask(req.params.id);
    res.status(204).send("");
    return;
  }
  res.status(404).send(
    JSON.stringify({
      code: 404,
      message: "Task not found",
    })
  );
};

export const getTasks = (req: Request, res: Response) => {
  res.status(200).send(JSON.stringify(database.getTasks()));
};

export const getTaskById = (req: Request, res: Response) => {
  console.log("Getting task::", req.params.id);
  const task = database.getTaskById(req.params.id);
  if (task) {
    res.status(200).send(JSON.stringify(task));
    return;
  }
  res.status(404).send(
    JSON.stringify({
      code: 404,
      message: "Task not found",
    })
  );
};

export const updateTask = (req: Request, res: Response) => {
  let task = database.getTaskById(req.params.id);
  if (task) {
    task = database.updateTask(req.params.id, req.body as Task);
    res.status(200).send(JSON.stringify(task));
    return;
  }
  res.status(404).send(
    JSON.stringify({
      code: 404,
      message: "Task not found",
    })
  );
};
```

```typescript
import express, { Request, Response } from "express";
import {
  addTask,
  deleteTask,
  getTaskById,
  getTasks,
  updateTask,
} from "./actions";

const app = express();

app.use(express.json());

app.delete("/task/:id", deleteTask);

app.get("/tasks", getTasks);
app.get("/task/:id", getTaskById);

app.post("/task", addTask);

app.put("/task/:id", updateTask);

app.listen(8080, () => {
  console.log("Server is running on port 8080");
});
```















<!-- ## Types of Design Patterns

Design patterns are generally classified into three main categories: **Creational**, **Structural**, and **Behavioral**. Each category addresses different types of design challenges and offers patterns suited to solving specific problems.

### 1. Creational Patterns

Creational patterns deal with object creation mechanisms, aiming to increase flexibility and reuse of code. They help ensure that objects are created in a manner suitable to the situation, avoiding tight coupling and increasing code modularity.

- **[Abstract Factory](/design-patterns/creational/abstract-factory)**: Provides an interface for creating families of related or dependent objects without specifying their concrete classes.
- **[Builder](/design-patterns/creational/builder)**: Separates the construction of a complex object from its representation, allowing different representations to be created.
- **[Factory Method](/design-patterns/creational/factory-method)**: Defines an interface for creating an object but lets subclasses alter the type of object that will be created.
- **[Prototype](/design-patterns/creational/prototype)**: Creates new objects by copying an existing object, making it easy to duplicate complex objects.
- **[Singleton](/design-patterns/creational/singleton)**: Ensures a class has only one instance and provides a global point of access to it.

### 2. Structural Patterns

Structural patterns focus on composing classes and objects to form larger structures, facilitating the creation of flexible and scalable code. These patterns help establish relationships between entities, making it easier to implement new functionality without changing the existing code.

- **[Adapter](/design-patterns/structural/adapter)**: Converts the interface of a class into another interface clients expect, allowing incompatible interfaces to work together.
- **[Bridge](/design-patterns/structural/bridge)**: Decouples an abstraction from its implementation so that the two can vary independently.
- **[Composite](/design-patterns/structural/composite)**: Composes objects into tree structures to represent part-whole hierarchies, enabling clients to treat individual objects and compositions uniformly.
- **[Decorator](/design-patterns/structural/decorator)**: Adds responsibilities to an object dynamically, providing an alternative to subclassing.
- **[Facade](/design-patterns/structural/facade)**: Provides a simplified interface to a complex subsystem, making it easier to use.
- **[Flyweight](/design-patterns/structural/flyweight)**: Reduces memory usage by sharing as much data as possible with similar objects.
- **[Proxy](/design-patterns/structural/proxy)**: Provides a surrogate or placeholder for another object to control access to it.

### 3. Behavioral Patterns

Behavioral patterns deal with object interactions and responsibilities, defining ways for objects to communicate and interact while keeping the code flexible and scalable. These patterns focus on algorithms, delegation, and the distribution of responsibility.

- **[Chain of Responsibility](/design-patterns/behavioral/chain-of-responsibility)**: Passes a request along a chain of handlers, allowing each handler to process or pass it to the next handler in the chain.
- **[Command](/design-patterns/behavioral/command)**: Encapsulates a request as an object, thereby allowing for parameterization of clients with queues, requests, and operations.
- **[Iterator](/design-patterns/behavioral/iterator)**: Provides a way to access elements of a collection sequentially without exposing its underlying representation.
- **[Mediator](/design-patterns/behavioral/mediator)**: Defines an object that encapsulates how a set of objects interact, reducing the complexity of many-to-many communication.
- **[Memento](/design-patterns/behavioral/memento)**: Captures and externalizes an object’s internal state so that it can be restored later, without violating encapsulation.
- **[Observer](/design-patterns/behavioral/observer)**: Defines a one-to-many dependency between objects, so that when one object changes state, all dependents are notified and updated.
- **[State](/design-patterns/behavioral/state)**: Allows an object to alter its behavior when its internal state changes, appearing as if it changes class.
- **[Strategy](/design-patterns/behavioral/strategy)**: Defines a family of algorithms, encapsulates each one, and makes them interchangeable to let the algorithm vary independently from clients.
- **[Template Method](/design-patterns/behavioral/template-method)**: Defines the skeleton of an algorithm, letting subclasses override specific steps without changing its structure.
- **[Visitor](/design-patterns/behavioral/visitor)**: Represents an operation to be performed on elements of an object structure, allowing for new operations to be added without changing the classes of the elements.

## How to Use This Section

Each design pattern page provides:
- **Description**: An overview of the pattern’s purpose and problem-solving approach.
- **Example Code**: Sample implementations to illustrate how the pattern works.
- **Applicability**: Situations where the pattern is most useful.
- **Advantages and Disadvantages**: Key benefits and trade-offs associated with each pattern.

Understanding and using design patterns can greatly improve the design and structure of your code, making it more adaptable, reusable, and maintainable. -->
