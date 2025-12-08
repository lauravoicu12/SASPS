package sasps.repository.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sasps.repository.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
}
