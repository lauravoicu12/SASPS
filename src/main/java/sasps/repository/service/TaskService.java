package sasps.repository.service;

import org.springframework.stereotype.Service;
import sasps.repository.entity.Task;
import sasps.repository.repository.TaskRepository;

import java.util.List;

@Service
public class TaskService {

    private final TaskRepository taskRepository;

    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    public List<Task> getAll() {
        return taskRepository.findAll();
    }

    public Task getById(Long id) {
        return taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Task not found"));
    }

    public Task create(Task task) {
        return taskRepository.save(task);
    }

    public Task update(Long id, Task updated) {
        Task t = getById(id);

        t.setTitle(updated.getTitle());
        t.setDescription(updated.getDescription());
        t.setStatus(updated.getStatus());
        t.setPriority(updated.getPriority());
        t.setDueDate(updated.getDueDate());
        t.setCompletedAt(updated.getCompletedAt());
        t.setAssigneeId(updated.getAssigneeId());

        return taskRepository.save(t);
    }

    public void delete(Long id) {
        taskRepository.deleteById(id);
    }
}

