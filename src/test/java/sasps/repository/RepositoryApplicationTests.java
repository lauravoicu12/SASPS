package sasps.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import sasps.orm.service.UserService;
import sasps.repository.entity.User;
import sasps.repository.repository.UserRepository;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

class UserRepositoryTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testFindById() {
        User user = new User();
        user.setId(1L);
        user.setUsername("mockuser");

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        sasps.orm.entity.User foundUser = userService.getUserById(1L);

        assertTrue(foundUser.isPresent());
    }
}
