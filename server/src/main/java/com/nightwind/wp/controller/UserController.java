package com.nightwind.wp.controller;

import com.nightwind.wp.domain.User;
import com.nightwind.wp.form.UserCredentialsEnter;
import com.nightwind.wp.form.UserCredentialsRegister;
import com.nightwind.wp.service.UserService;
import com.nightwind.wp.form.validator.UserCredentialsEnterValidator;
import com.nightwind.wp.form.validator.UserCredentialsRegisterValidator;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.nightwind.wp.utils.Utils.getValidationErrors;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequestMapping("/api")
@SuppressWarnings("unused")
public class UserController {
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

    @Operation(summary = "Authenticate user and retrieve JWT",
            description = "Validates user credentials and returns a JWT if successful.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "JWT retrieved successfully"),
            @ApiResponse(responseCode = "400", description = "Validation errors"),
            @ApiResponse(responseCode = "401", description = "Wrong login or password")
    })
    @PostMapping("users/enter")
    public ResponseEntity<Object> findUserJwt(
            @Parameter(description = "User credentials for login", required = true)
            @RequestBody @Valid UserCredentialsEnter userCredentials,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body(getValidationErrors(bindingResult));  // 400 Bad Request
        }

        User user = userService.findByLoginAndPassword(userCredentials.getLogin(), userCredentials.getPassword());
        if (user == null) {
            return ResponseEntity.status(401).body("Wrong login or password.");  // 401 Unauthorized
        }

        String jwt = userService.createUserJwt(user);
        return ResponseEntity.ok(jwt);  // 200 OK
    }

    @Operation(summary = "Retrieve user by JWT",
            description = "Finds a user based on the provided JWT.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User retrieved successfully"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    @GetMapping("users/jwt")
    public ResponseEntity<User> findUserByJwt(
            @Parameter(description = "JWT for the user", required = true)
            @RequestParam String jwt) {
        User user = userService.findByJwt(jwt);
        if (user == null) {
            return ResponseEntity.notFound().build();  // 404 Not Found
        }
        return ResponseEntity.ok(user);  // 200 OK
    }

    @Operation(summary = "Retrieve all users",
            description = "Fetches a list of all registered users.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved users")
    })
    @GetMapping("users")
    public ResponseEntity<List<User>> findUsers() {
        List<User> users = this.userService.findAll();
        return ResponseEntity.ok(users);  // 200 OK
    }

    @Operation(summary = "Register a new user",
            description = "Creates a new user account using the provided credentials.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "User created successfully"),
            @ApiResponse(responseCode = "400", description = "Validation errors")
    })
    @PostMapping("users/register")
    public ResponseEntity<Object> addUser(
            @Parameter(description = "User credentials for registration", required = true)
            @RequestBody @Valid UserCredentialsRegister userCredentials,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body(getValidationErrors(bindingResult));  // 400 Bad Request
        }

        User newUser = userService.addUserByCredentials(userCredentials);
        return ResponseEntity.status(201).body(newUser);  // 201 Created
    }
}
