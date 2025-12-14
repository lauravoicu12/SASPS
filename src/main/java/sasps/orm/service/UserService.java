package sasps.orm.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import sasps.orm.entity.User;

import java.util.List;

@Service
public class UserService {

    @PersistenceContext
    private EntityManager entityManager;

    public List<User> getAllUsers() {
        return entityManager.createQuery("SELECT u FROM User u", User.class).getResultList();
    }

    public User getUserById(Long id) {
        User user = entityManager.find(User.class, id);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        return user;
    }

    @Transactional
    public User createUser(User user) {
        entityManager.persist(user);
        return user;
    }

    @Transactional
    public User updateUser(Long id, User updated) {
        User user = getUserById(id);

        user.setUsername(updated.getUsername());
        user.setEmail(updated.getEmail());
        user.setFullName(updated.getFullName());

        return entityManager.merge(user);
    }

    @Transactional
    public void deleteUser(Long id) {
        User user = getUserById(id);
        entityManager.remove(user);
    }
}
