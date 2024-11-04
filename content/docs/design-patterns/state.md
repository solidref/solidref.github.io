---
title: 'State Pattern'
draft: false
bookHidden: true
---

# State Pattern

The **State** pattern is a behavioral design pattern that allows an object to alter its behavior when its internal state changes. It encapsulates state-specific behavior in separate classes and delegates state-dependent tasks to the current state object, promoting flexibility and modularity.

## Intent

**The main intent of the State pattern is to allow an object to change its behavior when its internal state changes, making the object appear to change its class.** This pattern eliminates the need for complex conditional logic by organizing state-specific behavior into distinct state classes.

## Problem and Solution

### Problem
Consider a document editor where a document can be in different states such as Draft, Moderation, and Published. Each state has its own behavior for actions like editing, approving, and publishing. Without the State pattern, you’d need multiple conditional checks to handle behavior based on the document’s current state, resulting in inflexible, hard-to-maintain code.

### Solution
The State pattern addresses this by encapsulating each state (Draft, Moderation, Published) in its own class that defines specific behavior for each action. The document delegates state-dependent behavior to the current state object, allowing seamless switching between states without complex conditionals.

## Structure

The State pattern typically includes:
1. **Context**: Maintains a reference to a state object and delegates behavior to it.
2. **State Interface**: Declares methods that all concrete states must implement.
3. **Concrete States**: Implement the state-specific behavior and manage transitions to other states as needed.

## UML Diagram

```
+------------------+       +---------------------+
|    Context       |       |      State          |
|------------------|       |---------------------|
| - state: State   |       | + handleRequest()   |
| + setState()     |       +---------------------+
| + request()      |                ^
+------------------+                |
         |                          |
         |            +------------------------+
         +----------->|    ConcreteStateA      |
                      |------------------------|
                      | + handleRequest()      |
                      +------------------------+
```

## Example: Document Workflow System

Let’s implement a document workflow system using the State pattern. The document can be in states like Draft, Moderation, and Published, each with specific behaviors for actions such as editing and publishing.

### Step 1: Define the State Interface

The `State` interface declares methods for actions that vary depending on the document’s state, such as `edit` and `publish`.

```java
// State Interface
interface State {
    void edit(Document document);
    void publish(Document document);
}
```

### Step 2: Implement Concrete States

Each concrete state class represents a specific state and defines its unique behavior for the actions. Additionally, each state manages transitions to other states.

```java
// Concrete State for Draft
class DraftState implements State {
    @Override
    public void edit(Document document) {
        System.out.println("Editing the draft document.");
    }

    @Override
    public void publish(Document document) {
        System.out.println("Moving document to moderation.");
        document.setState(new ModerationState());
    }
}

// Concrete State for Moderation
class ModerationState implements State {
    @Override
    public void edit(Document document) {
        System.out.println("Cannot edit document in moderation.");
    }

    @Override
    public void publish(Document document) {
        System.out.println("Publishing document.");
        document.setState(new PublishedState());
    }
}

// Concrete State for Published
class PublishedState implements State {
    @Override
    public void edit(Document document) {
        System.out.println("Cannot edit document once published.");
    }

    @Override
    public void publish(Document document) {
        System.out.println("Document is already published.");
    }
}
```

### Step 3: Implement the Context

The `Document` class is the context that delegates behavior to the current state object and provides a method to transition between states.

```java
// Context
class Document {
    private State state;

    public Document() {
        state = new DraftState();  // Default initial state
    }

    public void setState(State state) {
        this.state = state;
    }

    public void edit() {
        state.edit(this);
    }

    public void publish() {
        state.publish(this);
    }
}
```

### Step 4: Client Code Using the State Pattern

The client code interacts with the `Document` class, which delegates behavior to its current state. The document’s behavior changes dynamically based on its current state.

```java
public class Client {
    public static void main(String[] args) {
        Document document = new Document();

        // Initial state: Draft
        document.edit();       // Output: Editing the draft document.
        document.publish();     // Output: Moving document to moderation.

        // State changed to Moderation
        document.edit();       // Output: Cannot edit document in moderation.
        document.publish();     // Output: Publishing document.

        // State changed to Published
        document.edit();       // Output: Cannot edit document once published.
        document.publish();     // Output: Document is already published.
    }
}
```

### Output

```plaintext
Editing the draft document.
Moving document to moderation.
Cannot edit document in moderation.
Publishing document.
Cannot edit document once published.
Document is already published.
```

In this example:
- The `Document` class is the context, maintaining the current state and delegating behavior to it.
- `DraftState`, `ModerationState`, and `PublishedState` are concrete states that implement state-specific behavior.
- The client code interacts with `Document`, and its behavior changes dynamically based on the current state.

## Applicability

Use the State pattern when:
1. An object’s behavior depends on its state, and it needs to change behavior dynamically based on that state.
2. You have a complex conditional structure that determines the behavior of an object based on multiple states.
3. You want to make it easier to add or modify states without changing the context or adding complex conditionals.

## Advantages and Disadvantages

### Advantages
1. **Simplifies Code Structure**: The State pattern eliminates complex conditional logic by organizing behavior into state-specific classes.
2. **Promotes Single Responsibility**: Each state class focuses on specific behavior, making the code modular and easier to maintain.
3. **Easily Extensible**: New states can be added without modifying the context, following the Open-Closed Principle.

### Disadvantages
1. **Increased Class Count**: The pattern can lead to an increased number of classes, especially if there are many states.
2. **Potential Overhead**: For simple state transitions, the State pattern may add unnecessary complexity and overhead.
3. **Requires Careful State Management**: Incorrect handling of transitions can lead to unexpected behavior.

## Best Practices for Implementing the State Pattern

1. **Use the State Pattern for Complex Behavior**: The pattern is most effective when an object has complex state-dependent behavior. Avoid using it for simple cases with only a few state transitions.
2. **Encapsulate Transition Logic in States**: Allow state objects to manage transitions to other states to keep the context clean and focused on delegation.
3. **Apply When Modularity Is Required**: The State pattern promotes modularity, making it easier to manage and extend complex state-based behavior.

## Conclusion

The State pattern provides a flexible way to handle state-dependent behavior by encapsulating state-specific behavior in separate classes. This approach simplifies code by eliminating conditionals and enhances extensibility by allowing new states to be added without modifying the context.
