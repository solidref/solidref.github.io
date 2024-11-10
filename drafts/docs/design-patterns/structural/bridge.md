---
title: 'Bridge Pattern'
draft: false
bookHidden: true
---

# Bridge Pattern

The **Bridge** pattern is a structural design pattern that decouples an abstraction from its implementation, allowing both to vary independently. This pattern enables flexibility by creating two separate hierarchies: one for abstractions and another for implementations, with a bridge connecting them.

## Intent

**The main intent of the Bridge pattern is to separate an abstraction from its implementation so that the two can evolve independently.** This pattern is particularly useful when there are multiple ways to implement an abstraction, as it prevents tight coupling between the abstraction and its concrete implementations.

## Problem and Solution

### Problem
Suppose you are building a graphics rendering system that can render different types of shapes (e.g., Circle, Square) in different modes (e.g., Vector, Raster). Without the Bridge pattern, you would need to create a separate class for each combination of shape and rendering type (e.g., `VectorCircle`, `RasterCircle`, `VectorSquare`, `RasterSquare`). This can lead to a proliferation of classes that are difficult to maintain and extend.

### Solution
The Bridge pattern solves this problem by separating the Shape abstraction from the Rendering implementation. Each shape can hold a reference to a rendering object and delegate the rendering process to it. This way, adding a new rendering type or a new shape type only requires creating a new class in the appropriate hierarchy, rather than multiplying the combinations.

## Structure

The Bridge pattern typically includes:
1. **Abstraction**: Defines the high-level interface and holds a reference to an implementor.
2. **Refined Abstraction**: A subclass of the abstraction that adds specific functionality.
3. **Implementor**: Defines the interface for the implementation classes.
4. **Concrete Implementors**: Concrete classes that implement the implementor interface, providing specific implementations.

## UML Diagram

```
+-------------------+          +--------------------------+
|    Shape          |          |    Renderer              |
|-------------------|          |--------------------------|
| - renderer: Renderer |       | + renderCircle()         |
| + draw()          |          | + renderSquare()         |
+-------------------+          +--------------------------+
        ^                              ^
        |                              |
+---------------+             +-----------------------+
|  Circle       |             |    VectorRenderer     |
+---------------+             +-----------------------+
| + draw()      |             | + renderCircle()      |
+---------------+             | + renderSquare()      |
                               +-----------------------+
```

## Example: Shape Rendering System

Let’s implement a shape rendering system using the Bridge pattern. We’ll separate the shape abstraction from the rendering implementation, enabling different types of shapes to be rendered in various ways (e.g., Vector or Raster).

### Step 1: Define the Implementor Interface

The `Renderer` interface defines the methods that concrete rendering classes must implement. These methods perform the actual rendering work.

```java
// Implementor Interface
interface Renderer {
    void renderCircle(int radius);
    void renderSquare(int side);
}
```

### Step 2: Implement Concrete Implementors

Each concrete implementor provides a specific rendering method (e.g., Vector rendering or Raster rendering).

```java
// Concrete Implementor for Vector Rendering
class VectorRenderer implements Renderer {
    public void renderCircle(int radius) {
        System.out.println("Rendering circle in vector mode with radius " + radius);
    }

    public void renderSquare(int side) {
        System.out.println("Rendering square in vector mode with side " + side);
    }
}

// Concrete Implementor for Raster Rendering
class RasterRenderer implements Renderer {
    public void renderCircle(int radius) {
        System.out.println("Rendering circle in raster mode with radius " + radius);
    }

    public void renderSquare(int side) {
        System.out.println("Rendering square in raster mode with side " + side);
    }
}
```

### Step 3: Define the Abstraction

The `Shape` abstraction holds a reference to a `Renderer` object, which is used to delegate the rendering work. This decouples `Shape` from the specific rendering implementations.

```java
// Abstraction
abstract class Shape {
    protected Renderer renderer;

    public Shape(Renderer renderer) {
        this.renderer = renderer;
    }

    public abstract void draw();
}
```

### Step 4: Implement Refined Abstractions

Each concrete shape (e.g., `Circle`, `Square`) extends `Shape` and uses the renderer to perform the drawing.

```java
// Refined Abstraction for Circle
class Circle extends Shape {
    private int radius;

    public Circle(Renderer renderer, int radius) {
        super(renderer);
        this.radius = radius;
    }

    public void draw() {
        renderer.renderCircle(radius);
    }
}

// Refined Abstraction for Square
class Square extends Shape {
    private int side;

    public Square(Renderer renderer, int side) {
        super(renderer);
        this.side = side;
    }

    public void draw() {
        renderer.renderSquare(side);
    }
}
```

### Step 5: Client Code Using the Bridge

The client code can create any shape with any renderer, enabling flexible combinations without modifying existing classes.

```java
public class Client {
    public static void main(String[] args) {
        Renderer vectorRenderer = new VectorRenderer();
        Renderer rasterRenderer = new RasterRenderer();

        Shape circle = new Circle(vectorRenderer, 5);
        Shape square = new Square(rasterRenderer, 10);

        circle.draw();  // Output: Rendering circle in vector mode with radius 5
        square.draw();  // Output: Rendering square in raster mode with side 10
    }
}
```

### Explanation
In this example:
- The `Shape` class is the abstraction, while `Circle` and `Square` are refined abstractions.
- `Renderer` is the implementor interface, and `VectorRenderer` and `RasterRenderer` are concrete implementors.
- The `draw` method in `Shape` calls the rendering methods in `Renderer`, allowing `Shape` to vary independently of its rendering implementation.

## Applicability

Use the Bridge pattern when:
1. You need to separate an abstraction from its implementation to allow both to vary independently.
2. You have multiple hierarchies (e.g., shapes and rendering methods) that you want to manage without creating a class for each combination.
3. You want to avoid a "class explosion" where too many concrete classes are created to handle all combinations of abstractions and implementations.

## Advantages and Disadvantages

### Advantages
1. **Enhanced Flexibility**: The Bridge pattern decouples abstraction from implementation, making it easier to modify or extend each independently.
2. **Reduced Class Explosion**: The pattern prevents the proliferation of classes, which would occur if each abstraction had to implement every possible implementation.
3. **Improved Scalability**: New abstractions and implementations can be added independently, allowing the system to grow without major modifications.

### Disadvantages
1. **Increased Complexity**: The Bridge pattern introduces additional classes, which may add complexity, especially for simpler systems.
2. **Not Always Necessary**: For scenarios where abstraction and implementation do not need to vary independently, the Bridge pattern may be overkill.

## Best Practices for Implementing the Bridge Pattern

1. **Use Composition Over Inheritance**: The Bridge pattern emphasizes composition, with abstractions containing references to implementations, rather than using inheritance.
2. **Identify Independent Hierarchies**: Ensure that the abstraction and implementation are truly independent and likely to vary separately before applying the Bridge pattern.
3. **Limit Complexity in Simple Cases**: If abstraction and implementation do not vary frequently, consider simpler solutions to avoid overengineering.

## Conclusion

The Bridge pattern provides a structured way to separate abstraction from implementation, enhancing modularity and scalability. By decoupling the two hierarchies, this pattern enables flexible combinations and minimizes dependencies, making it easier to adapt the system to new requirements.
