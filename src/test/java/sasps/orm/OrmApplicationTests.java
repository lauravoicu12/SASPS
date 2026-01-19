package sasps.orm;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import sasps.orm.entity.User;

import static org.junit.jupiter.api.Assertions.assertEquals;

@DataJpaTest
class OrmApplicationTests {

    @PersistenceContext
    private EntityManager entityManager;

    @Test
    void testPersistAndFindUser() {
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("testuser@example.com");
        entityManager.persist(user);
        entityManager.flush();

        User foundUser = entityManager.find(User.class, user.getId());

        assertEquals("testuser", foundUser.getUsername());
    }
}