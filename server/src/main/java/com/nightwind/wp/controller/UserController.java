package com.nightwind.wp.controller;

import com.nightwind.wp.form.UserCredentialsEnter;
import com.nightwind.wp.form.validator.UserCredentialsEnterValidator;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import com.nightwind.wp.domain.User;
import com.nightwind.wp.exception.ValidationException;
import com.nightwind.wp.form.UserCredentialsRegister;
import com.nightwind.wp.form.validator.UserCredentialsRegisterValidator;
import com.nightwind.wp.service.UserService;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api")
public class  UserController {
    private final UserService userService;

    private final UserCredentialsEnterValidator userCredentialsEnterValidator;
    private final UserCredentialsRegisterValidator userCredentialsRegisterValidator;

    public UserController(UserService userService,
                          UserCredentialsEnterValidator userCredentialsEnterValidator,
                          UserCredentialsRegisterValidator userCredentialsRegisterValidator) {
        this.userService = userService;
        this.userCredentialsEnterValidator = userCredentialsEnterValidator;
        this.userCredentialsRegisterValidator = userCredentialsRegisterValidator;
    }

    @InitBinder("userCredentialsEnter")
    public void initEnterBinder(WebDataBinder binder) {
        binder.addValidators(userCredentialsEnterValidator);
    }

    @InitBinder("userCredentialsRegister")
    public void initRegisterBinder(WebDataBinder binder) {
        binder.addValidators(userCredentialsRegisterValidator);
    }

    @PostMapping("users/enter")
    public String findUserJwt(@RequestBody @Valid UserCredentialsEnter userCredentials, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new ValidationException(bindingResult);
        }

        User user = userService.findByLoginAndPassword(userCredentials.getLogin(), userCredentials.getPassword());
        return userService.createUserJwt(user);
    }

    @GetMapping("users/jwt")
    public User findUserByJwt(@RequestParam String jwt) {
        return userService.findByJwt(jwt);
    }

    @GetMapping("users")
    public List<User> findUsers() {
        return this.userService.findAll();
    }

    @PostMapping("users/register")
    public User addUser(@RequestBody @Valid UserCredentialsRegister userCredentials, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new ValidationException(bindingResult);
        }

        return userService.addUserByCredentials(userCredentials);
    }
}
