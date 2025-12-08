package sasps.repository.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sasps.repository.entity.Task;

public interface TaskRepository extends JpaRepository<Task, Long> {
}

