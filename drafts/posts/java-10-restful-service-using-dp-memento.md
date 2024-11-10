**Implementation of `UndoManager` Using the Memento Pattern**

---

**Purpose of `UndoManager`:**

The `UndoManager` class implements undo and redo functionality using the **Memento Pattern**. The Memento Pattern captures and externalizes an object's internal state without violating encapsulation, so that the object can be restored to this state later. In the context of our task management application, the `UndoManager` stores snapshots (mementos) of `Task` states, enabling the application to undo and redo changes to tasks.

---

**Memento Pattern Overview:**

- **Intent:** Without violating encapsulation, capture and externalize an object's internal state so that the object can be restored to this state later.
- **Participants:**
  - **Memento:** Stores internal state of the Originator object. The memento may store as much or as little of the originator's internal state as necessary.
  - **Originator:** Creates a memento containing a snapshot of its current internal state and uses the memento to restore its internal state.
  - **Caretaker:** Responsible for the memento's safekeeping and does not operate on or examine the contents of a memento.

---

**Implementation Details:**

**1. `TaskMemento` Class (Memento):**

```java
public class TaskMemento {
    private final UUID id;
    private final String title;
    private final String description;
    private final String assignedTo;
    private final int priority;
    private final String stateName;

    public TaskMemento(UUID id, String title, String description, String assignedTo, int priority, String stateName) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.assignedTo = assignedTo;
        this.priority = priority;
        this.stateName = stateName;
    }

    // Getters for all fields
    public UUID getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getAssignedTo() { return assignedTo; }
    public int getPriority() { return priority; }
    public String getStateName() { return stateName; }
}
```

- **Purpose:**
  - Stores the state of a `Task` object.
  - Contains all the necessary fields to restore a `Task` to a previous state.
  - Is immutable to ensure the integrity of the stored state.

---

**2. Modifying `Task` Class (Originator):**

```java
public class Task implements Cloneable {
    private UUID id;
    private String title;
    private String description;
    private String assignedTo;
    private int priority;
    private String stateName;

    // Existing methods...

    // Method to create a memento of the current state
    public TaskMemento saveToMemento() {
        return new TaskMemento(id, title, description, assignedTo, priority, stateName);
    }

    // Method to restore state from a memento
    public void restoreFromMemento(TaskMemento memento) {
        this.id = memento.getId();
        this.title = memento.getTitle();
        this.description = memento.getDescription();
        this.assignedTo = memento.getAssignedTo();
        this.priority = memento.getPriority();
        this.stateName = memento.getStateName();
    }

    // Existing methods...
}
```

- **Purpose:**
  - Acts as the Originator in the Memento Pattern.
  - Provides methods to create a memento (`saveToMemento`) and restore from a memento (`restoreFromMemento`).
  - Ensures that the task's state can be captured and restored without violating encapsulation.

---

**3. `UndoManager` Class (Caretaker):**

```java
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;
import java.util.UUID;

public class UndoManager {
    // Map of Task ID to stacks of mementos
    private Map<UUID, Stack<TaskMemento>> undoHistory = new HashMap<>();
    private Map<UUID, Stack<TaskMemento>> redoHistory = new HashMap<>();

    // Save state before a change
    public void saveState(Task task) {
        UUID taskId = task.getId();
        TaskMemento memento = task.saveToMemento();

        undoHistory.putIfAbsent(taskId, new Stack<>());
        undoHistory.get(taskId).push(memento);

        // Clear redo history since new changes invalidate the redo stack
        redoHistory.remove(taskId);
    }

    // Undo the last change
    public void undo(Task task) {
        UUID taskId = task.getId();
        if (undoHistory.containsKey(taskId) && !undoHistory.get(taskId).isEmpty()) {
            // Save current state to redo history
            redoHistory.putIfAbsent(taskId, new Stack<>());
            redoHistory.get(taskId).push(task.saveToMemento());

            // Restore state from memento
            TaskMemento memento = undoHistory.get(taskId).pop();
            task.restoreFromMemento(memento);
        } else {
            System.out.println("No actions to undo for task " + taskId);
        }
    }

    // Redo the last undone change
    public void redo(Task task) {
        UUID taskId = task.getId();
        if (redoHistory.containsKey(taskId) && !redoHistory.get(taskId).isEmpty()) {
            // Save current state to undo history
            undoHistory.putIfAbsent(taskId, new Stack<>());
            undoHistory.get(taskId).push(task.saveToMemento());

            // Restore state from memento
            TaskMemento memento = redoHistory.get(taskId).pop();
            task.restoreFromMemento(memento);
        } else {
            System.out.println("No actions to redo for task " + taskId);
        }
    }
}
```

- **Purpose:**
  - Acts as the Caretaker in the Memento Pattern.
  - Manages the history of mementos for each task.
  - Provides methods to save the state before changes, and to undo and redo changes.
- **Implementation Details:**
  - **Data Structures:**
    - `undoHistory`: A map of task IDs to stacks of mementos for undo operations.
    - `redoHistory`: A map of task IDs to stacks of mementos for redo operations.
  - **Methods:**
    - `saveState(Task task)`: Saves the current state of the task before a change.
    - `undo(Task task)`: Restores the task's previous state from the undo history.
    - `redo(Task task)`: Restores the task's state from the redo history.

---

**4. Integration with `TaskManager` and Commands:**

To use the `UndoManager`, we need to integrate it into the operations that modify tasks.

**`TaskManager` Class:**

```java
public class TaskManager {
    private DatabaseOperations dbAdapter;
    private UndoManager undoManager;

    public TaskManager(DatabaseOperations dbAdapter, UndoManager undoManager) {
        this.dbAdapter = dbAdapter;
        this.undoManager = undoManager;
    }

    public void createTask(Task task) {
        dbAdapter.saveTask(task);
    }

    public void updateTask(Task task) {
        // Save current state before updating
        undoManager.saveState(task);

        dbAdapter.updateTask(task);
    }

    public void deleteTask(UUID taskId) {
        Task task = dbAdapter.getTask(taskId);
        if (task != null) {
            // Save current state before deletion
            undoManager.saveState(task);

            dbAdapter.deleteTask(taskId);
        }
    }

    public Task getTask(UUID taskId) {
        return dbAdapter.getTask(taskId);
    }

    // Methods to undo and redo
    public void undo(UUID taskId) {
        Task task = dbAdapter.getTask(taskId);
        if (task != null) {
            undoManager.undo(task);
            dbAdapter.updateTask(task); // Persist the restored state
        }
    }

    public void redo(UUID taskId) {
        Task task = dbAdapter.getTask(taskId);
        if (task != null) {
            undoManager.redo(task);
            dbAdapter.updateTask(task); // Persist the restored state
        }
    }
}
```

- **Explanation:**
  - The `TaskManager` now depends on the `UndoManager`.
  - Before updating or deleting a task, it calls `undoManager.saveState(task)` to save the current state.
  - Provides methods `undo(taskId)` and `redo(taskId)` to perform undo and redo operations.
  - After restoring a task's state, it updates the database to persist the changes.

---

**5. Modifying Command Implementations:**

We can adjust our commands to use the `UndoManager` for undo functionality.

**`UpdateTaskCommand` Using Memento:**

```java
public class UpdateTaskCommand implements Command {
    private TaskManager taskManager;
    private Task task;

    public UpdateTaskCommand(TaskManager taskManager, Task task) {
        this.taskManager = taskManager;
        this.task = task;
    }

    @Override
    public void execute() {
        taskManager.updateTask(task);
    }
}
```

- **Explanation:**
  - Since the `UndoManager` handles state saving, the command no longer needs to store the old state.
  - The `execute` method calls `taskManager.updateTask(task)`, which handles state saving via `UndoManager`.

**Undo and Redo Commands:**

To invoke undo and redo, we can create specific commands.

**`UndoCommand`:**

```java
public class UndoCommand implements Command {
    private TaskManager taskManager;
    private UUID taskId;

    public UndoCommand(TaskManager taskManager, UUID taskId) {
        this.taskManager = taskManager;
        this.taskId = taskId;
    }

    @Override
    public void execute() {
        taskManager.undo(taskId);
    }
}
```

**`RedoCommand`:**

```java
public class RedoCommand implements Command {
    private TaskManager taskManager;
    private UUID taskId;

    public RedoCommand(TaskManager taskManager, UUID taskId) {
        this.taskManager = taskManager;
        this.taskId = taskId;
    }

    @Override
    public void execute() {
        taskManager.redo(taskId);
    }
}
```

---

**6. Integration with `TaskRequestHandler`:**

```java
public class TaskRequestHandler extends RequestHandler {
    private TaskFactory taskFactory;
    private TaskManager taskManager;
    private CommandInvoker commandInvoker;

    public TaskRequestHandler(DatabaseOperations dbAdapter, UndoManager undoManager) {
        super(dbAdapter);
        this.taskFactory = new ConcreteTaskFactory();
        this.taskManager = new TaskManager(dbAdapter, undoManager);
        this.commandInvoker = new CommandInvoker();
    }

    // Handle PUT request to update a task
    private ResponseData handlePut(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            Task existingTask = taskManager.getTask(taskId);
            if (existingTask == null) {
                responseData.setStatusCode(404);
                responseData.setData("Task not found.");
                return responseData;
            }

            JSONObject jsonBody = new JSONObject(requestData.getBody());
            Task updatedTask = taskFactory.createTask(jsonBody);
            updatedTask.setId(taskId);

            Command updateTaskCommand = new UpdateTaskCommand(taskManager, updatedTask);
            commandInvoker.executeCommand(updateTaskCommand);

            responseData.setStatusCode(200);
            responseData.setData(updatedTask.toJson().toString());
        } catch (Exception e) {
            // Handle exceptions
        }
        return responseData;
    }

    // Handle undo request
    private ResponseData handleUndo(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            Command undoCommand = new UndoCommand(taskManager, taskId);
            commandInvoker.executeCommand(undoCommand);

            responseData.setStatusCode(200);
            responseData.setData("Undo successful.");
        } catch (Exception e) {
            responseData.setStatusCode(400);
            responseData.setData("Undo failed.");
        }
        return responseData;
    }

    // Handle redo request
    private ResponseData handleRedo(RequestData requestData) {
        ResponseData responseData = new ResponseData();
        try {
            UUID taskId = UUID.fromString(requestData.getQueryParams().get("id"));
            Command redoCommand = new RedoCommand(taskManager, taskId);
            commandInvoker.executeCommand(redoCommand);

            responseData.setStatusCode(200);
            responseData.setData("Redo successful.");
        } catch (Exception e) {
            responseData.setStatusCode(400);
            responseData.setData("Redo failed.");
        }
        return responseData;
    }

    // Other methods...
}
```

- **Explanation:**
  - The `TaskRequestHandler` handles undo and redo requests by creating `UndoCommand` and `RedoCommand` and executing them via the `CommandInvoker`.
  - The `TaskManager` handles the actual undo and redo logic using the `UndoManager`.

---

**Advantages of Using the Memento Pattern for Undo Functionality:**

1. **Encapsulation:**

  - The internal state of the `Task` object is captured and restored without exposing its implementation details.
  - The `TaskMemento` class contains only the data necessary to restore the state.

2. **State Preservation:**

  - The exact state of the object at a particular time is preserved, allowing for precise undo and redo operations.

3. **Decoupling:**

  - The `UndoManager` (Caretaker) does not need to know the specifics of the `Task`'s implementation.

4. **Simplification:**

  - Commands no longer need to store previous states, reducing complexity in command classes.

---

**Considerations:**

1. **Memory Usage:**

  - Storing mementos can consume significant memory if tasks are large or if there are many tasks with frequent changes.
  - Implement strategies to limit the size of the history or to compress mementos.

2. **Granularity:**

  - Decide on the granularity of state saving. Should every change be saved, or only certain actions?
  - This affects both memory usage and the user's ability to undo actions.

3. **Immutable Mementos:**

  - Ensure that mementos are immutable to prevent accidental changes to the saved state.

4. **Thread Safety:**

  - If the application is multi-threaded, synchronize access to shared data structures.

5. **Persistence (Optional):**

  - For long-running applications or those requiring persistence across restarts, consider storing mementos in a database or file.

---

**Possible Enhancements:**

1. **Limit History Size:**

  - Implement a maximum size for the undo and redo stacks to prevent excessive memory usage.

2. **Composite Mementos:**

  - For operations that affect multiple tasks, create composite mementos to capture the state of all involved tasks.

3. **Selective Undo:**

  - Allow users to undo specific actions out of order, requiring more complex management of dependencies.

4. **Serialization of Mementos:**

  - Enable mementos to be serialized for persistence or network transmission.

---

**Comparison with Command Pattern for Undo:**

- **Command Pattern Undo:**
  - Commands encapsulate both the action and its inverse.
  - Commands manage their own undo logic.
  - May require storing previous states or implementing inverse operations.

- **Memento Pattern Undo:**
  - Separates state saving from commands.
  - The Originator (e.g., `Task`) is responsible for saving and restoring its state.
  - Simplifies commands but requires additional memory for mementos.

---

**Conclusion:**

By implementing the `UndoManager` using the **Memento Pattern**, we have provided a robust mechanism for undoing and redoing changes to tasks in our application. This approach captures the state of `Task` objects without violating encapsulation and allows for precise restoration of previous states.

Key benefits include:

- **Encapsulation of State:**
  - Mementos capture the internal state without exposing implementation details.

- **Simplified Command Classes:**
  - Commands no longer need to manage previous states, reducing complexity.

- **Flexible Undo/Redo Mechanism:**
  - The `UndoManager` can handle undo and redo operations for multiple tasks independently.

---

**Next Steps:**

1. **Testing:**

  - Write unit tests to verify that the memento-based undo and redo functionality works as expected.

2. **Performance Optimization:**

  - Monitor memory usage and optimize data structures or implement history size limits.

3. **Error Handling Enhancements:**

  - Improve exception handling in the `UndoManager` and related classes.

4. **User Interface Integration:**

  - Update client applications or front-end interfaces to support the new undo/redo functionality.

5. **Documentation:**

  - Document how the undo/redo functionality works and how to use it within the application.

---

**Final Thoughts:**

The Memento Pattern provides a clean and effective way to implement undo and redo functionality by capturing the state of objects at specific points in time. In our task management application, integrating the Memento Pattern enhances the user experience by allowing users to revert changes, and it improves the maintainability of the codebase by separating state management from command execution.

By completing the implementation and explanation of `UndoManager` using the Memento Pattern, we have further advanced our Java web service application, demonstrating how design patterns can be effectively utilized to solve complex problems within a limited number of classes.

---
