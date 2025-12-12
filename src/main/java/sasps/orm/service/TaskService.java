package sasps.orm.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import sasps.orm.entity.Task;
import sasps.orm.entity.TaskStatus;

import java.util.List;

@Service
@Transactional
public class TaskService {

    @PersistenceContext
    private EntityManager entityManager;

    public List<Task> getAllTasks() {
        return entityManager
                .createQuery("SELECT t FROM Task t", Task.class)
                .getResultList();
    }

    public Task getTaskById(Long id) {
        Task task = entityManager.find(Task.class, id);
        if (task == null) {
            throw new EntityNotFoundException("Task not found: " + id);
        }
        return task;
    }

    public List<Task> getByStatus(TaskStatus status) {
        return entityManager.createQuery(
                        "SELECT t FROM Task t WHERE t.status = :status", Task.class)
                .setParameter("status", status)
                .getResultList();
    }

    public List<Task> getByAssignee(Long assigneeId) {
        return entityManager.createQuery(
                        "SELECT t FROM Task t WHERE t.assigneeId = :assigneeId", Task.class)
                .setParameter("assigneeId", assigneeId)
                .getResultList();
    }

    public Task createTask(Task task) {
        entityManager.persist(task);
        return task;
    }

    public Task updateTask(Long id, Task updated) {
        Task task = getTaskById(id);

        task.setTitle(updated.getTitle());
        task.setDescription(updated.getDescription());
        task.setStatus(updated.getStatus());
        task.setPriority(updated.getPriority());
        task.setDueDate(updated.getDueDate());
        task.setCompletedAt(updated.getCompletedAt());
        task.setAssigneeId(updated.getAssigneeId());

        return task;
    }

    public void deleteTask(Long id) {
        Task task = getTaskById(id);
        entityManager.remove(task);
    }
}