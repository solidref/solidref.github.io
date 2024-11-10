**Implementation of `Command` Interface (Command Pattern)**

---

**Purpose of `Command` Interface:**

The `Command` interface serves as the foundation of the **Command Pattern**, which encapsulates a request or action as an object. This allows for parameterization of clients with different requests, queuing of requests, and providing log and undo functionality. In the context of our task management application, the `Command` interface standardizes the execution of various task operations, such as creating, updating, and deleting tasks.

---

**Command Pattern Overview:**

- **Intent:** Encapsulate a request as an object, thereby allowing clients to be parameterized with different requests.
- **Participants:**
  - **Command:** Declares an interface for executing an operation.
  - **ConcreteCommand:** Implements the `Command` interface and defines a binding between a Receiver and an action.
  - **Receiver:** Knows how to perform the operations associated with carrying out a request.
  - **Invoker:** Asks the command to carry out the request.
  - **Client:** Creates a ConcreteCommand object and sets its receiver.

---

**1. `Command` Interface:**

```java
public interface Command {
    void execute();
}
```

- **Purpose:**
  - Declares the `execute` method that all concrete command classes must implement.
  - Provides a standard interface for executing commands.

---

**Explanation:**

- **Encapsulation of Actions:**
  - By defining an interface with an `execute` method, we encapsulate the action to be performed within a command object.
  - This allows us to treat all commands uniformly, regardless of their specific operations.

- **Standardization:**
  - The `Command` interface standardizes how commands are executed, making it easier to manage and invoke them within the application.

- **Extensibility:**
  - New commands can be added by implementing the `Command` interface without modifying existing code.

---

**Usage in the Application:**

In our task management application, we can use the `Command` interface to encapsulate various task operations, such as:

- **CreateTaskCommand**
- **UpdateTaskCommand**
- **DeleteTaskCommand**
- **ChangeStateCommand**
- **AssignTaskCommand**

Each of these commands will implement the `Command` interface and provide their specific implementation of the `execute` method.

---

**Example Implementation:**

**`CreateTaskCommand`:**

```java
public class CreateTaskCommand implements Command {
    private TaskManager taskManager;
    private Task task;

    public CreateTaskCommand(TaskManager taskManager, Task task) {
        this.taskManager = taskManager;
        this.task = task;
    }

    @Override
    public void execute() {
        taskManager.createTask(task);
    }
}
```

- **Explanation:**
  - **Fields:**
    - `taskManager`: The receiver that knows how to perform the actual operation.
    - `task`: The task to be created.
  - **Constructor:**
    - Initializes the command with the receiver and the task.
  - **`execute` Method:**
    - Calls the `createTask` method on the `taskManager`, performing the action.

---

**`TaskManager` (Receiver):**

```java
public class TaskManager {
    private DatabaseOperations dbAdapter;

    public TaskManager(DatabaseOperations dbAdapter) {
        this.dbAdapter = dbAdapter;
    }

    public void createTask(Task task) {
        dbAdapter.saveTask(task);
    }

    // Other task-related operations...
}
```

- **Purpose:**
  - Acts as the receiver that knows how to carry out the requests.
  - Provides methods for task operations such as creating, updating, and deleting tasks.

---

**Invoker (Could be `TaskRequestHandler` or another class):**

```java
public class CommandInvoker {
    public void executeCommand(Command command) {
        command.execute();
    }
}
```

- **Purpose:**
  - Calls the `execute` method on the command.
  - Decouples the invoker from the concrete command classes.

---

**Client Code Example:**

```java
// Client code in TaskRequestHandler
public class TaskRequestHandler extends RequestHandler {
    private TaskManager taskManager;
    private CommandInvoker invoker;

    public TaskRequestHandler(DatabaseOperations dbAdapter) {
        super(dbAdapter);
        this.taskManager = new TaskManager(dbAdapter);
        this.invoker = new CommandInvoker();
    }

    private ResponseData handlePost(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            // Parse the request body and create a Task object
            JSONObject jsonBody = new JSONObject(requestData.getBody());
            Task task = taskFactory.createTask(jsonBody);

            // Create the command
            Command createCommand = new CreateTaskCommand(taskManager, task);

            // Execute the command via the invoker
            invoker.executeCommand(createCommand);

            // Prepare the response
            responseData.setStatusCode(201);
            responseData.setData(task.toJson().toString());

        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }
}
```

- **Explanation:**
  - **Client (TaskRequestHandler):**
    - Creates a `CreateTaskCommand` with the necessary parameters.
    - Uses the `CommandInvoker` to execute the command.
  - **Decoupling:**
    - The handler does not need to know the details of how the task is created.
    - The command encapsulates the action and its execution.

---

**Advantages of Using the Command Pattern:**

1. **Decoupling Invoker and Receiver:**
  - The invoker (`CommandInvoker`) does not need to know the specifics of the action or the receiver (`TaskManager`).
  - Promotes loose coupling in the application architecture.

2. **Extensibility:**
  - New commands can be added without changing existing code.
  - The system is open for extension but closed for modification.

3. **Support for Undo/Redo:**
  - Commands can be stored and reversed, enabling undo/redo functionality.
  - Each command can provide an `unexecute` method for undo operations.

4. **Queuing and Scheduling:**
  - Commands can be queued, logged, or scheduled for execution.
  - Facilitates asynchronous or delayed execution.

---

**Extending the `Command` Interface for Undo Functionality:**

If we need undo capabilities, we can extend the `Command` interface:

```java
public interface Command {
    void execute();
    void unexecute();
}
```

- **Explanation:**
  - The `unexecute` method allows the command to reverse its action.
  - Commands implementing this interface can provide the logic to undo the operation.

---

**Implementing `UpdateTaskCommand` with Undo:**

```java
public class UpdateTaskCommand implements Command {
    private TaskManager taskManager;
    private Task oldTask;
    private Task newTask;

    public UpdateTaskCommand(TaskManager taskManager, Task oldTask, Task newTask) {
        this.taskManager = taskManager;
        this.oldTask = oldTask.clone(); // Save old state
        this.newTask = newTask;
    }

    @Override
    public void execute() {
        taskManager.updateTask(newTask);
    }

    @Override
    public void unexecute() {
        taskManager.updateTask(oldTask);
    }
}
```

- **Explanation:**
  - **Fields:**
    - `oldTask`: The state of the task before the update.
    - `newTask`: The updated task data.
  - **`execute` Method:**
    - Updates the task with new data.
  - **`unexecute` Method:**
    - Restores the task to its previous state.

---

**Command History and Undo Manager:**

We can implement an `UndoManager` that keeps track of executed commands:

```java
import java.util.Stack;

public class UndoManager {
    private Stack<Command> undoStack = new Stack<>();
    private Stack<Command> redoStack = new Stack<>();

    public void executeCommand(Command command) {
        command.execute();
        undoStack.push(command);
        redoStack.clear(); // Clear redo stack after new command
    }

    public void undo() {
        if (!undoStack.isEmpty()) {
            Command command = undoStack.pop();
            if (command instanceof UndoableCommand) {
                ((UndoableCommand) command).unexecute();
                redoStack.push(command);
            }
        } else {
            System.out.println("Nothing to undo.");
        }
    }

    public void redo() {
        if (!redoStack.isEmpty()) {
            Command command = redoStack.pop();
            command.execute();
            undoStack.push(command);
        } else {
            System.out.println("Nothing to redo.");
        }
    }
}
```

- **Explanation:**
  - **Stacks:**
    - `undoStack`: Stores commands that can be undone.
    - `redoStack`: Stores commands that can be redone.
  - **Methods:**
    - `executeCommand`: Executes a command and adds it to the undo stack.
    - `undo`: Unexecutes the last command.
    - `redo`: Re-executes the last undone command.

---

**Implementing `UndoableCommand` Interface:**

Alternatively, we can create a separate interface for commands that support undo:

```java
public interface UndoableCommand extends Command {
    void unexecute();
}
```

- **Explanation:**
  - Commands that can be undone implement `UndoableCommand`.
  - Allows the `UndoManager` to check if a command supports undo functionality.

---

**Conclusion:**

By implementing the `Command` interface, we establish a standardized way to encapsulate task operations as objects. This design provides several benefits:

- **Standardization:** All commands conform to a common interface, simplifying execution and management.
- **Decoupling:** Separates the invoker from the receiver and the specifics of the command execution.
- **Extensibility:** Easily add new commands without altering existing code.
- **Enhanced Functionality:** Supports advanced features like undo/redo, command scheduling, and logging.

This implementation of the **Command Pattern** enhances the modularity and flexibility of our task management application, allowing for scalable and maintainable code.

---

**Next Steps:**

Now that we have set the base for the `Command` interface and understand its role, we can proceed to:

1. **Define Concrete Command Classes:**
  - Implement specific commands for various task operations.
  - Ensure each command encapsulates the necessary data and logic.

2. **Implement an Invoker:**
  - Decide where commands will be executed (e.g., within the request handler, service layer, or a dedicated invoker).
  - Manage command execution and history if needed.

3. **Integrate with the Application:**
  - Modify existing code to use commands for task operations.
  - Update the `TaskRequestHandler` to create and execute commands based on HTTP requests.

4. **Handle Undo/Redo (Optional):**
  - Implement undo functionality if required by the application.
  - Use the `UndoManager` or similar mechanism to manage command history.

---

**Looking Forward:**

By establishing the `Command` interface and understanding its application, we are well-prepared to implement the list of commands you will provide. Each command will:

- Encapsulate a specific task operation.
- Implement the `execute` method (and `unexecute` if undo functionality is needed).
- Interact with the `TaskManager` or appropriate receiver to perform the action.

Feel free to provide the command list, and we can proceed with their implementation and integration into the application.

--------------------

**Implementation of `AddTaskCommand`, `DeleteTaskCommand`, `UpdateTaskCommand` (Command Implementations)**

---

**Purpose:**

The `AddTaskCommand`, `DeleteTaskCommand`, and `UpdateTaskCommand` classes are concrete implementations of the `Command` interface in the **Command Pattern**. These classes encapsulate specific task operations as objects, allowing for uniform execution, easier management, and potential support for undo/redo functionality.

---

**1. `AddTaskCommand`**

**Implementation:**

```java
public class AddTaskCommand implements Command {
    private TaskManager taskManager;
    private Task task;

    public AddTaskCommand(TaskManager taskManager, Task task) {
        this.taskManager = taskManager;
        this.task = task;
    }

    @Override
    public void execute() {
        taskManager.createTask(task);
    }

    @Override
    public void unexecute() {
        taskManager.deleteTask(task.getId());
    }
}
```

**Explanation:**

- **Fields:**
  - `taskManager`: The receiver responsible for performing task operations.
  - `task`: The `Task` object to be added.
- **Constructor:**
  - Initializes the command with the `taskManager` and the `task` to be added.
- **`execute()` Method:**
  - Calls `createTask` on the `taskManager` to add the task to the system.
- **`unexecute()` Method:**
  - Calls `deleteTask` on the `taskManager` to remove the task, effectively undoing the addition.

**Usage Example:**

```java
Task newTask = new TaskBuilder("New Task")
    .setDescription("Description of the new task")
    .build();

Command addTaskCommand = new AddTaskCommand(taskManager, newTask);
undoManager.executeCommand(addTaskCommand);
```

---

**2. `DeleteTaskCommand`**

**Implementation:**

```java
public class DeleteTaskCommand implements Command {
    private TaskManager taskManager;
    private Task task;

    public DeleteTaskCommand(TaskManager taskManager, UUID taskId) {
        this.taskManager = taskManager;
        this.task = taskManager.getTask(taskId).clone(); // Save the current state
    }

    @Override
    public void execute() {
        taskManager.deleteTask(task.getId());
    }

    @Override
    public void unexecute() {
        taskManager.createTask(task);
    }
}
```

**Explanation:**

- **Fields:**
  - `taskManager`: The receiver responsible for task operations.
  - `task`: The `Task` object to be deleted, cloned to preserve its state.
- **Constructor:**
  - Initializes the command with the `taskManager` and the ID of the task to delete.
  - Retrieves and clones the task to preserve its state for undo operations.
- **`execute()` Method:**
  - Calls `deleteTask` on the `taskManager` to remove the task from the system.
- **`unexecute()` Method:**
  - Calls `createTask` on the `taskManager` to restore the deleted task.

**Usage Example:**

```java
UUID taskIdToDelete = existingTask.getId();
Command deleteTaskCommand = new DeleteTaskCommand(taskManager, taskIdToDelete);
undoManager.executeCommand(deleteTaskCommand);
```

---

**3. `UpdateTaskCommand`**

**Implementation:**

```java
public class UpdateTaskCommand implements Command {
    private TaskManager taskManager;
    private Task oldTask;
    private Task newTask;

    public UpdateTaskCommand(TaskManager taskManager, Task newTask) {
        this.taskManager = taskManager;
        this.newTask = newTask;
        this.oldTask = taskManager.getTask(newTask.getId()).clone(); // Save old state
    }

    @Override
    public void execute() {
        taskManager.updateTask(newTask);
    }

    @Override
    public void unexecute() {
        taskManager.updateTask(oldTask);
    }
}
```

**Explanation:**

- **Fields:**
  - `taskManager`: The receiver responsible for task operations.
  - `newTask`: The `Task` object containing updated information.
  - `oldTask`: A clone of the existing task before the update, used for undo operations.
- **Constructor:**
  - Initializes the command with the `taskManager` and the updated `newTask`.
  - Retrieves and clones the existing task to save its previous state.
- **`execute()` Method:**
  - Calls `updateTask` on the `taskManager` to apply the updates.
- **`unexecute()` Method:**
  - Calls `updateTask` on the `taskManager` to revert to the original task state.

**Usage Example:**

```java
Task updatedTask = existingTask.clone();
updatedTask.setDescription("Updated description");

Command updateTaskCommand = new UpdateTaskCommand(taskManager, updatedTask);
undoManager.executeCommand(updateTaskCommand);
```

---

**Integration into the Application:**

**1. `TaskManager` (Receiver):**

```java
public class TaskManager {
    private DatabaseOperations dbAdapter;

    public TaskManager(DatabaseOperations dbAdapter) {
        this.dbAdapter = dbAdapter;
    }

    public void createTask(Task task) {
        dbAdapter.saveTask(task);
    }

    public void updateTask(Task task) {
        dbAdapter.updateTask(task);
    }

    public void deleteTask(UUID taskId) {
        dbAdapter.deleteTask(taskId);
    }

    public Task getTask(UUID taskId) {
        return dbAdapter.getTask(taskId);
    }
}
```

- **Purpose:**
  - Provides methods for task operations.
  - Acts as the receiver in the Command Pattern, executing the actual business logic.

**2. `UndoManager` (Invoker):**

```java
public class UndoManager {
    private Stack<Command> undoStack = new Stack<>();
    private Stack<Command> redoStack = new Stack<>();

    public void executeCommand(Command command) {
        command.execute();
        undoStack.push(command);
        redoStack.clear(); // Clear redo stack after a new command
    }

    public void undo() {
        if (!undoStack.isEmpty()) {
            Command command = undoStack.pop();
            command.unexecute();
            redoStack.push(command);
        } else {
            System.out.println("Nothing to undo.");
        }
    }

    public void redo() {
        if (!redoStack.isEmpty()) {
            Command command = redoStack.pop();
            command.execute();
            undoStack.push(command);
        } else {
            System.out.println("Nothing to redo.");
        }
    }
}
```

- **Purpose:**
  - Manages command execution and provides undo/redo functionality.
  - Stores executed commands to enable reversal of actions.

**3. Integration with `TaskRequestHandler`:**

```java
public class TaskRequestHandler extends RequestHandler {
    private TaskFactory taskFactory;
    private TaskManager taskManager;
    private UndoManager undoManager;

    public TaskRequestHandler(DatabaseOperations dbAdapter) {
        super(dbAdapter);
        this.taskFactory = new ConcreteTaskFactory();
        this.taskManager = new TaskManager(dbAdapter);
        this.undoManager = new UndoManager();
    }

    // Handle POST request to add a new task
    private ResponseData handlePost(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            JSONObject jsonBody = new JSONObject(requestData.getBody());
            Task task = taskFactory.createTask(jsonBody);

            Command addTaskCommand = new AddTaskCommand(taskManager, task);
            undoManager.executeCommand(addTaskCommand);

            responseData.setStatusCode(201);
            responseData.setData(task.toJson().toString());
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Handle PUT request to update a task
    private ResponseData handlePut(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            Task existingTask = taskManager.getTask(taskId);

            JSONObject jsonBody = new JSONObject(requestData.getBody());
            Task updatedTask = taskFactory.createTask(jsonBody);
            updatedTask.setId(taskId);

            Command updateTaskCommand = new UpdateTaskCommand(taskManager, updatedTask);
            undoManager.executeCommand(updateTaskCommand);

            responseData.setStatusCode(200);
            responseData.setData(updatedTask.toJson().toString());
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Handle DELETE request to delete a task
    private ResponseData handleDelete(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            Command deleteTaskCommand = new DeleteTaskCommand(taskManager, taskId);
            undoManager.executeCommand(deleteTaskCommand);

            responseData.setStatusCode(200);
            responseData.setData("Task deleted successfully.");
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Methods to handle undo and redo actions
    private ResponseData handleUndo(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            undoManager.undo();
            responseData.setStatusCode(200);
            responseData.setData("Undo successful.");
        } catch (Exception e) {
            responseData.setStatusCode(400);
            responseData.setData("Nothing to undo.");
        }
        return responseData;
    }

    private ResponseData handleRedo(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            undoManager.redo();
            responseData.setStatusCode(200);
            responseData.setData("Redo successful.");
        } catch (Exception e) {
            responseData.setStatusCode(400);
            responseData.setData("Nothing to redo.");
        }
        return responseData;
    }
}
```

- **Explanation:**
  - **Adding a Task:**
    - Parses the request, creates a `Task`, and wraps it in an `AddTaskCommand`.
    - Executes the command via the `UndoManager`.
  - **Updating a Task:**
    - Retrieves the existing task and updates it with new data.
    - Creates an `UpdateTaskCommand` and executes it.
  - **Deleting a Task:**
    - Creates a `DeleteTaskCommand` with the task ID and executes it.
  - **Undo/Redo Operations:**
    - Provides endpoints to undo and redo actions using the `UndoManager`.

---

**Benefits of Using Command Implementations:**

1. **Uniform Execution:**

  - All commands implement the same interface, making it easy to execute and manage them uniformly.

2. **Decoupling:**

  - Separates the object that invokes the operation (`TaskRequestHandler`) from the one that knows how to perform it (`TaskManager`).

3. **Undo/Redo Functionality:**

  - Commands store the necessary state to undo and redo operations, enhancing the user experience.

4. **Extensibility:**

  - New commands can be added without altering existing code, adhering to the Open/Closed Principle.

5. **Logging and Auditing:**

  - Commands can be logged or stored for auditing purposes, providing a history of actions.

---

**Considerations:**

1. **State Preservation:**

  - Cloning tasks before modifications ensures that the original state is preserved for undo operations.

2. **Memory Usage:**

  - Storing clones of objects can increase memory usage. Implement strategies to manage memory effectively, such as limiting the undo stack size.

3. **Thread Safety:**

  - If the application is multi-threaded, ensure that access to shared resources like the `UndoManager` and `TaskManager` is synchronized.

4. **Error Handling:**

  - Commands should handle exceptions gracefully, ensuring that the system remains consistent in case of failures.

5. **Atomicity:**

  - Operations should be atomic to prevent partial updates, especially important in undo/redo scenarios.

---

**Extending Functionality:**

- **Additional Commands:**

  - **ChangeTaskStateCommand:** To change the state of a task (e.g., from "New" to "In Progress").
  - **AssignTaskCommand:** To assign a task to a user.
  - **CompositeCommand:** To execute multiple commands as a single operation.

- **Macro Commands:**

  - Implement commands that encapsulate a sequence of operations, useful for batch updates or complex actions.

- **Command Logging:**

  - Enhance commands to log actions for auditing or debugging purposes.

---

**Example of a Composite Command (`CompositeCommand`):**

```java
public class CompositeCommand implements Command {
    private List<Command> commands = new ArrayList<>();

    public void addCommand(Command command) {
        commands.add(command);
    }

    @Override
    public void execute() {
        for (Command cmd : commands) {
            cmd.execute();
        }
    }

    @Override
    public void unexecute() {
        ListIterator<Command> iterator = commands.listIterator(commands.size());
        while (iterator.hasPrevious()) {
            Command cmd = iterator.previous();
            cmd.unexecute();
        }
    }
}
```

- **Usage:**
  - Allows grouping multiple commands into one, executing them together.
  - Ensures that all commands can be undone in reverse order if needed.

---

**Conclusion:**

The `AddTaskCommand`, `DeleteTaskCommand`, and `UpdateTaskCommand` classes effectively implement the **Command Pattern** by encapsulating task operations as objects. This design provides a robust framework for executing actions, enabling features like undo/redo, and improving the maintainability and scalability of the application.

By using these concrete commands, the application benefits from:

- **Modularity:** Each command is responsible for a single operation.
- **Flexibility:** Commands can be extended or modified without affecting other parts of the system.
- **Ease of Testing:** Commands can be tested in isolation, improving code quality.

---

**Next Steps:**

1. **Implement Additional Commands:**

  - Based on application requirements, implement other concrete commands to handle different operations.

2. **Enhance Error Handling:**

  - Ensure that all commands properly handle exceptions and edge cases.

3. **Optimize Performance:**

  - Review the command execution flow to identify and optimize any performance bottlenecks.

4. **User Interface Integration:**

  - If applicable, update the client-side or front-end application to utilize the undo/redo functionality provided by the commands.

5. **Documentation:**

  - Document the command implementations and how they should be used within the application.

---

By completing the implementation and explanation of `AddTaskCommand`, `DeleteTaskCommand`, and `UpdateTaskCommand`, we have further advanced our simple Java web service application. This demonstrates how concrete implementations of the **Command Pattern** can be effectively utilized to encapsulate actions, provide advanced features like undo/redo, and enhance the overall architecture within a limited number of classes.

---

-------------------------

**Implementation of `CommandInvoker` (Invoker in Command Pattern)**

---

**Purpose of `CommandInvoker`:**

The `CommandInvoker` class acts as the invoker in the **Command Pattern**. It is responsible for executing commands and can also maintain a history of executed commands for potential undo functionality. By centralizing command execution, the `CommandInvoker` decouples the command initiation (where the command is created) from the command execution (where the command is actually carried out), promoting loose coupling and flexibility in the application design.

---

**Command Pattern Overview:**

- **Invoker:** The object that knows how to execute a command but not how the command is implemented. It holds a command and at some point asks the command to carry out a request by calling its `execute()` method.
- **Command:** Declares an interface for executing an operation.
- **ConcreteCommand:** Implements the `Command` interface; binds a receiver object to an action.
- **Receiver:** Knows how to perform the operations associated with carrying out a request.

---

**Implementation Details:**

**1. `CommandInvoker` Class:**

```java
import java.util.ArrayDeque;
import java.util.Deque;

public class CommandInvoker {
    private Deque<Command> commandHistory = new ArrayDeque<>();
    private Deque<Command> redoStack = new ArrayDeque<>();

    public void executeCommand(Command command) {
        command.execute();
        commandHistory.push(command);
        redoStack.clear(); // Clear redo stack after executing a new command
    }

    public void undo() {
        if (!commandHistory.isEmpty()) {
            Command command = commandHistory.pop();
            if (command instanceof UndoableCommand) {
                ((UndoableCommand) command).unexecute();
                redoStack.push(command);
            } else {
                // If the command is not undoable, handle it accordingly
                System.out.println("Command cannot be undone.");
            }
        } else {
            System.out.println("No commands to undo.");
        }
    }

    public void redo() {
        if (!redoStack.isEmpty()) {
            Command command = redoStack.pop();
            command.execute();
            commandHistory.push(command);
        } else {
            System.out.println("No commands to redo.");
        }
    }
}
```

---

**Explanation:**

1. **Fields:**
  - `commandHistory`: A stack (using `Deque` for efficient push/pop operations) that stores executed commands for undo functionality.
  - `redoStack`: A stack that stores commands that have been undone, allowing them to be redone.

2. **Methods:**
  - `executeCommand(Command command)`: Executes the given command by calling its `execute()` method, then pushes it onto the `commandHistory` stack. Clears the `redoStack` because a new command execution invalidates the redo history.
  - `undo()`: Pops the last command from `commandHistory`, calls its `unexecute()` method if it's an `UndoableCommand`, and pushes it onto the `redoStack`. If the command is not undoable, it outputs a message.
  - `redo()`: Pops a command from the `redoStack`, re-executes it, and pushes it back onto the `commandHistory`.

3. **Type Checking:**
  - Before calling `unexecute()`, the `undo()` method checks if the command implements `UndoableCommand`. This ensures that only commands that support undo functionality are undone.

---

**Interfaces:**

**`Command` Interface:**

```java
public interface Command {
    void execute();
}
```

**`UndoableCommand` Interface (Extends `Command`):**

```java
public interface UndoableCommand extends Command {
    void unexecute();
}
```

- **Purpose:**
  - Commands that support undo functionality implement the `UndoableCommand` interface, which includes the `unexecute()` method.

---

**Concrete Commands Implementing `UndoableCommand`:**

**`AddTaskCommand`:**

```java
public class AddTaskCommand implements UndoableCommand {
    private TaskManager taskManager;
    private Task task;

    public AddTaskCommand(TaskManager taskManager, Task task) {
        this.taskManager = taskManager;
        this.task = task;
    }

    @Override
    public void execute() {
        taskManager.createTask(task);
    }

    @Override
    public void unexecute() {
        taskManager.deleteTask(task.getId());
    }
}
```

**`DeleteTaskCommand`:**

```java
public class DeleteTaskCommand implements UndoableCommand {
    private TaskManager taskManager;
    private Task task;

    public DeleteTaskCommand(TaskManager taskManager, UUID taskId) {
        this.taskManager = taskManager;
        this.task = taskManager.getTask(taskId).clone(); // Save current state
    }

    @Override
    public void execute() {
        taskManager.deleteTask(task.getId());
    }

    @Override
    public void unexecute() {
        taskManager.createTask(task);
    }
}
```

**`UpdateTaskCommand`:**

```java
public class UpdateTaskCommand implements UndoableCommand {
    private TaskManager taskManager;
    private Task oldTask;
    private Task newTask;

    public UpdateTaskCommand(TaskManager taskManager, Task newTask) {
        this.taskManager = taskManager;
        this.newTask = newTask;
        this.oldTask = taskManager.getTask(newTask.getId()).clone(); // Save old state
    }

    @Override
    public void execute() {
        taskManager.updateTask(newTask);
    }

    @Override
    public void unexecute() {
        taskManager.updateTask(oldTask);
    }
}
```

---

**Integration with the Application:**

**1. Using `CommandInvoker` in `TaskRequestHandler`:**

```java
public class TaskRequestHandler extends RequestHandler {
    private TaskFactory taskFactory;
    private TaskManager taskManager;
    private CommandInvoker commandInvoker;

    public TaskRequestHandler(DatabaseOperations dbAdapter) {
        super(dbAdapter);
        this.taskFactory = new ConcreteTaskFactory();
        this.taskManager = new TaskManager(dbAdapter);
        this.commandInvoker = new CommandInvoker();
    }

    // Handle POST request to add a new task
    private ResponseData handlePost(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            JSONObject jsonBody = new JSONObject(requestData.getBody());
            Task task = taskFactory.createTask(jsonBody);

            UndoableCommand addTaskCommand = new AddTaskCommand(taskManager, task);
            commandInvoker.executeCommand(addTaskCommand);

            responseData.setStatusCode(201);
            responseData.setData(task.toJson().toString());
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Handle PUT request to update a task
    private ResponseData handlePut(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            Task existingTask = taskManager.getTask(taskId);

            JSONObject jsonBody = new JSONObject(requestData.getBody());
            Task updatedTask = taskFactory.createTask(jsonBody);
            updatedTask.setId(taskId);

            UndoableCommand updateTaskCommand = new UpdateTaskCommand(taskManager, updatedTask);
            commandInvoker.executeCommand(updateTaskCommand);

            responseData.setStatusCode(200);
            responseData.setData(updatedTask.toJson().toString());
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Handle DELETE request to delete a task
    private ResponseData handleDelete(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            UndoableCommand deleteTaskCommand = new DeleteTaskCommand(taskManager, taskId);
            commandInvoker.executeCommand(deleteTaskCommand);

            responseData.setStatusCode(200);
            responseData.setData("Task deleted successfully.");
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Methods to handle undo and redo actions
    private ResponseData handleUndo(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            commandInvoker.undo();
            responseData.setStatusCode(200);
            responseData.setData("Undo successful.");
        } catch (Exception e) {
            responseData.setStatusCode(400);
            responseData.setData("Nothing to undo.");
        }
        return responseData;
    }

    private ResponseData handleRedo(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            commandInvoker.redo();
            responseData.setStatusCode(200);
            responseData.setData("Redo successful.");
        } catch (Exception e) {
            responseData.setStatusCode(400);
            responseData.setData("Nothing to redo.");
        }
        return responseData;
    }
}
```

**Explanation:**

- The `TaskRequestHandler` uses the `CommandInvoker` to execute commands.
- The `commandInvoker` is responsible for executing commands and managing the history for undo/redo.
- When handling undo and redo requests, the handler calls `commandInvoker.undo()` or `commandInvoker.redo()`.

---

**Role of `CommandInvoker`:**

1. **Decouples Command Execution from Initiation:**

  - Command creation happens in the `TaskRequestHandler`.
  - Execution is delegated to the `CommandInvoker`, which manages the execution and history.

2. **Stores Commands for Undo/Redo Functionality:**

  - Maintains a history (`commandHistory`) of executed commands.
  - Provides `undo()` and `redo()` methods to reverse or reapply actions.

3. **Centralizes Command Execution:**

  - All command executions go through the `CommandInvoker`, providing a single point of control.
  - Facilitates logging, auditing, or additional processing when commands are executed.

---

**Advantages of Using `CommandInvoker`:**

1. **Loose Coupling:**

  - Separates command creation from execution, promoting modular design.

2. **Flexibility:**

  - Commands can be queued, scheduled, or executed in different contexts.

3. **Undo/Redo Support:**

  - By storing commands, the invoker provides undo/redo functionality.

4. **Extensibility:**

  - New commands can be added without changing the invoker.

---

**Considerations:**

1. **Thread Safety:**

  - Synchronize access to `commandHistory` and `redoStack` in multi-threaded environments.

2. **Memory Management:**

  - Implement policies to limit history size if necessary.

3. **Error Handling:**

  - Handle exceptions during command execution and undo/redo operations.

4. **Command Granularity:**

  - Decide the appropriate level of granularity for commands.

---

**Alternative Implementation:**

- **Asynchronous Execution:**

  - Modify `CommandInvoker` to execute commands asynchronously using threads or executors.

- **Command Scheduling:**

  - Schedule commands for future execution.

---

**Extending `CommandInvoker`:**

1. **Command Logging:**

  - Log executed commands for auditing or debugging.

2. **Macro Commands:**

  - Support composite commands that consist of multiple commands.

3. **Transaction Management:**

  - Implement transaction-like behavior for groups of commands.

---

**Conclusion:**

The `CommandInvoker` class serves as the invoker in the **Command Pattern**, responsible for executing commands and managing their history for undo/redo functionality. By decoupling command execution from initiation, it promotes loose coupling, enhances flexibility, and centralizes control over command processing.

Key benefits include:

- **Decoupling:** Separates command creation from execution.
- **Undo/Redo Support:** Maintains command history.
- **Extensibility:** Integrates new commands seamlessly.
- **Centralized Control:** Manages command execution in one place.

---

**Next Steps:**

1. **Testing:**

  - Write unit tests for `CommandInvoker`.

2. **Performance Optimization:**

  - Optimize data structures if necessary.

3. **Error Handling Enhancements:**

  - Improve exception handling.

4. **User Interface Integration:**

  - Update client applications to support undo/redo actions.

---

By implementing and explaining the `CommandInvoker`, we have advanced our Java web service application, demonstrating how the invoker in the **Command Pattern** decouples command execution from initiation, provides undo/redo functionality, and enhances the application's architecture within approximately 20 classes.

---
