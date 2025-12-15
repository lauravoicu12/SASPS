package sasps.performance;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import sasps.orm.OrmApplication;
import sasps.orm.entity.Task;
import sasps.orm.entity.TaskPriority;
import sasps.orm.entity.TaskStatus;
import sasps.orm.service.TaskService;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@SpringBootTest(classes = OrmApplication.class)
public class OrmPerformanceTest {

    @Autowired
    private TaskService taskService;

    private static final int RECORD_COUNT = 1000;

    @Test
    public void benchmarkOrmPerformance() {
        System.out.println("================ ORM PERFORMANCE TEST ================");

        // 1. Bulk Insert
        long startInsert = System.nanoTime();
        List<Long> ids = new ArrayList<>();
        for (int i = 0; i < RECORD_COUNT; i++) {
            Task task = new Task();
            task.setTitle("Task " + i);
            task.setDescription("Description for task " + i);
            task.setStatus(TaskStatus.TODO);
            task.setPriority(TaskPriority.MEDIUM);
            task.setDueDate(LocalDate.now().plusDays(i % 10));

            taskService.createTask(task);
            ids.add(task.getId());
        }
        long endInsert = System.nanoTime();
        double insertTimeMs = (endInsert - startInsert) / 1_000_000.0;
        System.out.printf("Bulk Insert (%d records): %.2f ms%n", RECORD_COUNT, insertTimeMs);

        // 2. Bulk Read
        long startRead = System.nanoTime();
        List<Task> allTasks = taskService.getAllTasks();
        long endRead = System.nanoTime();
        double readTimeMs = (endRead - startRead) / 1_000_000.0;
        System.out.printf("Bulk Read (%d records): %.2f ms%n", allTasks.size(), readTimeMs);

        // 3. Point Lookup (Random Access)
        long startLookup = System.nanoTime();
        Random random = new Random();
        for (int i = 0; i < RECORD_COUNT; i++) {
            Long randomId = ids.get(random.nextInt(ids.size()));
            taskService.getTaskById(randomId);
        }
        long endLookup = System.nanoTime();
        double lookupTimeMs = (endLookup - startLookup) / 1_000_000.0;
        System.out.printf("Point Lookup (%d lookups): %.2f ms%n", RECORD_COUNT, lookupTimeMs);

        // Cleanup
        // Note: In a real scenario we might rely on @Transactional rollback or recreate
        // DB,
        // but for this simple benchmark we'll just leave them or delete manually if
        // needed.
        // For accurate repeated runs, database should be reset.

        System.out.println("======================================================");
    }
}
